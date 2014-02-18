import ceylon.io { Selector, Socket, FileDescriptor, SocketConnector, ServerSocket }
import java.nio.channels { 
    JavaSelector = Selector { javaOpenSelector = open },
    SelectionKey { 
        javaReadOp = \iOP_READ,
        javaWriteOp = \iOP_WRITE,
        javaConnectOp = \iOP_CONNECT,
        javaAcceptOp = \iOP_ACCEPT
    } 
}
import ceylon.collection { HashMap, MutableMap, HashSet, MutableSet }

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
    
    JavaSelector javaSelector = javaOpenSelector();
    MutableMap<SelectionKey, Key> map = HashMap<SelectionKey, Key>();
    
    shared actual void addConsumer(FileDescriptor socket, Boolean callback(FileDescriptor s)) {
        if(is SocketImpl socket){
            SelectionKey? javaKey = socket.channel.keyFor(javaSelector);
            if(exists javaKey){
                value key = map[javaKey];
                if(exists key){
                    // update our key
                    key.onRead = callback;
                    key.socket = socket;
                    socket.interestOps(javaKey, javaKey.interestOps().or(javaReadOp));
                }else{
                    throw;
                }
            }else{
                // new key
                value key = Key{onRead = callback; socket = socket;};
                value newJavaKey = socket.register(javaSelector, javaReadOp, key);
                map.put(newJavaKey, key);
            }
        }else{
            throw;
        }
    }

    shared actual void addProducer(FileDescriptor socket, Boolean callback(FileDescriptor s)) {
        if(is SocketImpl socket){
            SelectionKey? javaKey = socket.channel.keyFor(javaSelector);
            if(exists javaKey){
                value key = map[javaKey];
                if(exists key){
                    // update our key
                    key.onWrite = callback;
                    key.socket = socket;
                    socket.interestOps(javaKey, javaKey.interestOps().or(javaWriteOp));
                }else{
                    throw;
                }
            }else{
                // new key
                value key = Key{onWrite = callback; socket = socket;};
                value newJavaKey = socket.register(javaSelector, javaWriteOp, key);
                map.put(newJavaKey, key);
            }
        }else{
            throw;
        }
    }

    shared actual void addConnectListener(SocketConnector connector, void callback(Socket s)) {
        if(is SocketConnectorImpl connector){
            SelectionKey? javaKey = connector.channel.keyFor(javaSelector);
            if(exists javaKey){
                value key = map[javaKey];
                if(exists key){
                    // update our key
                    key.onConnect = callback;
                    key.connector = connector;
                    connector.interestOps(javaKey, javaKey.interestOps().or(javaConnectOp));
                }else{
                    throw;
                }
            }else{
                // new key
                value key = Key{onConnect = callback; connector = connector;};
                value newJavaKey = connector.register(javaSelector, javaConnectOp, key);
                map.put(newJavaKey, key);
            }
        }else{
            throw;
        }
    }

    shared actual void addAcceptListener(ServerSocket acceptor, Boolean callback(Socket s)) {
        if(is ServerSocketImpl acceptor){
            SelectionKey? javaKey = acceptor.channel.keyFor(javaSelector);
            if(exists javaKey){
                value key = map[javaKey];
                if(exists key){
                    // update our key
                    key.onAccept = callback;
                    key.acceptor = acceptor;
                    acceptor.interestOps(javaKey, javaKey.interestOps().or(javaAcceptOp));
                }else{
                    throw;
                }
            }else{
                // new key
                value key = Key{onAccept = callback; acceptor = acceptor;};
                value newJavaKey = acceptor.register(javaSelector, javaAcceptOp, key);
                map.put(newJavaKey, key);
            }
        }else{
            throw;
        }
    }

    void checkRead(SelectionKey selectedKey, Key key) {
        if(selectedKey.valid){
            if(is SocketImpl socket = key.socket){
                if(selectedKey.readable){
                    // normal read
                }else if(is SslSocketImpl socket, socket.dataToRead){
                    // SSL data has leftover stuff to read from
                }else{
                    // nothing to read
                    return;
                }
                // if we're handshaking and we have data, let's try to make it progress
                if(selectedKey.readable, is SslSocketImpl socket, socket.isHandshakeUnwrap()){
                    if(socket.readForHandshake() == dataNeedsNeedsData){
                        // nothing left to do but wait
                        return;
                    }
                }
                if(exists callback = key.onRead){
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
                }else{
                    throw;
                }
            }
        }
    }
    
    void checkWrite(SelectionKey selectedKey, Key key) {
        if(selectedKey.valid && selectedKey.writable){
            if(is SocketImpl socket = key.socket){
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
            }else{
                throw;
            }
        }
    }
    
    void checkConnect(SelectionKey selectedKey, Key key) {
        if(selectedKey.valid && selectedKey.connectable){
            if(exists connector = key.connector){
                if(exists callback = key.onConnect){
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
                }else{
                    throw;
                }
            }else{
                throw;
            }
        }
    }
    
    void checkAccept(SelectionKey selectedKey, Key key) {
        if(selectedKey.valid && selectedKey.acceptable){
            if(exists connector = key.acceptor){
                if(exists callback = key.onAccept){
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
                }else{
                    throw;
                }
            }else{
                throw;
            }
        }    
    }
    
    shared actual void process() {
        MutableSet<Key> sslKeysWithDataToRead = HashSet<Key>();
        while(!map.empty){
            debug("Select! with `` javaSelector.keys().size() `` keys ");
            // make sure we get out of select if we have SSL sockets with things ready to read
            value keysIterator = javaSelector.keys().iterator();
            variable Boolean dataToRead = false;
            while(keysIterator.hasNext()){
                value selectionKey = keysIterator.next();
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
            value it = javaSelector.selectedKeys().iterator();
            while(it.hasNext()){
                value selectedKey = it.next();
                if(is Key key = selectedKey.attachment()){
                    debug("Key available:``selectedKey.acceptable``, connectable: ``selectedKey.connectable``,
                             readable: ``selectedKey.readable``, writable: ``selectedKey.writable``,
                             valid: ``selectedKey.valid``");
                    sslKeysWithDataToRead.remove(key);
                    checkRead(selectedKey, key);
                    checkWrite(selectedKey, key);
                    checkConnect(selectedKey, key);
                    checkAccept(selectedKey, key);
                }else{
                    throw;
                }
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
