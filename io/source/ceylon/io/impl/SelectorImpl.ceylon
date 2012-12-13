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
import ceylon.collection { HashMap, MutableMap }

class Key(socket = null, onRead = null, onWrite = null, 
          connector = null, onConnect = null,
          acceptor = null, onAccept = null) {
    shared variable Callable<Boolean, [FileDescriptor]>? onRead;
    shared variable Callable<Boolean, [FileDescriptor]>? onWrite;
    shared variable shared FileDescriptor? socket;
    
    shared variable Callable<Void, [Socket]>? onConnect;
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
                    key.onRead := callback;
                    key.socket := socket;
                    javaKey.interestOps(javaKey.interestOps().or(javaReadOp));
                }else{
                    throw;
                }
            }else{
                // new key
                value key = Key{onRead = callback; socket = socket;};
                value newJavaKey = socket.channel.register(javaSelector, javaReadOp, key);
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
                    key.onWrite := callback;
                    key.socket := socket;
                    javaKey.interestOps(javaKey.interestOps().or(javaWriteOp));
                }else{
                    throw;
                }
            }else{
                // new key
                value key = Key{onWrite = callback; socket = socket;};
                value newJavaKey = socket.channel.register(javaSelector, javaWriteOp, key);
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
                    key.onConnect := callback;
                    key.connector := connector;
                    javaKey.interestOps(javaKey.interestOps().or(javaConnectOp));
                }else{
                    throw;
                }
            }else{
                // new key
                value key = Key{onConnect = callback; connector = connector;};
                value newJavaKey = connector.channel.register(javaSelector, javaConnectOp, key);
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
                    key.onAccept := callback;
                    key.acceptor := acceptor;
                    javaKey.interestOps(javaKey.interestOps().or(javaAcceptOp));
                }else{
                    throw;
                }
            }else{
                // new key
                value key = Key{onAccept = callback; acceptor = acceptor;};
                value newJavaKey = acceptor.channel.register(javaSelector, javaAcceptOp, key);
                map.put(newJavaKey, key);
            }
        }else{
            throw;
        }
    }

    void checkRead(SelectionKey selectedKey, Key key) {
        if(selectedKey.valid && selectedKey.readable){
            if(exists socket = key.socket){
                if(exists callback = key.onRead){
                    value goOn = callback(socket);
                    print("Do we keep it for reading? " goOn "");
                    if(!goOn){
                        // are we still writing?
                        if(exists key.onWrite){
                            // drop the reading bits
                        print("Dropping read interest");
                            selectedKey.interestOps(selectedKey.interestOps().xor(javaReadOp));
                            key.onRead := null;
                        }else{
                            print("Cancelling key");
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
    
    void checkWrite(SelectionKey selectedKey, Key key) {
        if(selectedKey.valid && selectedKey.writable){
            if(exists socket = key.socket){
                if(exists callback = key.onWrite){
                    value goOn = callback(socket);
                    print("Do we keep it for writing? " goOn "");
                    if(!goOn){
                        // are we still reading?
                        if(exists key.onRead){
                            // drop the reading bits
                            print("Dropping write interest");
                            selectedKey.interestOps(selectedKey.interestOps().xor(javaWriteOp));
                            key.onWrite := null;
                        }else{
                            print("Cancelling key");
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
    
    void checkConnect(SelectionKey selectedKey, Key key) {
        if(selectedKey.valid && selectedKey.connectable){
            if(exists connector = key.connector){
                if(exists callback = key.onConnect){
                    // FIXME: check
                    connector.channel.finishConnect();
                    // create a new socket
                    value socket = SocketImpl(connector.channel);
                    callback(socket);
                    // did we just register for read/write events?
                    if(exists key.onRead || exists key.onWrite){
                        // drop the connect bits
                        print("Dropping connect interest");
                        selectedKey.interestOps(selectedKey.interestOps().xor(javaConnectOp));
                        key.onConnect := null;
                        key.connector := null;
                    }else{
                        print("Cancelling key");
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
                        if(exists key.onRead || exists key.onWrite){
                            // drop the connect bits
                            print("Dropping connect interest");
                            selectedKey.interestOps(selectedKey.interestOps().xor(javaConnectOp));
                            key.onConnect := null;
                            key.connector := null;
                        }else{
                            print("Cancelling key");
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
        while(!map.empty){
            print("Select! with " javaSelector.keys().size() " keys ");
            javaSelector.select();
            // process results
            print("Got " javaSelector.selectedKeys().size() " selected keys");
            value it = javaSelector.selectedKeys().iterator();
            while(it.hasNext()){
                value selectedKey = it.next();
                if(is Key key = selectedKey.attachment()){
                    checkRead(selectedKey, key);
                    checkWrite(selectedKey, key);
                    checkConnect(selectedKey, key);
                    checkAccept(selectedKey, key);
                }else{
                    throw;
                }
            }
        }
    }
}
