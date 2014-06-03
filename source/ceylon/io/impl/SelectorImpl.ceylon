import ceylon.io { Selector, Socket, FileDescriptor, SocketConnector, ServerSocket }
import java.nio.channels { 
    JavaSelector = Selector,
    SelectionKey { 
        javaReadOp = \iOP_READ,
        javaWriteOp = \iOP_WRITE,
        javaConnectOp = \iOP_CONNECT,
        javaAcceptOp = \iOP_ACCEPT
    } 
}
import ceylon.collection { HashMap, HashSet, MutableSet }
import ceylon.interop.java { CeylonIterable }

class Key(socket = null, onRead = null, onWrite = null, 
          connector = null, onConnect = null,
          acceptor = null, onAccept = null) {
    shared variable Callable<Boolean, [FileDescriptor]>? onRead;
    shared variable Callable<Boolean, [FileDescriptor]>? onWrite;
    shared variable FileDescriptor? socket;
    
    shared variable Callable<Anything, [Socket]>? onConnect;
    shared variable SocketConnectorImpl? connector;
    
    shared variable Callable<Boolean, [Socket]>? onAccept;
    shared variable ServerSocketImpl? acceptor;
}

shared class SelectorImpl() satisfies Selector {
    
    value javaSelector = JavaSelector.open();
    value map = HashMap<SelectionKey, Key>();
    
    shared actual void addConsumer(FileDescriptor socket, Boolean callback(FileDescriptor s)) {
        assert(is SocketImpl socket);
        SelectionKey? javaKey = socket.channel.keyFor(javaSelector);
        if(exists javaKey){
            assert(exists key = map[javaKey]);
            // update our key
            key.onRead = callback;
            key.socket = socket;
            socket.interestOps(javaKey, javaKey.interestOps().or(javaReadOp));
        }else{
            // new key
            value key = Key{onRead = callback; socket = socket;};
            value newJavaKey = socket.register(javaSelector, javaReadOp, key);
            map.put(newJavaKey, key);
        }
    }

    shared actual void addProducer(FileDescriptor socket, Boolean callback(FileDescriptor s)) {
        assert(is SocketImpl socket);
        SelectionKey? javaKey = socket.channel.keyFor(javaSelector);
        if(exists javaKey){
            assert(exists key = map[javaKey]);
            // update our key
            key.onWrite = callback;
            key.socket = socket;
            socket.interestOps(javaKey, javaKey.interestOps().or(javaWriteOp));
        }else{
            // new key
            value key = Key{onWrite = callback; socket = socket;};
            value newJavaKey = socket.register(javaSelector, javaWriteOp, key);
            map.put(newJavaKey, key);
        }
    }

    shared actual void addConnectListener(SocketConnector connector, void callback(Socket s)) {
        assert(is SocketConnectorImpl connector);
        SelectionKey? javaKey = connector.channel.keyFor(javaSelector);
        if(exists javaKey){
            assert(exists key = map[javaKey]);
            // update our key
            key.onConnect = callback;
            key.connector = connector;
            connector.interestOps(javaKey, javaKey.interestOps().or(javaConnectOp));
        }else{
            // new key
            value key = Key{onConnect = callback; connector = connector;};
            value newJavaKey = connector.register(javaSelector, javaConnectOp, key);
            map.put(newJavaKey, key);
        }
    }

    shared actual void addAcceptListener(ServerSocket acceptor, Boolean callback(Socket s)) {
        assert(is ServerSocketImpl acceptor);
        SelectionKey? javaKey = acceptor.channel.keyFor(javaSelector);
        if(exists javaKey){
            assert(exists key = map[javaKey]);
            // update our key
            key.onAccept = callback;
            key.acceptor = acceptor;
            acceptor.interestOps(javaKey, javaKey.interestOps().or(javaAcceptOp));
        }else{
            // new key
            value key = Key{onAccept = callback; acceptor = acceptor;};
            value newJavaKey = acceptor.register(javaSelector, javaAcceptOp, key);
            map.put(newJavaKey, key);
        }
    }

    void checkRead(SelectionKey selectedKey, Key key) {
        if(selectedKey.valid,
           is SocketImpl socket = key.socket){
            if(selectedKey.readable){
                // normal read
            }else if(is SslSocketImpl socket, socket.dataToRead){
                // SSL data has leftover stuff to read from
            }else{
                // nothing to read
                return;
            }
            // if we're handshaking and we have data, let's try to make it progress
            if(selectedKey.readable, 
               is SslSocketImpl socket, 
               socket.isHandshakeUnwrap(),
               socket.readForHandshake() == dataNeedsNeedsData){
                // nothing left to do but wait
                return;
            }
            assert(exists callback = key.onRead);
            value goOn = callback(socket);
            debug("Do we keep it for reading? `` goOn ``");
            if(!goOn){
                // are we still writing?
                if(key.onWrite exists){
                    // drop the reading bits
                    debug("Dropping read interest");
                    socket.interestOps(selectedKey, selectedKey.interestOps().xor(javaReadOp));
                    key.onRead = null;
                }else{
                    debug("Cancelling key");
                    selectedKey.cancel();
                    map.remove(selectedKey);
                }
            }
        }
    }
    
    void checkWrite(SelectionKey selectedKey, Key key) {
        if(selectedKey.valid && selectedKey.writable){
            assert(is SocketImpl socket = key.socket);
            // special case for SSL where we may have pending SSL data to write before we let the
            // user play
            if(is SslSocketImpl socket, socket.writePendingData() != dataNeedsOk){
                // we're not ready for something else
                return;
            }
            if(exists callback = key.onWrite){
                value goOn = callback(socket);
                debug("Do we keep it for writing? `` goOn ``");
                if(!goOn){
                    // are we still reading?
                    if(key.onRead exists){
                        // drop the reading bits
                        debug("Dropping write interest");
                        socket.interestOps(selectedKey, selectedKey.interestOps().xor(javaWriteOp));
                        key.onWrite = null;
                    }else{
                        debug("Cancelling key");
                        selectedKey.cancel();
                        map.remove(selectedKey);
                    }
                }
            }
        }
    }
    
    void checkConnect(SelectionKey selectedKey, Key key) {
        if(selectedKey.valid && selectedKey.connectable){
            assert(exists connector = key.connector,
                   exists callback = key.onConnect);
            // FIXME: check
            connector.channel.finishConnect();
            // create a new socket
            value socket = connector.createSocket();
            callback(socket);
            // did we just register for read/write events?
            if(key.onRead exists || key.onWrite exists){
                // drop the connect bits
                debug("Dropping connect interest");
                connector.interestOps(selectedKey, selectedKey.interestOps().xor(javaConnectOp));
                key.onConnect = null;
                key.connector = null;
            }else{
                debug("Cancelling key");
                selectedKey.cancel();
                map.remove(selectedKey);
            }
        }
    }
    
    void checkAccept(SelectionKey selectedKey, Key key) {
        if(selectedKey.valid && selectedKey.acceptable){
            assert(exists connector = key.acceptor,
                   exists callback = key.onAccept);
            // FIXME: check
            value socketChannel = connector.channel.accept();
            // create a new socket
            value socket = SocketImpl(socketChannel);
            value goOn = callback(socket);
            if(!goOn){
                // did we just register for read/write events?
                if(key.onRead exists || key.onWrite exists){
                    // drop the connect bits
                    debug("Dropping connect interest");
                    connector.interestOps(selectedKey, selectedKey.interestOps().xor(javaConnectOp));
                    key.onConnect = null;
                    key.connector = null;
                }else{
                    debug("Cancelling key");
                    selectedKey.cancel();
                    map.remove(selectedKey);
                }
            }
        }    
    }
    
    shared actual void process() {
        MutableSet<Key> sslKeysWithDataToRead = HashSet<Key>();
        while(!map.empty){
            debug("Select! with `` javaSelector.keys().size() `` keys ");
            // make sure we get out of select if we have SSL sockets with things ready to read
            variable Boolean dataToRead = false;
            for(selectionKey in CeylonIterable(javaSelector.keys())){
                assert(is Key key = selectionKey.attachment());
                if(is SslSocketImpl socket = key.socket,
                   socket.dataToRead){
                    dataToRead = true;
                    sslKeysWithDataToRead.add(key);
                }
            }
            debug("Has SSL data to read: ``dataToRead``");
            if(dataToRead){
                javaSelector.selectNow();
            }else{
                javaSelector.select();
            }
            
            // process results
            debug("Got `` javaSelector.selectedKeys().size() `` selected keys");
            for(selectedKey in CeylonIterable(javaSelector.selectedKeys())){
                assert(is Key key = selectedKey.attachment());
                debug("Key available:``selectedKey.acceptable``, connectable: ``selectedKey.connectable``,
                        readable: ``selectedKey.readable``, writable: ``selectedKey.writable``,
                        valid: ``selectedKey.valid``");
                sslKeysWithDataToRead.remove(key);
                checkRead(selectedKey, key);
                checkWrite(selectedKey, key);
                checkConnect(selectedKey, key);
                checkAccept(selectedKey, key);
            }
            debug("Got `` sslKeysWithDataToRead.size `` extra SSL keys");
            // make sure we treat ssl sockets with data to read that weren't selected
            for(key in sslKeysWithDataToRead){
                assert(is SslSocketImpl socket = key.socket);
                assert(exists javaKey = socket.channel.keyFor(javaSelector));
                checkRead(javaKey, key);
            }
        }
    }
}
