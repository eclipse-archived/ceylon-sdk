import ceylon.io.impl {
    SocketConnectorImpl,
    SslSocketConnectorImpl
}

"An object that connects to a remote host, returning a
 [[Socket]], either synchronously or asynchronously:
 
 - use [[connect]] to block until the socket is connected, 
   or
 - use [[connectAsync]] to register a listener that will be 
   invoked when the socket is connected."
by("Stéphane Épardaud")
see(`function newSocketConnector`)
shared sealed interface SocketConnector{
    
    "Block the current thread until a connected [[Socket]] 
     is returned."
    shared formal Socket connect();

    "Registers a [[connection listener|connect]] on the 
     specified [[selector]] that will be called when the 
     socket is connected."
    see(`interface Selector`)
    shared formal void connectAsync(Selector selector, 
        void connect(Socket socket), Anything(Exception)? connectFailure = null);

    "Closes this socket connector."
    shared formal void close();
}

"An object that connects to a remote host, returning an
 [[SslSocket]], either synchronously or asynchronously:
 
 - use [[connect]] to block until the socket is connected, 
   or
 - use [[connectAsync]] to register a listener that will be 
   invoked when the socket is connected."
see(`function newSslSocketConnector`)
shared sealed interface SslSocketConnector 
        satisfies SocketConnector {
    shared formal actual SslSocket connect();
}

"Creates a new [[SocketConnector]] to connect to the given
 [[address]]."
see(`interface SocketConnector`)
shared SocketConnector newSocketConnector(SocketAddress address)
        => SocketConnectorImpl(address);

shared SslSocketConnector newSslSocketConnector(SocketAddress address)
        => SslSocketConnectorImpl(address);
