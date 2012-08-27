import ceylon.io.impl { ServerSocketImpl }

shared abstract class ServerSocket(SocketAddress? bindAddress = null){
    shared formal SocketAddress localAddress;
    shared formal Socket accept();
    shared formal void acceptAsync(Selector selector, Boolean accept(Socket socket));
    shared formal void close();
}

shared ServerSocket newServerSocket(SocketAddress? addr = null, Integer backlog = 0){
    return ServerSocketImpl(addr, backlog);
}
