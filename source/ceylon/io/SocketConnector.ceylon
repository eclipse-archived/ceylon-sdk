import ceylon.io.impl { SocketConnectorImpl, SslSocketConnectorImpl }

"Represents an object that you can use to connect to a remote host.
 
 Both synchronous and asynchronous modes of operation are supported:
 
 - use [[connect]] to block until the socket is connected, or
 - use [[connectAsync]] to register a listener that will be invoked when
   the socket is connected.
 
 You create new socket connectors with [[newSocketConnector]].
 "
by("Stéphane Épardaud")
see(`function newSocketConnector`)
shared interface SocketConnector{
    
    "Blocks the current thread until we can make a connection to the
     specified [[addr]]."
    shared formal Socket connect();

    "Registers a `connect` listener on the specified [[selector]] that
     will be invoked when the socket is connected to the specified [[addr]]."
    see(`interface Selector`)
    shared formal void connectAsync(Selector selector, void connect(Socket socket));

    "Closes this socket connector."
    shared formal void close();
}

shared interface SslSocketConnector satisfies SocketConnector {
    shared formal actual SslSocket connect();
}

"Creates a new [[SocketConnector]] to connect to the specified [[addr]]."
see(`interface SocketConnector`)
shared SocketConnector newSocketConnector(SocketAddress addr){
    return SocketConnectorImpl(addr);
}

shared SslSocketConnector newSslSocketConnector(SocketAddress addr){
    return SslSocketConnectorImpl(addr);
}
