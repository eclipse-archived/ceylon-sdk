import ceylon.io {
    Socket,
    SocketAddress,
    Selector,
    SocketConnector,
    SslSocketConnector,
    SslSocket,
    SocketTimeoutException
}

import java.net {
    InetSocketAddress,
    JavaSocketTimeoutException=SocketTimeoutException
}
import java.nio.channels {
    SocketChannel {
        openSocket=open
    },
    JavaSelector=Selector,
    SelectionKey
}

shared class SocketConnectorImpl(SocketAddress address) 
        satisfies SocketConnector{
    
    shared SocketChannel channel = openSocket();
    
    shared default actual Socket connect(Integer connectTimeout, Integer readTimeout) {
        try {
            channel.socket().soTimeout = readTimeout;
            channel.socket().connect(InetSocketAddress(address.address, address.port), connectTimeout);
        } catch (JavaSocketTimeoutException e) {
            throw SocketTimeoutException();
        }
        return createSocket();
    }
    
    shared default Socket createSocket() => SocketImpl(channel);
    
    shared actual void connectAsync(Selector selector, 
        void connect(Socket socket)) {
        channel.configureBlocking(false);
        channel.connect(InetSocketAddress(address.address, 
            address.port));
        selector.addConnectListener(this, connect);
    }
    
    shared actual void close() => channel.close();
    
    shared default SelectionKey register(JavaSelector selector, 
        Integer ops, Object attachment)
            => channel.register(selector, ops, attachment);
    
    shared default void interestOps(SelectionKey key, Integer ops) 
            => key.interestOps(ops);
}

shared class SslSocketConnectorImpl(SocketAddress address) 
        extends SocketConnectorImpl(address)
    satisfies SslSocketConnector {

    shared actual SslSocket connect(Integer connectTimeout, Integer readTimeout) {
        try {
            channel.socket().soTimeout = readTimeout;
            channel.socket().connect(InetSocketAddress(address.address, address.port), connectTimeout);
        } catch (JavaSocketTimeoutException e) {
            throw SocketTimeoutException();
        }
        return createSocket();
    }
    
    shared actual SslSocket createSocket() => SslSocketImpl(channel);
}