import ceylon.io { SocketAddress, ServerSocket, Socket, Selector }
import java.net { InetSocketAddress }
import java.nio.channels { ServerSocketChannel { openSocket=open }, JavaSelector = Selector, SelectionKey }

shared class ServerSocketImpl(SocketAddress? bindAddress, Integer backlog = 0) extends ServerSocket(bindAddress){

    shared ServerSocketChannel channel = openSocket();
    shared actual SocketAddress localAddress;

    if(exists bindAddress){
        channel.bind(InetSocketAddress(bindAddress.address, bindAddress.port), backlog);
    }else{
        channel.bind(null, backlog);
    }

    if(is InetSocketAddress socketAddress = channel.localAddress){
        localAddress = SocketAddress(socketAddress.hostString, socketAddress.port);
    }else{
        throw;
    }

    shared actual Socket accept() {
        return SocketImpl(channel.accept());
    }

    shared actual void acceptAsync(Selector selector, Boolean accept(Socket socket)) {
        channel.configureBlocking(false);
        channel.accept();
        selector.addAcceptListener(this, accept);
    }

    shared actual void close() {
        channel.close();
    }
    
    shared default SelectionKey register(JavaSelector selector, Integer ops, Object attachment){
        return channel.register(selector, ops, attachment);
    }
    
    shared default void interestOps(SelectionKey key, Integer ops) {
        key.interestOps(ops);
    }
}