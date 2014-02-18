import ceylon.io { Socket, SocketAddress, Selector, SocketConnector, SslSocketConnector, SslSocket }

import java.net { InetSocketAddress }
import java.nio.channels { SocketChannel { openSocket=open }, JavaSelector = Selector, SelectionKey }

shared class SocketConnectorImpl(SocketAddress addr) satisfies SocketConnector{
    
    shared SocketChannel channel = openSocket();
    
    shared default actual Socket connect(){
        channel.connect(InetSocketAddress(addr.address, addr.port));
        return createSocket();
    }
    
    shared default Socket createSocket(){
        return SocketImpl(channel);
    }
    
    shared actual void connectAsync(Selector selector, void connect(Socket socket)){
        channel.configureBlocking(false);
        channel.connect(InetSocketAddress(addr.address, addr.port));
        selector.addConnectListener(this, connect);
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

shared class SslSocketConnectorImpl(SocketAddress addr) extends SocketConnectorImpl(addr)
    satisfies SslSocketConnector {

    shared actual SslSocket connect(){
        channel.connect(InetSocketAddress(addr.address, addr.port));
        return createSocket();
    }
    
    shared actual SslSocket createSocket(){
        return SslSocketImpl(channel);
    }
}