import ceylon.io {
    SslSocket
}

import java.nio.channels {
    SocketChannel, SelectionKey, Selector
}
import javax.net.ssl { X509TrustManager, SSLContext, SSLEngine, TrustManager, SSLEngineResult  }
import java.security.cert { X509Certificate }
import java.lang { ObjectArray }
import java.nio { JavaByteBuffer = ByteBuffer {allocateJavaByteBuffer = allocate }}
import ceylon.io.buffer { ByteBuffer }
import ceylon.io.buffer.impl { ByteBufferImpl }

object dummyTrustManager satisfies X509TrustManager {

    shared actual ObjectArray<X509Certificate> acceptedIssuers 
            => ObjectArray<X509Certificate>(0);
    
    shared actual void checkClientTrusted(ObjectArray<X509Certificate> chain, String authType) 
            => debug("UNKNOWN CLIENT CERTIFICATE: ``chain.get(0).subjectDN``");
    
    shared actual void checkServerTrusted(ObjectArray<X509Certificate> chain, String authType) 
            => debug("UNKNOWN SERVER CERTIFICATE: ``chain.get(0).subjectDN``");
}

JavaByteBuffer emptyBuf = allocateJavaByteBuffer(0);

ObjectArray<TrustManager> makeObjectArray(Iterable<TrustManager> items) {
    value seq = items.sequence();
    value ret = ObjectArray<TrustManager>(seq.size);
    variable Integer i = 0;
    for(item in seq){
        ret.set(i++, item);
    }
    return ret;
}

ObjectArray<TrustManager> dummyTrustManagers = makeObjectArray{dummyTrustManager};

shared interface DataNeeds of dataNeedsOk | dataNeedsNeedsData | dataNeedsEndOfFile {}
shared object dataNeedsEndOfFile satisfies DataNeeds {}
shared object dataNeedsNeedsData satisfies DataNeeds {}
shared object dataNeedsOk satisfies DataNeeds {}

