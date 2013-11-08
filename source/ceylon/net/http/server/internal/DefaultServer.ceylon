import java.lang {
    JInt = Integer,
    Runtime { jRuntime = runtime },
    JThread = Thread, 
    JRunnable = Runnable 
}
import java.net { InetSocketAddress}
import org.xnio { 
    Xnio { xnioInstance = instance },
    XnioWorker, 
    OptionMap { omBuilder = builder },
    XnioOptions = Options { 
        xnioWorkerIoThreads = \iWORKER_IO_THREADS,
        xnioConnectionLowWatter = \iCONNECTION_LOW_WATER,
        xnioConnectionHighWatter = \iCONNECTION_HIGH_WATER,
        xnioWorkerTaskCoreThreads = \iWORKER_TASK_CORE_THREADS,
        xnioWorkerTaskMaxThreads = \iWORKER_TASK_MAX_THREADS,
        xnioTcpNoDelay = \iTCP_NODELAY,
        xnioReuseAddress = \iREUSE_ADDRESSES,
        xnioCork = \iCORK
    }, 
    ByteBufferSlicePool, 
    BufferAllocator {directByteBufferAllocator  = \iDIRECT_BYTE_BUFFER_ALLOCATOR},
    ChannelListeners { clOpenListenerAdapter = openListenerAdapter},
    StreamConnection, ChannelListener
}
import org.xnio.channels { AcceptingChannel }
import io.undertow.server { HttpHandler }
import io.undertow.server.protocol.http { HttpOpenListener }
import io.undertow.server.handlers.error { SimpleErrorPageHandler }
import ceylon.net.http.server { Server, Options, Status, starting, started, stopping, stopped, InternalException, HttpEndpoint }
import io.undertow.server.session { InMemorySessionManager, SessionAttachmentHandler, SessionCookieConfig }
import io.undertow { UndertowOptions { utBufferPipelinedData = \iBUFFER_PIPELINED_DATA} }
import ceylon.net.http.server.internal.websocket { CeylonWebSocketHandler, WebSocketProtocolHandshakeHandler }
import ceylon.net.http.server.websocket { WebSocketBaseEndpoint }
import ceylon.collection { MutableList, LinkedList }
import ceylon.io { SocketAddress }

by("Matej Lazar")
shared class DefaultServer({<HttpEndpoint|WebSocketBaseEndpoint>*} endpoints)
        satisfies Server {

    Endpoints httpEndpoints = Endpoints();
    CeylonWebSocketHandler webSocketHandler = CeylonWebSocketHandler();

    variable XnioWorker? worker = null;

    MutableList<Callable<Anything, [Status]>> statusListeners = LinkedList<Callable<Anything, [Status]>>();

    for (endpoint in endpoints) {
        switch (endpoint)
        case (is HttpEndpoint) {
            httpEndpoints.add(endpoint);
        }
        case (is WebSocketBaseEndpoint) {
            webSocketHandler.addEndpoint(endpoint);
        }
    }

    HttpHandler getHeandlers(Options options, HttpHandler next) {
        value webSocketProtocolHandshakeHandler = WebSocketProtocolHandshakeHandler(
                                                        webSocketHandler,
                                                        next);
        
        value sessionconfig = SessionCookieConfig();
        SessionAttachmentHandler sessionHandler = SessionAttachmentHandler(InMemorySessionManager(), sessionconfig);
        sessionHandler.setNext(webSocketProtocolHandshakeHandler);
        
        HttpHandler errPageHandler = SimpleErrorPageHandler(sessionHandler);
        
        return errPageHandler;
    }
    
    shared actual void start(SocketAddress socketAddress, Options options) {  //TODO use SocketAddres for host:post
        notifyListeners(starting);
        //TODO log
        print("Starting on ``socketAddress.address``:``socketAddress.port``");
        CeylonRequestHandler ceylonRequestHandler = CeylonRequestHandler(options, httpEndpoints);

        HttpOpenListener openListener = HttpOpenListener(
        ByteBufferSlicePool(
            directByteBufferAllocator, 8192, 8192 * 8192), 
            omBuilder().set(utBufferPipelinedData, false).map ,
            8192 );
        
        openListener.rootHandler = getHeandlers(options, ceylonRequestHandler);
        
        OptionMap workerOptions = omBuilder()
                .set(xnioWorkerIoThreads, JInt(options.workerIoThreads))
                .set(xnioConnectionLowWatter, JInt(options.connectionLowWatter))
                .set(xnioConnectionHighWatter, JInt(options.connectionHighWatter))
                .set(xnioWorkerTaskCoreThreads, JInt(options.workerTaskCoreThreads))
                .set(xnioWorkerTaskMaxThreads, JInt(options.workerTaskMaxThreads))
                .set(xnioTcpNoDelay, true)
                .set(xnioCork, true)
                .map;
        
        OptionMap serverOptions = omBuilder()
                .set(xnioTcpNoDelay, true)
                .set(xnioReuseAddress, true)
                .map;
        
        worker = xnioInstance.createWorker(workerOptions);
        
        InetSocketAddress jSocketAddress = InetSocketAddress(socketAddress.address, socketAddress.port);
        
        ChannelListener<AcceptingChannel<StreamConnection>> acceptListener = clOpenListenerAdapter(openListener);
        
        if (exists w = worker) {
            AcceptingChannel<StreamConnection> server = w.createStreamConnectionServer(jSocketAddress, acceptListener, serverOptions);
            server.resumeAccepts();
        } else {
            throw InternalException("Missing xnio worker!");
        }
        
        object shutdownHook satisfies JRunnable {
            shared actual void run() {
                stop();
            }
        }
        
        JThread shutdownThread = JThread(shutdownHook, "Shutdown thread");
        shutdownThread.daemon = false;
        jRuntime.addShutdownHook(shutdownThread);
        
        //TODO log
        print("Httpd started.");
        notifyListeners(started);

        if (exists w = worker) {
            w.awaitTermination();
        }
    }
    
    shared actual void startInBackground(SocketAddress socketAddress, Options options) {
        object httpd satisfies JRunnable {
            shared actual void run() {
                start(socketAddress, options);
            }
        }
        JThread(httpd).start();
    }
    
    shared actual void stop() {
        if (exists w = worker) {
            notifyListeners(stopping);
            w.shutdown();
            //TODO log
            print("Httpd stopped.");
            notifyListeners(stopped);
            worker = null;
        }
    }
    
    void notifyListeners(Status status) {
        for (listener in statusListeners) {
            listener(status);
        }
    }

    shared actual void addEndpoint(HttpEndpoint endpoint) {
        httpEndpoints.add(endpoint);
    }
    
    shared actual void addWebSocketEndpoint(WebSocketBaseEndpoint endpoint) {
        webSocketHandler.addEndpoint(endpoint);
    }
    
    shared actual void addListener(void listener(Status status)) {
        statusListeners.add( listener );
    }
}

