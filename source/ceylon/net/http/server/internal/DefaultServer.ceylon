import ceylon.collection {
	MutableList,
	LinkedList
}
import ceylon.io {
	SocketAddress
}
import ceylon.net.http.server {
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
import ceylon.net.http.server.internal.websocket {
	CeylonWebSocketHandler,
	WebSocketProtocolHandshakeHandler
}
import ceylon.net.http.server.websocket {
	WebSocketBaseEndpoint
}

import io.undertow {
	UndertowOptions {
		utBufferPipelinedData=\iBUFFER_PIPELINED_DATA
	}
}
import io.undertow.server {
	HttpHandler,
	XnioByteBufferPool
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
	JThread=Thread,
	JRunnable=Runnable
}
import java.net {
	InetSocketAddress
}

import org.xnio {
	XnioWorker,
	OptionMap {
		omBuilder=builder
	},
	XnioOptions=Options {
		xnioWorkerIoThreads=\iWORKER_IO_THREADS,
		xnioConnectionLowWatter=\iCONNECTION_LOW_WATER,
		xnioConnectionHighWatter=\iCONNECTION_HIGH_WATER,
		xnioWorkerTaskCoreThreads=\iWORKER_TASK_CORE_THREADS,
		xnioWorkerTaskMaxThreads=\iWORKER_TASK_MAX_THREADS,
		xnioTcpNoDelay=\iTCP_NODELAY,
		xnioReuseAddress=\iREUSE_ADDRESSES,
		xnioCork=\iCORK
	},
	ByteBufferSlicePool,
	BufferAllocator {
		directByteBufferAllocator=\iDIRECT_BYTE_BUFFER_ALLOCATOR
	},
	ChannelListeners {
		clOpenListenerAdapter=openListenerAdapter
	}
}
import org.xnio.nio {
	NioXnioProvider
}
import io.undertow.connector {
	ByteBufferPool
}
import io.undertow.predicate {
	Predicate
}
import io.undertow.server.handlers {
	PathTemplateHandler
}

by("Matej Lazar")
shared class DefaultServer({<HttpEndpoint|WebSocketBaseEndpoint>*} endpoints)
        satisfies Server {

    Endpoints httpEndpoints = Endpoints();
    value webSocketHandler = CeylonWebSocketHandler();

    variable XnioWorker? worker = null;

    MutableList<Callable<Anything, [Status]>> statusListeners 
            = LinkedList<Callable<Anything, [Status]>>();

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
        
        value sessionconfig = SessionCookieConfig();
        value sessionHandler 
                = SessionAttachmentHandler(InMemorySessionManager(options.sessionId), sessionconfig);
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
        value ceylonRequestHandler = CeylonRequestHandler(options, httpEndpoints);

        HttpOpenListener openListener 
                = HttpOpenListener(
            XnioByteBufferPool(ByteBufferSlicePool(directByteBufferAllocator, 8192, 8192 * 8192)), 
            omBuilder().set(utBufferPipelinedData,false).map);
        
        PathTemplateHandler pathTemplateHandler = PathTemplateHandler(CeylonRequestHandler(options, httpEndpoints));
        for (endpoint in httpEndpoints.endpoints) {
            if (is TemplateMatcher matcher = endpoint.path) {
                assert (is Endpoint endpoint);
                pathTemplateHandler.add(matcher.template, TemplateCeylonRequestHandler(options, endpoint));
            }
        }
        
        openListener.rootHandler = getHandlers(options, pathTemplateHandler);
        
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
        
        worker = NioXnioProvider().instance.createWorker(workerOptions);
        
        InetSocketAddress jSocketAddress 
                = InetSocketAddress(socketAddress.address, socketAddress.port);
        
        value acceptListener = clOpenListenerAdapter(openListener);
        
        if (exists w = worker) {
            w.createStreamConnectionServer(jSocketAddress, 
                acceptListener, serverOptions)
                    .resumeAccepts();
        } else {
            throw InternalException("Missing xnio worker!");
        }
        
        object shutdownHook satisfies JRunnable {
            shared actual void run() {
                stop();
            }
        }
        
        JThread shutdownThread 
                = JThread(shutdownHook, "Shutdown thread");
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

    addEndpoint(HttpEndpoint endpoint) 
            => httpEndpoints.add(endpoint);
    
    addWebSocketEndpoint(WebSocketBaseEndpoint endpoint) 
            => webSocketHandler.addEndpoint(endpoint);
    
    addListener(void listener(Status status)) 
            => statusListeners.add( listener );
}

