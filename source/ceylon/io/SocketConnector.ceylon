import ceylon.io.impl {
    SocketConnectorImpl,
    SslSocketConnectorImpl
}

"Holds information during an asynchronous connect"
shared sealed interface ConnectionInProgress {
    shared formal Object? channel;
    shared formal Socket finish();
}

"An object that connects to a remote host, returning a [[Socket]], either
 synchronously or asynchronously:
 
 - use [[connect]] to block until the socket is connected, or
 - use [[connectAsync]] to register a listener that will be invoked when the
   socket is connected.
 
 May be reused safely for multiple [[Socket]]s."
by ("Stéphane Épardaud")
see (`function newSocketConnector`)
shared sealed interface SocketConnector {
    "The address to use in [[connect]] or [[connectAsync]]."
    shared formal SocketAddress address;
    "The maximum milliseconds to allow [[connect]] to block before raising a
     [[SocketTimeoutException]]. Must be at least 1 to have effect."
    shared formal Integer connectTimeout;
    "The maximum milliseconds to allow [[Socket.read]] to block before raising
     a [[SocketTimeoutException]]. Applies to [[Socket]]s created with
     [[connect]], but not [[connectAsync]]. Must be at least 1 to have effect."
    shared formal Integer readTimeout;
    
    "Create a new [[SocketConnector]] based on this [[SocketConnector]],
     replacing the [[address]] with the given value."
    shared formal SocketConnector withAddress(SocketAddress address);
    "Create a new [[SocketConnector]] based on this [[SocketConnector]],
     replacing the [[connectTimeout]] with the given value."
    shared formal SocketConnector withConnectTimeout(Integer connectTimeout);
    "Create a new [[SocketConnector]] based on this [[SocketConnector]],
     replacing the [[readTimeout]] with the given value."
    shared formal SocketConnector withReadTimeout(Integer readTimeout);
    
    "Block the current thread until a connected [[Socket]] is returned."
    throws (`class SocketTimeoutException`,
        "If [[connectTimeout]] elapses before the [[Socket]] is connected")
    shared formal Socket connect();
    
    "Registers a [[connection listener|connect]] on the specified [[selector]]
     that will be called when the socket is connected."
    see (`interface Selector`)
    shared formal void connectAsync(Selector selector,
        void connect(Socket socket));
}

"An object that connects to a remote host, returning an [[SslSocket]], either
 synchronously or asynchronously:
 
 - use [[connect]] to block until the socket is connected, or
 - use [[connectAsync]] to register a listener that will be invoked when the
   socket is connected.
 
 May be reused safely for multiple [[SslSocket]]s."
see (`function newSslSocketConnector`)
shared sealed interface SslSocketConnector
        satisfies SocketConnector {
    shared formal actual SslSocketConnector withAddress(SocketAddress address);
    shared formal actual SslSocketConnector withConnectTimeout(Integer connectTimeout);
    shared formal actual SslSocketConnector withReadTimeout(Integer readTimeout);
    
    shared formal actual SslSocket connect();
}

"Creates a new [[SocketConnector]]."
shared SocketConnector newSocketConnector(
    SocketAddress address,
    Integer connectTimeout = 0,
    Integer readTimeout = 0) {
    return SocketConnectorImpl(address, connectTimeout, readTimeout);
}

"Creates a new [[SslSocketConnector]]."
shared SslSocketConnector newSslSocketConnector(
    SocketAddress address,
    Integer connectTimeout = 0,
    Integer readTimeout = 0) {
    return SslSocketConnectorImpl(address, connectTimeout, readTimeout);
}
