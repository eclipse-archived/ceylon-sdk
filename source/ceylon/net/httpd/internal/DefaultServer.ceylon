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
        xnioWorkerWriteThreads = \iWORKER_WRITE_THREADS,
        xnioWorkerReadThreads = \iWORKER_READ_THREADS,
        xnioConnectionLowWatter = \iCONNECTION_LOW_WATER,
        xnioConnectionHighWatter = \iCONNECTION_HIGH_WATER,
        xnioWorkerTaskCoreThreads = \iWORKER_TASK_CORE_THREADS,
        xnioWorkerTaskMaxThreads = \iWORKER_TASK_MAX_THREADS,
        xnioTcpNoDelay = \iTCP_NODELAY
    }, 
    ByteBufferSlicePool, 
    BufferAllocator {directByteBufferAllocator  = \iDIRECT_BYTE_BUFFER_ALLOCATOR},
    ChannelListener
}
import org.xnio.channels { AcceptingChannel, ConnectedStreamChannel, ConnectedChannel }
import io.undertow.server { HttpOpenListener, HttpTransferEncodingHandler, HttpHandler }
import io.undertow.server.handlers { CanonicalPathHandler, CookieHandler }
import io.undertow.server.handlers.error { SimpleErrorPageHandler }
import ceylon.net.httpd { Server, Options, StatusListener, Status, starting, started, stoping, stopped, Endpoint, AsynchronousEndpoint }
import io.undertow.server.handlers.form { FormEncodedDataHandler, EagerFormParsingHandler, MultiPartHandler }
import io.undertow.server.session { InMemorySessionManager, SessionAttachmentHandler, SessionCookieConfig }
import ceylon.collection { LinkedList, MutableList }

by "Matej Lazar"
shared class DefaultServer() satisfies Server {
    
    variable XnioWorker? worker = null;
    
    CeylonRequestHandler ceylonHandler = CeylonRequestHandler();
    
    JavaHelper jh = JavaHelper();
    
    MutableList<StatusListener> statusListeners = LinkedList<StatusListener>();
    
    shared actual void addEndpoint(Endpoint|AsynchronousEndpoint webEndpoint) {
        ceylonHandler.addWebEndpoint(webEndpoint);
    }
    
    shared actual void start(Integer port, String host, Options httpdOptions) {
        notifyListeners(starting);
        //TODO log
        print("Starting on ``host``:``port``");
        
        value sessionconfig = SessionCookieConfig();
        
        SessionAttachmentHandler session = SessionAttachmentHandler(InMemorySessionManager(), sessionconfig);
        session.setNext(ceylonHandler);
        
        CookieHandler cookieHandler = CookieHandler();
        cookieHandler.next = session;
        
        EagerFormParsingHandler eagerFormParsingHandler = EagerFormParsingHandler();
        eagerFormParsingHandler.next = cookieHandler;
        
        FormEncodedDataHandler formEncodedDataHandler = FormEncodedDataHandler();
        formEncodedDataHandler.next = eagerFormParsingHandler;
        
        MultiPartHandler multiPartHandler = MultiPartHandler();
        multiPartHandler.next = formEncodedDataHandler;
        
        HttpHandler errPageHandler = SimpleErrorPageHandler(multiPartHandler);
        HttpHandler cannonicalPathHandler = CanonicalPathHandler(errPageHandler);
        HttpHandler httpTransferEncoding = HttpTransferEncodingHandler(cannonicalPathHandler);
        
        HttpOpenListener openListener = HttpOpenListener(ByteBufferSlicePool(directByteBufferAllocator, 8192, 8192 * 8192), 8192);
        openListener.rootHandler = httpTransferEncoding;
        
        object channelListener satisfies ChannelListener<AcceptingChannel<ConnectedStreamChannel>> {
            shared actual void handleEvent(AcceptingChannel<ConnectedStreamChannel>? channel) {
                if (exists channel) {
                    ConnectedStreamChannel? accept = channel.accept();
                    if (exists accept) {
                        openListener.handleEvent(accept);
                    }		
                }
            }
        }
        
        OptionMap optionMap = omBuilder()
                .set(xnioWorkerWriteThreads, JInt(httpdOptions.workerWriteThreads))
                .set(xnioWorkerReadThreads, JInt(httpdOptions.workerReadThreads))
                .set(xnioConnectionLowWatter, JInt(httpdOptions.connectionLowWatter))
                .set(xnioConnectionHighWatter, JInt(httpdOptions.connectionHighWatter))
                .set(xnioWorkerTaskCoreThreads, JInt(httpdOptions.workerTaskCoreThreads))
                .set(xnioWorkerTaskMaxThreads, JInt(httpdOptions.workerTaskMaxThreads))
                .set(xnioTcpNoDelay, true)
                .map;
        
        worker = xnioInstance.createWorker(optionMap);
        
        InetSocketAddress socketAddress = InetSocketAddress(host, port);
        AcceptingChannel<ConnectedChannel> acceptingChannel = jh.createStreamServer(worker, socketAddress, channelListener, optionMap);
        acceptingChannel.resumeAccepts();
        
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
    
    shared actual void startInBackground(Integer port, String host, Options httpdOptions) {
        object httpd satisfies JRunnable {
            shared actual void run() {
                start(port, host, httpdOptions);
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
        //TODO statusListeners.remove(listener);
        throw Exception("NOT IMPLEMENTED YET!");
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

