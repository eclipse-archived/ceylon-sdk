import java.lang { 
	JInt = Integer,
	Runtime { jRuntime = runtime }, 
	JThread = Thread, 
	JRunnable = Runnable, ClassLoader 
}
import java.net { InetSocketAddress }
import org.xnio { 
	Xnio { xnioInstance = instance }, 
	XnioWorker, 
	OptionMap { omBuilder = builder }, 
	Options { 
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
import ceylon.net.httpd { Httpd, HttpdOptions, WebEndpointConfig, HttpdInternalException }
import io.undertow.server.handlers.form { FormEncodedDataHandler, EagerFormParsingHandler, MultiPartHandler }
import io.undertow.server.session { InMemorySessionManager, SessionAttachmentHandler }
import org.jboss.modules { ModuleClassLoader }

shared class DefaultHttpdServer() satisfies Httpd {
	
	CeylonRequestHandler ceylonHandler = CeylonRequestHandler();

	JavaHelper jh = JavaHelper();

	shared actual void addWebEndpointConfig(WebEndpointConfig webEndpointConfig) {
		ceylonHandler.addWebEndpointMapping(webEndpointConfig);
	}

	shared actual void loadWebEndpointConfig(String? _moduleId, String pathToModuleConfig) {
		variable String? moduleId := null;

		if (exists _moduleId) {
			if (!_moduleId.empty) {
				moduleId := _moduleId;
			}
		}
		if (!exists moduleId) {
			moduleId := getLocalModuleId();
		}

		if (exists mid = moduleId) {
			List<WebEndpointConfig> webEndpointConfigs = parseWebEndpointConfig(mid, pathToModuleConfig);
			
			for (WebEndpointConfig webEndpointConfig in webEndpointConfigs) {
				ceylonHandler.addWebEndpointMapping(webEndpointConfig);
			}
		} else {
			throw HttpdInternalException("ModuleId not defined.");
		}
	}

	shared actual void scan() {
	//TODO scan for configs
	}

	shared actual void start(Integer port, String host, HttpdOptions httpdOptions) {
		
		//TODO log
		print("starting on " host ":" port "");

        SessionAttachmentHandler session = SessionAttachmentHandler(InMemorySessionManager());
        session.setNext(ceylonHandler);

        CookieHandler cookieHandler = CookieHandler();
        cookieHandler.next := session;
		
		EagerFormParsingHandler eagerFormParsingHandler = EagerFormParsingHandler();
		eagerFormParsingHandler.next := cookieHandler;
		
		FormEncodedDataHandler formEncodedDataHandler = FormEncodedDataHandler();
		formEncodedDataHandler.next := eagerFormParsingHandler;
		
		MultiPartHandler multiPartHandler = MultiPartHandler();
		multiPartHandler.next := formEncodedDataHandler;

		HttpHandler errPageHandler = SimpleErrorPageHandler(multiPartHandler);
		HttpHandler cannonicalPathHandler = CanonicalPathHandler(errPageHandler);
		HttpHandler httpTransferEncoding = HttpTransferEncodingHandler(cannonicalPathHandler);
		
		HttpOpenListener openListener = HttpOpenListener(ByteBufferSlicePool(directByteBufferAllocator, 8192, 8192 * 8192), 8192);
		openListener.rootHandler := httpTransferEncoding;
		
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
		
		XnioWorker worker = xnioInstance.createWorker(optionMap);

		InetSocketAddress socketAddress = InetSocketAddress(host, port);
		AcceptingChannel<ConnectedChannel> acceptingChannel = jh.createStreamServer(worker, socketAddress, channelListener, optionMap);
		acceptingChannel.resumeAccepts();
		
		object shutdownHook satisfies JRunnable {
			shared actual void run() {
	    		//TODO log
	    		print("Httpd stopped.");
	    	}
		}
		
		JThread shutdownThread = JThread(shutdownHook, "Shutdown thread");
	    shutdownThread.daemon := false;
	    jRuntime.addShutdownHook(shutdownThread);

		worker.awaitTermination();
	}

	String getLocalModuleId() { 
		ClassLoader cl = jh.getClassLoader(this);
		if (is ModuleClassLoader cl) {
			return cl.\imodule.identifier.string;
		} else {
			//running in IDE
			return "--flat-class-loader--";
		}
	}
}