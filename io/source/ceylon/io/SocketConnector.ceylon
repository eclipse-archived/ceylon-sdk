import ceylon.io.impl { SocketConnectorImpl }

shared abstract class SocketConnector(SocketAddress addr){
    shared formal Socket connect();
    shared formal void connectAsync(Selector selector, void connect(Socket socket));
    shared formal void close();
}

shared SocketConnector newSocketConnector(SocketAddress addr){
    return SocketConnectorImpl(addr);
}
