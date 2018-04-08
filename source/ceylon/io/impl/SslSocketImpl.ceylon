/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
import ceylon.buffer {
    ByteBuffer
}
import ceylon.io {
    SslSocket
}

import java.lang {
    ObjectArray
}
import java.nio {
    JavaByteBuffer=ByteBuffer {
        allocateJavaByteBuffer=allocate
    }
}
import java.nio.channels {
    SocketChannel,
    SelectionKey,
    Selector
}
import java.security.cert {
    X509Certificate
}

import javax.net.ssl {
    X509TrustManager,
    SSLContext,
    SSLEngine,
    TrustManager,
    SSLEngineResult {
        Status,
        HandshakeStatus
    }
}

object dummyTrustManager satisfies X509TrustManager {

    acceptedIssuers
            => ObjectArray<X509Certificate>(0);
    
    checkClientTrusted(ObjectArray<X509Certificate> chain, String authType)
            => debug("UNKNOWN CLIENT CERTIFICATE: ``chain.get(0).subjectDN``");
    
    checkServerTrusted(ObjectArray<X509Certificate> chain, String authType)
            => debug("UNKNOWN SERVER CERTIFICATE: ``chain.get(0).subjectDN``");
}

JavaByteBuffer emptyBuf = allocateJavaByteBuffer(0);

ObjectArray<TrustManager> makeObjectArray({TrustManager*} items) {
    value seq = items.sequence();
    value ret = ObjectArray<TrustManager>(seq.size);
    variable Integer i = 0;
    for(item in seq) {
        ret[i++] = item;
    }
    return ret;
}

ObjectArray<TrustManager> dummyTrustManagers 
        = makeObjectArray{dummyTrustManager};

shared interface DataNeeds 
        of dataNeedsOk | dataNeedsNeedsData | dataNeedsEndOfFile {}
shared object dataNeedsEndOfFile satisfies DataNeeds {}
shared object dataNeedsNeedsData satisfies DataNeeds {}
shared object dataNeedsOk satisfies DataNeeds {}

