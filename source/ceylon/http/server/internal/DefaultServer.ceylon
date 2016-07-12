import ceylon.collection {
    MutableList,
    LinkedList
}
import ceylon.http.server {
    Server,
    Options,
    Status,
    starting,
    started,
    stopping,
    stopped,
    InternalException,
    HttpEndpoint,
    TemplateMatcher,
    Endpoint
}
import ceylon.http.server.internal.websocket {
    CeylonWebSocketHandler,
    WebSocketProtocolHandshakeHandler
}
import ceylon.http.server.websocket {
    WebSocketBaseEndpoint
}
import ceylon.io {
    SocketAddress
}

import io.undertow {
    UndertowOptions
}
import io.undertow.server {
    HttpHandler,
    XnioByteBufferPool
}
import io.undertow.server.handlers {
    PathTemplateHandler
}
import io.undertow.server.handlers.encoding {
    ContentEncodingRepository,
    EncodingHandler,
    DeflateEncodingProvider,
    GzipEncodingProvider
}
import io.undertow.server.handlers.error {
    SimpleErrorPageHandler
}
import io.undertow.server.protocol.http {
    HttpOpenListener
}
import io.undertow.server.session {
    InMemorySessionManager,
    SessionAttachmentHandler,
    SessionCookieConfig
}

import java.lang {
    JInt=Integer,
    Runtime {
        jRuntime=runtime
    },
    JThread=Thread
}
import java.net {
    InetSocketAddress
}

import org.xnio {
    XnioWorker,
    OptionMap {
        omBuilder=builder
    },
    XnioOptions=Options,
    ByteBufferSlicePool,
    BufferAllocator,
    ChannelListeners {
        clOpenListenerAdapter=openListenerAdapter
    }
}
import org.xnio.nio {
    NioXnioProvider
}

by("Matej Lazar")
shared class DefaultServer({<HttpEndpoint|WebSocketBaseEndpoint>*} endpoints)
        satisfies Server {

    value httpEndpoints = Endpoints();
    value webSocketHandler = CeylonWebSocketHandler();

    variable XnioWorker? worker = null;

    MutableList<Anything(Status)> statusListeners 
            = LinkedList<Anything(Status)>();

    for (endpoint in endpoints) {
        switch (endpoint)
        case (is HttpEndpoint) {
            httpEndpoints.add(endpoint);
        }
        case (is WebSocketBaseEndpoint) {
            webSocketHandler.addEndpoint(endpoint);
        }
    }

    HttpHandler getHandlers(Options options, HttpHandler next) {
        value protocolHandshakeHandler 
                = WebSocketProtocolHandshakeHandler(webSocketHandler,next);
        
        value sessionHandler 
                = SessionAttachmentHandler(
                    InMemorySessionManager(options.sessionId),
                    SessionCookieConfig());
        sessionHandler.setNext(protocolHandshakeHandler);
        
        value errPageHandler = SimpleErrorPageHandler(sessionHandler);
        errPageHandler.setNext(sessionHandler);

        value contentEncodingRepository = ContentEncodingRepository();
        contentEncodingRepository.addEncodingHandler("gzip", GzipEncodingProvider(), 50);
        contentEncodingRepository.addEncodingHandler("deflate", DeflateEncodingProvider(), 10);
        EncodingHandler encodingHandler = EncodingHandler(contentEncodingRepository);
        encodingHandler.setNext(errPageHandler);

        return encodingHandler;
    }
    
    shared actual void start(SocketAddress socketAddress, Options options) {
        notifyListeners(starting);
        //TODO log
        print("Starting on ``socketAddress.address``:``socketAddress.port``");
        
        value openListener
                = HttpOpenListener(
                    XnioByteBufferPool(
                        ByteBufferSlicePool(BufferAllocator.directByteBufferAllocator,
                            8192, 8192 * 8192)),
                    omBuilder().set(UndertowOptions.bufferPipelinedData,false).map);
        
        value pathTemplateHandler
                = PathTemplateHandler(
                    CeylonRequestHandler(options, 
                        httpEndpoints));
        for (endpoint in httpEndpoints.endpoints) {
            if (is TemplateMatcher matcher = endpoint.path) {
                assert (is Endpoint endpoint);
                pathTemplateHandler.add(matcher.template, 
                    TemplateCeylonRequestHandler(options, endpoint));
            }
        }
        
        openListener.rootHandler 
                = getHandlers(options, pathTemplateHandler);
        
        OptionMap workerOptions = omBuilder()
                .set(XnioOptions.workerIoThreads,
                    JInt(options.workerIoThreads))
                .set(XnioOptions.connectionLowWater,
                    JInt(options.connectionLowWatter))
                .set(XnioOptions.connectionHighWater,
                    JInt(options.connectionHighWatter))
                .set(XnioOptions.workerTaskCoreThreads,
                    JInt(options.workerTaskCoreThreads))
                .set(XnioOptions.workerTaskMaxThreads,
                    JInt(options.workerTaskMaxThreads))
                .set(XnioOptions.tcpNodelay, true)
                .set(XnioOptions.cork, true)
                .map;
        
        OptionMap serverOptions = omBuilder()
                .set(XnioOptions.tcpNodelay, true)
                .set(XnioOptions.reuseAddresses, true)
                .map;
        
        worker = NioXnioProvider().instance.createWorker(workerOptions);
        
        if (exists w = worker) {
            w.createStreamConnectionServer(
                InetSocketAddress(socketAddress.address, 
                                  socketAddress.port), 
                clOpenListenerAdapter(openListener), 
                serverOptions)
                    .resumeAccepts();
        } else {
            throw InternalException("Missing xnio worker!");
        }
        
        object shutdownThread 
                extends JThread("Shutdown thread") {
            run = outer.stop;
        }
        shutdownThread.daemon = false;
        jRuntime.addShutdownHook(shutdownThread);
        
        //TODO log
        print("Httpd started.");
        notifyListeners(started);

        if (exists w = worker) {
            w.awaitTermination();
        }
    }
    
    shared actual void startInBackground(SocketAddress socketAddress, 
            Options options) {
        object extends JThread() { 
            run() => outer.start(socketAddress, options); 
        }.start();
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

    addEndpoint(HttpEndpoint endpoint) 
            => httpEndpoints.add(endpoint);
    
    addWebSocketEndpoint(WebSocketBaseEndpoint endpoint) 
            => webSocketHandler.addEndpoint(endpoint);
    
    addListener(void listener(Status status)) 
            => statusListeners.add( listener );
}

