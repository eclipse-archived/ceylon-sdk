import java.lang { JInt = Integer }
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
import com.redhat.ceylon.javaadapter {XnioHelper {createStreamServer}}
import io.undertow.server { HttpOpenListener, HttpTransferEncodingHandler, HttpHandler }
import io.undertow.server.handlers { CanonicalPathHandler }
import io.undertow.server.handlers.error { SimpleErrorPageHandler }
import ceylon.net.httpd { Httpd, WebEndpointConfig, HttpdOptions }

shared class DefaultHttpdServer() satisfies Httpd {
	
	CeylonRequestHandler ceylonHandler = CeylonRequestHandler();

	shared actual void addWebEndpointConfig(WebEndpointConfig webEndpointConfig) {
		ceylonHandler.addWebEndpointMapping(webEndpointConfig);
	}

	shared actual void start(Integer port, String host, HttpdOptions httpdOptions) {
		
		//TODO log
		print("starting on " host ":" port "");

		HttpHandler errPageHandler = SimpleErrorPageHandler(ceylonHandler);
		HttpHandler cannonicalPathHandler = CanonicalPathHandler(errPageHandler);
		HttpHandler httpTransferEncoding = HttpTransferEncodingHandler(cannonicalPathHandler);
		
		HttpOpenListener openListener = HttpOpenListener(ByteBufferSlicePool(directByteBufferAllocator, 8192, 8192 * 8192));
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
		AcceptingChannel<ConnectedChannel> acceptingChannel = createStreamServer(worker, socketAddress, channelListener, optionMap);
		acceptingChannel.resumeAccepts();
	}
}