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
    }
}

shared class SocketConnectorImpl(address, connectTimeout, readTimeout)
        satisfies SocketConnector {
    shared actual default SocketAddress address;
    shared actual default Integer connectTimeout;
    shared actual default Integer readTimeout;
    
    shared actual default SocketConnector withAddress(SocketAddress address)
            => SocketConnectorImpl(address, connectTimeout, readTimeout);
    shared actual default SocketConnector withConnectTimeout(Integer connectTimeout)
            => SocketConnectorImpl(address, connectTimeout, readTimeout);
    shared actual default SocketConnector withReadTimeout(Integer readTimeout)
            => SocketConnectorImpl(address, connectTimeout, readTimeout);
    
    shared default actual Socket connect() {
        SocketChannel channel = openSocket();
        try {
            channel.socket().soTimeout = readTimeout;
            channel.socket().connect(InetSocketAddress(address.address, address.port), connectTimeout);
        } catch (JavaSocketTimeoutException e) {
            throw SocketTimeoutException();
        }
        return SocketImpl(channel);
    }
    
    shared actual void connectAsync(Selector selector,
        void connect(Socket socket)) {
        SocketChannel channel = openSocket();
        channel.configureBlocking(false);
        channel.connect(InetSocketAddress(address.address,
                address.port));
        selector.addConnectListener(this, connect);
    }
    
    /*
    shared default Socket createSocket() => SocketImpl(channel);
     
    shared actual void close() => channel.close();
    
    shared default SelectionKey register(JavaSelector selector, 
        Integer ops, Object attachment)
            => channel.register(selector, ops, attachment);
    
    shared default void interestOps(SelectionKey key, Integer ops) 
            => key.interestOps(ops);
    */
}

shared class SslSocketConnectorImpl(address, connectTimeout, readTimeout)
        extends SocketConnectorImpl(address, connectTimeout, readTimeout)
        satisfies SslSocketConnector {
    shared actual SocketAddress address;
    shared actual Integer connectTimeout;
    shared actual Integer readTimeout;
    
    shared default actual SslSocketConnector withAddress(SocketAddress address)
            => SslSocketConnectorImpl(address, connectTimeout, readTimeout);
    shared default actual SslSocketConnector withConnectTimeout(Integer connectTimeout)
            => SslSocketConnectorImpl(address, connectTimeout, readTimeout);
    shared default actual SslSocketConnector withReadTimeout(Integer readTimeout)
            => SslSocketConnectorImpl(address, connectTimeout, readTimeout);
    
    shared actual SslSocket connect() {
        SocketChannel channel = openSocket();
        try {
            channel.socket().soTimeout = readTimeout;
            channel.socket().connect(InetSocketAddress(address.address, address.port), connectTimeout);
        } catch (JavaSocketTimeoutException e) {
            throw SocketTimeoutException();
        }
        return SslSocketImpl(channel);
    }
}