class SslSocketImpl(SocketChannel socket) 
        extends SocketImpl(socket) 
        satisfies SslSocket {
    
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
        assert(is JavaByteBuffer impl = contents.implementation);
        // nothing to write
        if(!contents.hasAvailable) {
            return 0;
        }

        if(writePendingData() == dataNeedsNeedsData) {
            return 0;
        }
        
        while(contents.hasAvailable) {
            SSLEngineResult result = sslEngine.wrap(impl, writeNetBuf);
            switch(status = result.status)
            case(Status.bufferOverflow) {
                // not enough space in the net buffer
                debug("Buffer overflow");
                writeNetBuf = allocateJavaByteBuffer(writeNetBuf.capacity()*2);
            }case(Status.bufferUnderflow) {
                throw Exception("Buffer underflow");
            }case(Status.closed) {
                throw Exception("Buffer closed");
            }case(Status.ok) {
                debug("wrapped OK");

                // leave contents buf as it is: if we still have things to read from it then fine

                // write the net data
                writeNetBuf.flip();
                hasDataToWrite_ = writeNetBuf.hasRemaining();
                // try to flush as much net data as possible
                if(flushNetBuffer() == dataNeedsNeedsData) {
                    // we can't write it all
                    // FIXME: how much did we write in total?
                    return 0;
                }
                // see if we need to send more app data
            }
            // now check handshaking status
            switch(handshake(result.handshakeStatus))
            case(dataNeedsEndOfFile) {
                throw Exception("EOF");
            }
            case(dataNeedsNeedsData) {
                return 0;
            }
            case(dataNeedsOk) {
                // go on
            }
        }
        return 0;
    }

    DataNeeds checkForHandshake() {
        value handshakeStatus = sslEngine.handshakeStatus;
        if(handshakeStatus != HandshakeStatus.finished
        && handshakeStatus != HandshakeStatus.notHandshaking) {
            // do the handshake
            return handshake(handshakeStatus);
        }
        return dataNeedsOk;
    }

    DataNeeds flushNetBuffer() {
        // first try to get rid of whatever we already have
        while(writeNetBuf.hasRemaining()) {
            Integer written = socket.write(writeNetBuf);
            if(written == -1) {
                throw Exception("EOF");
            }
            if(written == 0) {
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
        case (dataNeedsNeedsData) {
            return dataNeedsNeedsData;
        }
        case (dataNeedsEndOfFile) {
            throw Exception("EOF");
        }
        case (dataNeedsOk) {
            // go on
        }
        // at this point the handshake is over and we're good to write stuff
        
        // do we have stuff remaining to write?
        if(hasDataToWrite_
            && flushNetBuffer() == dataNeedsNeedsData) {
            return dataNeedsNeedsData;
        }
        return dataNeedsOk;
    }
    
    shared DataNeeds readForHandshake() => checkForHandshake();

    shared actual Integer read(ByteBuffer contents) {
        assert(is JavaByteBuffer impl = contents.implementation);
        
        // no place left?
        if(!contents.hasAvailable) {
            return 0;
        }
        
        // are we in the middle of a handshake?
        switch(checkForHandshake())
        case(dataNeedsEndOfFile) {
            return -1;
        }
        case (dataNeedsNeedsData) {
            return 0;
        }
        case (dataNeedsOk) {
            // go on
        }
        // at this point the handshake is over and we're good to read stuff

        // did we have user data left over?
        if(hasAppData) {
            // put whatever fits
            Integer transfer = putAppData(contents);
            // stop here it's good enough
            return transfer;
        }
        
        // at this point we have no more app data and we have space to read something in
        //READ:
        while(true) {
            if(!hasReadNetData || needMoreData) {
                Integer read = socket.read(readNetBuf);
                debug("Read ``read`` bytes");
                if(read == -1) {
                    sslEngine.closeInbound();
                    return -1;
                }
                if(read == 0) {
                    return 0; // wait for more data
                }
            }
            // start reading from it 
            readNetBuf.flip();
            
            debug("unwrapping ``readNetBuf`` / ``readAppBuf``");
            value result = sslEngine.unwrap(readNetBuf, readAppBuf);
            debug("unwrapped ``readNetBuf`` / ``readAppBuf``");

            switch(status = result.status)
            case(Status.bufferOverflow) {
                throw Exception("Buffer overflow");
            }case(Status.bufferUnderflow) {
                debug("Buffer underflow");
                hasReadNetData = readNetBuf.hasRemaining();
                if(hasReadNetData) {
                    // put what remains at the start as if we just read it
                    readNetBuf.compact();
                }else{
                    readNetBuf.clear();
                }
                // need to read more data, start over
                needMoreData = true;
                continue;
            }case(Status.ok
                 |Status.closed) {
                debug("unwrapped OK, remaining net bytes: ``readNetBuf.position()``");
                hasReadNetData = readNetBuf.hasRemaining();
                if(hasReadNetData) {
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

    Integer putAppData(ByteBuffer contents) {
        assert(is JavaByteBuffer impl = contents.implementation);
        Integer transfer = smallest(contents.available, readAppBuf.remaining());
        debug("Transferring ``transfer`` bytes to user buffer from app buffer position ``readAppBuf.position()``");
        impl.put(readAppBuf.array(), readAppBuf.position(), transfer);
        // advance the app buf by as much
        readAppBuf.position(readAppBuf.position()+transfer);
        debug("New app buffer position: ``readAppBuf.position()``");
        // check if we're done
        if(!readAppBuf.hasRemaining()) {
            debug("App buffer empty");
            hasAppData = false;
            readAppBuf.clear();
        }else{
            debug("App buffer still has ``readAppBuf.remaining()`` bytes left");
        }
        return transfer;
    }

    DataNeeds handshake(status) {
        variable HandshakeStatus status;
        //HANDSHAKE:
        while(true) {
            debug("Handshake status: ``status``");
            switch (status)
            case(HandshakeStatus.notHandshaking) {
                debug("Not handshaking");
                userOps();
                return dataNeedsOk;
            }case(HandshakeStatus.finished) {
                debug("Handshake finished");
                userOps();
                return dataNeedsOk;
            }case(HandshakeStatus.needTask) {
                debug("Handshake needs task");
                runTasks();
                status = sslEngine.handshakeStatus;
                continue;
            }case(HandshakeStatus.needUnwrap) {
                // read data
                //READ:
                while(true) {
                    // if we have nothing in our net buffer or if it's not enough
                    if(!hasReadNetData || needMoreData) {
                        // read new or append to existing
                        Integer read = socket.read(readNetBuf);
                        debug("unwrap read bytes: ``read``");
                        if(read == -1) {
                            throw Exception("EOF");
                        }
                        if(read == 0) {
                            // no data to unwrap, must get some more
                            selectOps(SelectionKey.opRead);
                            return dataNeedsNeedsData;
                        }
                    }
                    // put it in reading mode
                    readNetBuf.flip();
                    value result = sslEngine.unwrap(readNetBuf, readAppBuf);
                    debug("read net buf: ``readNetBuf``");
                    debug("read app buf: ``readAppBuf``");
                    switch(resultStatus = result.status)
                    case(Status.bufferOverflow) {
                        throw Exception("Buffer overflow");
                    }case(Status.bufferUnderflow) {
                        debug("Handshake unwrap buffer underflow");
                        hasReadNetData = readNetBuf.hasRemaining();
                        if(hasReadNetData) {
                            // put what remains at the start as if we just read it
                            readNetBuf.compact();
                        }else{
                            readNetBuf.clear();
                        }
                        // need to read more data, start over
                        needMoreData = true;
                    }case(Status.closed) {
                        throw Exception("EOF");
                    }case(Status.ok) {
                        hasReadNetData = readNetBuf.hasRemaining();
                        if(hasReadNetData) {
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
            }case(HandshakeStatus.needWrap) {
                // we need to send data, not our own
                //WRITE:
                while(true) {
                    debug("Wrapping empty buffer");
                    // assume we are good to write
                    variable value resultStatus = Status.ok;
                    // get something to write if we have nothing
                    if(!hasDataToWrite_) {
                        value result = sslEngine.wrap(emptyBuf, writeNetBuf);
                        writeNetBuf.flip();
                        resultStatus = result.status;
                    }
                    
                    switch (resultStatus)
                    case(Status.bufferOverflow) {
                        // not enough space in the net buffer
                        debug("Buffer overflow");
                        writeNetBuf = allocateJavaByteBuffer(writeNetBuf.capacity()*2);
                        continue;
                    }case(Status.bufferUnderflow) {
                        throw Exception("Buffer underflow");
                    }case(Status.closed) {
                        return dataNeedsEndOfFile;
                    }case(Status.ok) {
                        // check the new handshake status
                        debug("wrap OK");
                        while(writeNetBuf.hasRemaining()) {
                            Integer written = socket.write(writeNetBuf);
                            debug("wrap wrote bytes: ``written``");
                            if(written == -1) {
                                throw Exception("EOF");
                            }
                            // we need to wait for further notification that we can write
                            if(written == 0) {
                                hasDataToWrite_ = true;
                                selectOps(SelectionKey.opWrite);
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
            else {
                //HandshakeStatus.NEED_UNWRAP_AGAIN since JDK 9
                throw Exception("HandshakeStatus.NEED_UNWRAP_AGAIN not yet supported");
            }
        }
    }

    void runTasks() {
        while(exists task = sslEngine.delegatedTask) {
            debug("Running one task");
            task.run();
        }
    }

    shared actual SelectionKey register(Selector selector, Integer ops, Object attachment) {
        value selectionKey = super.register(selector, ops, attachment);
        this.selectionOps = ops;
        // FIXME: make sure that for a client socket we have WRITE ops?
        this.selectionKey = selectionKey;
        return selectionKey;
    }

    void selectOps(Integer ops) {
        debug("select ops ``ops`` for key ``selectionKey else "null"``");
        selectionKey?.interestOps(ops);
    }

    shared actual void interestOps(SelectionKey key, Integer ops) {
        this.selectionOps = ops;
        if(!handshaking) {
            selectionKey?.interestOps(ops);
        }
    }
    
    Boolean handshaking {
        value handshakeStatus = sslEngine.handshakeStatus;
        return handshakeStatus != HandshakeStatus.finished
                && handshakeStatus != HandshakeStatus.notHandshaking;
    }

    void userOps() 
            => selectionKey?.interestOps(this.selectionOps);
    
    shared Boolean dataToWrite 
            => this.hasDataToWrite_ || isHandshakeWrap();

    shared Boolean isHandshakeUnwrap()
            => sslEngine.handshakeStatus == HandshakeStatus.needUnwrap;
    
    Boolean isHandshakeWrap() 
            => sslEngine.handshakeStatus == HandshakeStatus.needWrap;

    shared Boolean dataToRead 
            => this.hasAppData || (this.hasReadNetData && !this.needMoreData);

}
