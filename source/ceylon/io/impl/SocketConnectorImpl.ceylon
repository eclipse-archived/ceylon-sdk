import ceylon.io {
    Socket,
    SocketAddress,
    Selector,
    SocketConnector,
    SslSocketConnector,
    SslSocket,
    SocketTimeoutException,
    ConnectionInProgress
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

shared class ConnectionInProgressImpl(channel, socketCreator) satisfies ConnectionInProgress {
    shared actual SocketChannel channel;
    Socket socketCreator(SocketChannel channel);
    
    shared actual Socket finish() => socketCreator(channel);
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
    
    shared SocketChannel connnectChannelBlocking() {
        SocketChannel channel = openSocket();
        try {
            channel.socket().soTimeout = readTimeout;
            channel.socket().connect(
                InetSocketAddress(address.address, address.port),
                connectTimeout
            );
        } catch (JavaSocketTimeoutException e) {
            throw SocketTimeoutException("Connect timeout of ``connectTimeout`` ms exeeded");
        }
        return channel;
    }
    
    shared default Socket socketCreator(SocketChannel channel)
            => SocketImpl(channel);
    shared default actual Socket connect()
            => socketCreator(connnectChannelBlocking());
    
    shared actual void connectAsync(Selector selector,
        void connect(Socket socket)) {
        SocketChannel channel = openSocket();
        channel.configureBlocking(false);
        channel.connect(InetSocketAddress(address.address, address.port));
        selector.addConnectListener {
            ConnectionInProgressImpl(channel, socketCreator);
            connect;
        };
        // Do not return ConnectionInProgress to avoid exposing the channel
        // Selectors can only have one connect listener anyway
    }
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
    
    shared actual SslSocket socketCreator(SocketChannel channel)
            => SslSocketImpl(channel);
    
    shared actual SslSocket connect()
            => socketCreator(connnectChannelBlocking());
    
    // Can't refine connectAsync to SslSocket because of callable type limitations
}
