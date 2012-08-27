import ceylon.io { Socket, SocketAddress, Selector, SocketConnector }

import java.net { InetSocketAddress }
import java.nio.channels { SocketChannel { openSocket=open } }

shared class SocketConnectorImpl(SocketAddress addr) extends SocketConnector(addr){
    
    shared SocketChannel channel = openSocket();
    
    shared actual Socket connect(){
        channel.connect(InetSocketAddress(addr.address, addr.port));
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
}