shared class SslSocketImpl(SocketChannel socket) extends SocketImpl(socket) satisfies SslSocket {
    SSLContext sslContext;
    SSLEngine sslEngine;
    JavaByteBuffer readAppBuf;
    JavaByteBuffer readNetBuf;
    variable JavaByteBuffer writeNetBuf;

    variable SelectionKey? selectionKey = null;
    
    variable Integer selectionOps = 0;

    variable Boolean needMoreData = false;
    variable Boolean hasDataToWrite_ = false;
    variable Boolean hasReadNetData = false;
    variable Boolean hasAppData = false;

    sslContext = SSLContext.getInstance("TLS");
    sslContext.init(null, dummyTrustManagers, null);
    sslEngine = sslContext.createSSLEngine();
    sslEngine.useClientMode = true;
    sslEngine.beginHandshake();
        
    Integer applicationBufferSize = sslEngine.session.applicationBufferSize;
    Integer packetBufferSize = sslEngine.session.packetBufferSize;
    readAppBuf = allocateJavaByteBuffer(applicationBufferSize);
    readNetBuf = allocateJavaByteBuffer(packetBufferSize);
    writeNetBuf = allocateJavaByteBuffer(packetBufferSize);
    
    shared actual Integer write(ByteBuffer contents) {
        assert(is ByteBufferImpl contents);
        // nothing to write
        if(!contents.hasAvailable){
            return 0;
        }

        if(writePendingData() == dataNeedsNeedsData){
            return 0;
        }
        
        while(contents.hasAvailable){
            SSLEngineResult result = sslEngine.wrap(contents.underlyingBuffer, writeNetBuf);
            value status = result.status;
            if(status == SSLEngineResult.Status.\iBUFFER_OVERFLOW){
                // not enough space in the net buffer
                debug("Buffer overflow");
                writeNetBuf = allocateJavaByteBuffer(writeNetBuf.capacity()*2);
            }else if(status == SSLEngineResult.Status.\iBUFFER_UNDERFLOW){
                throw Exception("Buffer underflow");
            }else if(status == SSLEngineResult.Status.\iCLOSED){
                throw Exception("Buffer closed");
            }else if(status == SSLEngineResult.Status.\iOK){
                debug("wrapped OK");

                // leave contents buf as it is: if we still have things to read from it then fine

                // write the net data
                writeNetBuf.flip();
                hasDataToWrite_ = writeNetBuf.hasRemaining();
                // try to flush as much net data as possible
                if(flushNetBuffer() == dataNeedsNeedsData){
                    // we can't write it all
                    // FIXME: how much did we write in total?
                    return 0;
                }
                // see if we need to send more app data
            }
            // now check handshaking status
            switch(handshake(result.handshakeStatus))
            case(dataNeedsEndOfFile){
                throw Exception("EOF");
            }
            case(dataNeedsNeedsData){
                return 0;
            }
            case(dataNeedsOk){
                // go on
            }
        }
        return 0;
    }

    DataNeeds checkForHandshake() {
        SSLEngineResult.HandshakeStatus handshakeStatus = sslEngine.handshakeStatus;
        if(handshakeStatus != SSLEngineResult.HandshakeStatus.\iFINISHED
                && handshakeStatus != SSLEngineResult.HandshakeStatus.\iNOT_HANDSHAKING){
            // do the handshake
            return handshake(handshakeStatus);
        }
        return dataNeedsOk;
    }

    DataNeeds flushNetBuffer() {
        // first try to get rid of whatever we already have
        while(writeNetBuf.hasRemaining()){
            Integer written = socket.write(writeNetBuf);
            if(written == -1){
                throw Exception("EOF");
            }
            if(written == 0){
                return dataNeedsNeedsData; // wait for another write event
            }
        }
        // nothing left, we can clear it and start sending what we have at hand
        hasDataToWrite_ = false;
        writeNetBuf.clear();
        return dataNeedsOk;
    }

    shared DataNeeds writePendingData() {
        // are we in the middle of a handshake?
        switch(checkForHandshake())
        case (dataNeedsNeedsData){
            return dataNeedsNeedsData;
        }
        case (dataNeedsEndOfFile){
            throw Exception("EOF");
        }
        case (dataNeedsOk){
            // go on
        }
        // at this point the handshake is over and we're good to write stuff
        
        // do we have stuff remaining to write?
        if(hasDataToWrite_){
            if(flushNetBuffer() == dataNeedsNeedsData){
                return dataNeedsNeedsData;
            }
        }
        return dataNeedsOk;
    }
    
    shared DataNeeds readForHandshake() => checkForHandshake();

    shared actual Integer read(ByteBuffer contents) {
        assert(is ByteBufferImpl contents);
        
        // no place left?
        if(!contents.hasAvailable){
            return 0;
        }
        
        // are we in the middle of a handshake?
        switch(checkForHandshake())
        case(dataNeedsEndOfFile){
            return -1;
        }
        case (dataNeedsNeedsData){
            return 0;
        }
        case (dataNeedsOk){
            // go on
        }
        // at this point the handshake is over and we're good to read stuff

        // did we have user data left over?
        if(hasAppData){
            // put whatever fits
            Integer transfer = putAppData(contents);
            // stop here it's good enough
            return transfer;
        }
        
        // at this point we have no more app data and we have space to read something in
        //READ:
        while(true){
            if(!hasReadNetData || needMoreData){
                Integer read = socket.read(readNetBuf);
                debug("Read ``read`` bytes");
                if(read == -1){
                    sslEngine.closeInbound();
                    return -1;
                }
                if(read == 0){
                    return 0; // wait for more data
                }
            }
            // start reading from it 
            readNetBuf.flip();
            
            debug("unwrapping ``readNetBuf`` / ``readAppBuf``");
            SSLEngineResult result = sslEngine.unwrap(readNetBuf, readAppBuf);
            debug("unwrapped ``readNetBuf`` / ``readAppBuf``");

            value status = result.status;
            if(status == SSLEngineResult.Status.\iBUFFER_OVERFLOW){
                throw Exception("Buffer overflow");
            }else if(status == SSLEngineResult.Status.\iBUFFER_UNDERFLOW){
                debug("Buffer underflow");
                hasReadNetData = readNetBuf.hasRemaining();
                if(hasReadNetData){
                    // put what remains at the start as if we just read it
                    readNetBuf.compact();
                }else{
                    readNetBuf.clear();
                }
                // need to read more data, start over
                needMoreData = true;
                continue;
            }else if(status == SSLEngineResult.Status.\iOK
                     || status == SSLEngineResult.Status.\iCLOSED){
                debug("unwrapped OK, remaining net bytes: ``readNetBuf.position()``");
                hasReadNetData = readNetBuf.hasRemaining();
                if(hasReadNetData){
                    // put what remains at the start as if we just read it
                    readNetBuf.compact();
                }else{
                    readNetBuf.clear();
                }
                needMoreData = false;

                // now put as much of our app buf into contents
                readAppBuf.flip();
                hasAppData = true;
                Integer transfer = putAppData(contents);
                // we're done
                return transfer;
            }
        }
    }

    Integer putAppData(ByteBufferImpl contents) {
        Integer transfer = min{contents.available, readAppBuf.remaining()};
        debug("Transferring ``transfer`` bytes to user buffer from app buffer position ``readAppBuf.position()``");
        contents.underlyingBuffer.put(readAppBuf.array(), readAppBuf.position(), transfer);
        // advance the app buf by as much
        readAppBuf.position(readAppBuf.position()+transfer);
        debug("New app buffer position: ``readAppBuf.position()``");
        // check if we're done
        if(!readAppBuf.hasRemaining()){
            debug("App buffer empty");
            hasAppData = false;
            readAppBuf.clear();
        }else{
            debug("App buffer still has ``readAppBuf.remaining()`` bytes left");
        }
        return transfer;
    }

    DataNeeds handshake(status) {
        variable SSLEngineResult.HandshakeStatus status;
        //HANDSHAKE:
        while(true){
            debug("Handshake status: ``status``");
            if(status == SSLEngineResult.HandshakeStatus.\iNOT_HANDSHAKING){
                debug("Not handshaking");
                userOps();
                return dataNeedsOk;
            }else if(status == SSLEngineResult.HandshakeStatus.\iFINISHED){
                debug("Handshake finished");
                userOps();
                return dataNeedsOk;
            }else if(status == SSLEngineResult.HandshakeStatus.\iNEED_TASK){
                debug("Handshake needs task");
                runTasks();
                status = sslEngine.handshakeStatus;
                continue;
            }else if(status == SSLEngineResult.HandshakeStatus.\iNEED_UNWRAP){
                // read data
                //READ:
                while(true){
                    // if we have nothing in our net buffer or if it's not enough
                    if(!hasReadNetData || needMoreData){
                        // read new or append to existing
                        Integer read = socket.read(readNetBuf);
                        debug("unwrap read bytes: ``read``");
                        if(read == -1){
                            throw Exception("EOF");
                        }
                        if(read == 0){
                            // no data to unwrap, must get some more
                            selectOps(SelectionKey.\iOP_READ);
                            return dataNeedsNeedsData;
                        }
                    }
                    // put it in reading mode
                    readNetBuf.flip();
                    SSLEngineResult result = sslEngine.unwrap(readNetBuf, readAppBuf);
                    debug("read net buf: ``readNetBuf``");
                    debug("read app buf: ``readAppBuf``");
                    value resultStatus = result.status;
                    if(resultStatus == SSLEngineResult.Status.\iBUFFER_OVERFLOW){
                        throw Exception("Buffer overflow");
                    }else if(resultStatus == SSLEngineResult.Status.\iBUFFER_UNDERFLOW){
                        debug("Handshake unwrap buffer underflow");
                        hasReadNetData = readNetBuf.hasRemaining();
                        if(hasReadNetData){
                            // put what remains at the start as if we just read it
                            readNetBuf.compact();
                        }else{
                            readNetBuf.clear();
                        }
                        // need to read more data, start over
                        needMoreData = true;
                    }else if(resultStatus == SSLEngineResult.Status.\iCLOSED){
                        throw Exception("EOF");
                    }else if(resultStatus == SSLEngineResult.Status.\iOK){
                        hasReadNetData = readNetBuf.hasRemaining();
                        if(hasReadNetData){
                            // put what remains at the start as if we just read it
                            readNetBuf.compact();
                        }else{
                            readNetBuf.clear();
                        }
                        needMoreData = false;
                        debug("Handshake unwrap OK");
                        // check the new handshake status
                        status = result.handshakeStatus;
                        // break of READ and continue on HANDSHAKE
                        break;
                    }
                }
            }else if(status == SSLEngineResult.HandshakeStatus.\iNEED_WRAP){
                // we need to send data, not our own
                //WRITE:
                while(true){
                    debug("Wrapping empty buffer");
                    // assume we are good to write
                    variable value resultStatus = SSLEngineResult.Status.\iOK;
                    // get something to write if we have nothing
                    if(!hasDataToWrite_){
                        SSLEngineResult result = sslEngine.wrap(emptyBuf, writeNetBuf);
                        writeNetBuf.flip();
                        resultStatus = result.status;
                    }
                    
                    if(resultStatus == SSLEngineResult.Status.\iBUFFER_OVERFLOW){
                        // not enough space in the net buffer
                        debug("Buffer overflow");
                        writeNetBuf = allocateJavaByteBuffer(writeNetBuf.capacity()*2);
                        continue;
                    }else if(resultStatus == SSLEngineResult.Status.\iBUFFER_UNDERFLOW){
                        throw Exception("Buffer underflow");
                    }else if(resultStatus == SSLEngineResult.Status.\iCLOSED){
                        return dataNeedsEndOfFile;
                    }else if(resultStatus == SSLEngineResult.Status.\iOK){
                        // check the new handshake status
                        debug("wrap OK");
                        while(writeNetBuf.hasRemaining()){
                            Integer written = socket.write(writeNetBuf);
                            debug("wrap wrote bytes: ``written``");
                            if(written == -1){
                                throw Exception("EOF");
                            }
                            // we need to wait for further notification that we can write
                            if(written == 0){
                                hasDataToWrite_ = true;
                                selectOps(SelectionKey.\iOP_WRITE);
                                return dataNeedsNeedsData;
                            }
                        }
                        writeNetBuf.clear();
                        hasDataToWrite_ = false;
                        status = sslEngine.handshakeStatus;
                        // break WRITE and continue HANDSHAKE
                        break;
                    }
                }
            }
        }
    }

    void runTasks() {
        while(exists task = sslEngine.delegatedTask){
            debug("Running one task");
            task.run();
        }
    }

    shared actual SelectionKey register(Selector selector, Integer ops, Object attachment) {
        SelectionKey selectionKey = super.register(selector, ops, attachment);
        this.selectionOps = ops;
        // FIXME: make sure that for a client socket we have WRITE ops?
        this.selectionKey = selectionKey;
        return selectionKey;
    }

    void selectOps(Integer ops){
        debug("select ops ``ops`` for key ``selectionKey else "null"``");
        selectionKey?.interestOps(ops);
    }

    shared actual void interestOps(SelectionKey key, Integer ops){
        this.selectionOps = ops;
        if(!handshaking){
            selectionKey?.interestOps(ops);
        }
    }
    
    Boolean handshaking {
        SSLEngineResult.HandshakeStatus handshakeStatus = sslEngine.handshakeStatus;
        return handshakeStatus != SSLEngineResult.HandshakeStatus.\iFINISHED 
                && handshakeStatus != SSLEngineResult.HandshakeStatus.\iNOT_HANDSHAKING;
    }

    void userOps(){
        selectionKey?.interestOps(this.selectionOps);
    }
    
    shared Boolean dataToWrite 
            => this.hasDataToWrite_ || isHandshakeWrap();

    shared Boolean isHandshakeUnwrap()
            => sslEngine.handshakeStatus == SSLEngineResult.HandshakeStatus.\iNEED_UNWRAP;
    
    Boolean isHandshakeWrap() 
            => sslEngine.handshakeStatus == SSLEngineResult.HandshakeStatus.\iNEED_WRAP;

    shared Boolean dataToRead 
            => this.hasAppData || (this.hasReadNetData && !this.needMoreData);

}