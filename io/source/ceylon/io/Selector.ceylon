import ceylon.io.impl { SelectorImpl }

shared interface Selector {
    shared formal void process();
    shared formal void addConsumer(FileDescriptor socket, Boolean callback(FileDescriptor s));
    shared formal void addProducer(FileDescriptor socket, Boolean callback(FileDescriptor s));
    shared formal void addConnectListener(SocketConnector socketConnector, void connect(Socket s));
    shared formal void addAcceptListener(ServerSocket socketAcceptor, Boolean accept(Socket s));
}

shared Selector newSelector(){
    return SelectorImpl();
}
