import io.undertow.server { HttpServerExchange, JHttpCompletionHandler = HttpCompletionHandler, HttpHandler}
import io.undertow.util { WorkerDispatcher {wdDispatch = dispatch}}
import ceylon.net.httpd { HttpRequest, HttpResponse, WebEndpoint, WebEndpointMapping, WebEndpointAsync, HttpCompletionHandler }
import ceylon.collection { HashMap }
import java.lang { Runnable }

shared class CeylonRequestHandler() satisfies HttpHandler {

	HashMap<String, WebEndpointMapping> webEndpointMapings = HashMap<String, WebEndpointMapping>();

	shared actual void handleRequest(HttpServerExchange? httpServerExchange, JHttpCompletionHandler? utCompletionHandler) {
		if (exists httpServerExchange, exists utCompletionHandler) {
			HttpRequest request = HttpRequestImpl(httpServerExchange);
			HttpResponse response = HttpResponseImpl(httpServerExchange);

			try {
				String requestPath = request.path();
				WebEndpointMapping? webEndpointMapping = getWebEndpointMapping(requestPath);
				
				if (exists webEndpointMapping) {
					invokeWebEndpoint(webEndpointMapping, request, response, httpServerExchange, utCompletionHandler);
				} else {
					response.responseStatus(404);
					response.responseDone();
					utCompletionHandler.handleComplete();
				}
			} catch(Exception e) {
				//TODO write to log
				process.writeErrorLine("" e.string "");
				response.responseStatus(500);
			    response.responseDone();
				utCompletionHandler.handleComplete();
			}
		}
	}
	
	void invokeWebEndpoint(WebEndpointMapping webEndpointMapping, HttpRequest request, HttpResponse response, HttpServerExchange exchange, JHttpCompletionHandler utCompletionHandler ) {

		String moduleName = webEndpointMapping.moduleName;
		String className = webEndpointMapping.className;
		String moduleSlot = webEndpointMapping.moduleSlot;

		WebModuleLoader webModuleLoader = WebModuleLoader();
		WebEndpoint|WebEndpointAsync webApp = webModuleLoader.instance(moduleName, className, moduleSlot);
		
		if (is WebEndpointAsync webApp) {
			wdDispatch(exchange, AsyncInvoker(webApp, request, response, exchange, utCompletionHandler));
		} else if (is WebEndpoint webApp) {
			webApp.service(request, response);
			response.responseDone();
			utCompletionHandler.handleComplete();
		} 
        //async file stream/channel closer
        //object chListener satisfies ChannelListener<Channel> {
        //    shared actual void handleEvent(Channel? channel) {
        //        //TODO IoUtils.safeClose(fileChannel);
        //    }
        //}
        //TODO response.getCloseSetter().set(chListener);
		
	}
		
	class AsyncInvoker(WebEndpointAsync webApp, HttpRequest request, HttpResponse response, HttpServerExchange exchange, JHttpCompletionHandler utCompletionHandler) satisfies Runnable {
		shared actual void run() {
			object completionHandler satisfies HttpCompletionHandler {
				shared actual void handleComplete() {
					response.responseDone();
					utCompletionHandler.handleComplete();
				}
			}
			webApp.service(request, response, completionHandler);
		}
	}
	
	shared void addWebEndpointMapping(WebEndpointMapping webEndpointMapping) {
		webEndpointMapings.put(webEndpointMapping.path, webEndpointMapping);
	}
	
	WebEndpointMapping? getWebEndpointMapping(String mappedPath) {
		//TODO wildcard/regex matching path
		return webEndpointMapings.item(mappedPath);
	}
}