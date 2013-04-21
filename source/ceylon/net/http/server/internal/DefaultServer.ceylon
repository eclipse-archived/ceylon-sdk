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
import io.undertow.server { HttpOpenListener, HttpHandler }
import io.undertow.server.handlers { CookieHandler, URLDecodingHandler }
import io.undertow.server.handlers.error { SimpleErrorPageHandler }
import ceylon.net.http.server { Server, Options, StatusListener, Status, starting, started, stoping, stopped, Endpoint, AsynchronousEndpoint }
import io.undertow.server.handlers.form { FormEncodedDataHandler, MultiPartHandler, EagerFormParsingHandler }
import io.undertow.server.session { InMemorySessionManager, SessionAttachmentHandler, SessionCookieConfig }
import ceylon.collection { LinkedList, MutableList }

by "Matej Lazar"
shared class DefaultServer() satisfies Server {
    
    variable XnioWorker? worker = null;
    
    variable CeylonRequestHandler ceylonHandler = CeylonRequestHandler();
    
    JavaHelper jh = JavaHelper();
    
    MutableList<StatusListener> statusListeners = LinkedList<StatusListener>();
    
    shared actual void addEndpoint(Endpoint|AsynchronousEndpoint endpoint) {
        ceylonHandler.addWebEndpoint(endpoint);
    }
    
    shared actual void start(Integer port, String host, Options options) {
        notifyListeners(starting);
        //TODO log
        print("Starting on ``host``:``port``");
        
        ceylonHandler.options = options;
        
        value sessionconfig = SessionCookieConfig();
        
        SessionAttachmentHandler session = SessionAttachmentHandler(InMemorySessionManager(), sessionconfig);
        session.setNext(ceylonHandler);
        
        CookieHandler cookieHandler = CookieHandler();
        cookieHandler.setNext(session);
        
        EagerFormParsingHandler eagerFormParsingHandler = EagerFormParsingHandler();
        eagerFormParsingHandler.setNext(cookieHandler);
        
        MultiPartHandler multiPartHandler = MultiPartHandler();
        multiPartHandler.setNext(eagerFormParsingHandler);
        multiPartHandler.setDefaultEncoding(options.defaultCharset.name);
        
        FormEncodedDataHandler formEncodedDataHandler = FormEncodedDataHandler();
        formEncodedDataHandler.setNext(multiPartHandler);
        formEncodedDataHandler.setDefaultEncoding(options.defaultCharset.name);
        
        HttpHandler errPageHandler = SimpleErrorPageHandler(formEncodedDataHandler);

        URLDecodingHandler urlDecodingHandler = URLDecodingHandler();
        urlDecodingHandler.setNext(errPageHandler);
        urlDecodingHandler.setCharset(options.defaultCharset.name);
        
        HttpOpenListener openListener = HttpOpenListener(ByteBufferSlicePool(directByteBufferAllocator, 8192, 8192 * 8192), 8192);
        openListener.rootHandler = urlDecodingHandler;
        
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
                .set(xnioWorkerWriteThreads, JInt(options.workerWriteThreads))
                .set(xnioWorkerReadThreads, JInt(options.workerReadThreads))
                .set(xnioConnectionLowWatter, JInt(options.connectionLowWatter))
                .set(xnioConnectionHighWatter, JInt(options.connectionHighWatter))
                .set(xnioWorkerTaskCoreThreads, JInt(options.workerTaskCoreThreads))
                .set(xnioWorkerTaskMaxThreads, JInt(options.workerTaskMaxThreads))
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

