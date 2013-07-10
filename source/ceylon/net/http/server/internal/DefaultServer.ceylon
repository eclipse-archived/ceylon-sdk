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
import io.undertow.server { HttpOpenListener, HttpHandler }
import io.undertow.server.handlers { URLDecodingHandler }
import io.undertow.server.handlers.error { SimpleErrorPageHandler }
import ceylon.net.http.server { Server, Options, StatusListener, Status, starting, started, stoping, stopped, Endpoint, AsynchronousEndpoint, InternalException }
import io.undertow.server.session { InMemorySessionManager, SessionAttachmentHandler, SessionCookieConfig }
import ceylon.collection { LinkedList, MutableList }
import io.undertow { UndertowOptions { utBufferPipelinedData = \iBUFFER_PIPELINED_DATA} }

by("Matej Lazar")
shared class DefaultServer() satisfies Server {
    
    variable XnioWorker? worker = null;
    
    variable CeylonRequestHandler ceylonHandler = CeylonRequestHandler();
    
    MutableList<StatusListener> statusListeners = LinkedList<StatusListener>();
    
    shared actual void addEndpoint(Endpoint|AsynchronousEndpoint endpoint) {
        ceylonHandler.addWebEndpoint(endpoint);
    }
    
    HttpHandler getHeandlers(Options options) {
        value sessionconfig = SessionCookieConfig();
        SessionAttachmentHandler sessionHandler = SessionAttachmentHandler(InMemorySessionManager(), sessionconfig);
        sessionHandler.setNext(ceylonHandler);
        
        HttpHandler errPageHandler = SimpleErrorPageHandler(sessionHandler);
        
        //URLDecodingHandler urlDecodingHandler = URLDecodingHandler(errPageHandler, options.defaultCharset.name);
        //return urlDecodingHandler;
        return errPageHandler;
    }
    
    shared actual void start(Integer port, String host, Options options) {
        notifyListeners(starting);
        //TODO log
        print("Starting on ``host``:``port``");
        
        ceylonHandler.options = options;

        HttpOpenListener openListener = HttpOpenListener(
        ByteBufferSlicePool(
            directByteBufferAllocator, 8192, 8192 * 8192), 
            omBuilder().set(utBufferPipelinedData, false).map ,
            8192 );
        
        openListener.rootHandler = getHeandlers(options);
        
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
        
        InetSocketAddress socketAddress = InetSocketAddress(host, port);
        
        ChannelListener<AcceptingChannel<StreamConnection>> acceptListener = clOpenListenerAdapter(openListener);
        
        if (exists w = worker) {
            AcceptingChannel<StreamConnection> server = w.createStreamConnectionServer(socketAddress, acceptListener, serverOptions);
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
    
    shared actual void startInBackground(Integer port, String host, Options options) {
        object httpd satisfies JRunnable {
            shared actual void run() {
                start(port, host, options);
            }
        }
        JThread(httpd).start();
    }
    
    shared actual void stop() {
        if (exists w = worker) {
            notifyListeners(stoping);
            w.shutdown();
            //TODO log
            print("Httpd stopped.");
            notifyListeners(stopped);
            worker = null;
        }
    }
    
    shared actual void addListener(StatusListener listener) {
        statusListeners.add(listener);
    }
    
    shared actual void removeListener(StatusListener listener) {
        statusListeners.removeElement(listener);
    }
    
    void notifyListeners(Status status) {
        for (listener in statusListeners) {
            listener.onStatusChange(status);
        }
    }

    //TODO use instead of [[JavaHelper]]
    //AcceptingChannel<ConnectedChannel> createStreamServer(
    //        XnioWorker worker, 
    //        InetSocketAddress bindAddress,
    //        ChannelListener<AcceptingChannel<ConnectedStreamChannel>> acceptListener,
    //        OptionMap optionMap) { 
    //    return worker.createStreamServer(bindAddress, acceptListener, optionMap);
    //}
}

