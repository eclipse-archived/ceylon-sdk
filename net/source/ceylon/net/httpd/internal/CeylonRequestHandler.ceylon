import io.undertow.server { HttpServerExchange, JHttpCompletionHandler = HttpCompletionHandler, HttpHandler}
import io.undertow.util { WorkerDispatcher {wdDispatch = dispatch}}
import ceylon.net.httpd { HttpRequest, WebEndpoint, WebEndpointAsync, HttpCompletionHandler, WebEndpointConfig }
import ceylon.collection { MutableList, LinkedList }
import java.lang { Runnable }

shared class CeylonRequestHandler() satisfies HttpHandler {

	MutableList<WebEndpointConfigInternal> webEndpointConfigs = LinkedList<WebEndpointConfigInternal>();

	shared actual void handleRequest(HttpServerExchange? httpServerExchange, JHttpCompletionHandler? utCompletionHandler) {
		if (exists httpServerExchange, exists utCompletionHandler) {
			HttpRequestImpl request = HttpRequestImpl(httpServerExchange);
			HttpResponseImpl response = HttpResponseImpl(httpServerExchange);

			try {
				String requestPath = request.path();
				WebEndpointConfigInternal? webEndpointConfig = getWebEndpointConfig(requestPath);
				
				if (exists webEndpointConfig) {
					request.webEndpointConfig(webEndpointConfig);
					invokeWebEndpoint(webEndpointConfig, request, response, httpServerExchange, utCompletionHandler);
				} else {
					response.responseStatus(404);
					response.responseDone();
					utCompletionHandler.handleComplete();
				}
			} catch(Exception e) {
				//TODO write to log
				process.writeErrorLine("" e.string "");
				e.printStackTrace();
				response.responseStatus(500);
			    response.responseDone();
				utCompletionHandler.handleComplete();
			}
		}
	}
	
	void invokeWebEndpoint(WebEndpointConfigInternal webEndpointConfig, HttpRequest request, HttpResponseImpl response, HttpServerExchange exchange, JHttpCompletionHandler utCompletionHandler ) {

		WebModuleLoader webModuleLoader = WebModuleLoader();

		if (exists webEndpoint = webEndpointConfig.webEndpoint) {
		} else {
			//TODO use synchronized to make shure that WebEndpoint is singleton
			value webEndpoint = webModuleLoader.instance(webEndpointConfig);
			webEndpointConfig.setWebEndpoint(webEndpoint);
		}

		//if(!exists webEndpoint) {
		//	//TODO use synchronized to make shure that WebEndpoint is singleton
		//	webEndpoint := webModuleLoader.instance(webEndpointConfig);
		//	webEndpointConfig.setWebEndpoint(webEndpoint);
		//	
		//	if (exists w = webEndpoint) {
		//		webEndpointConfig.setWebEndpoint(w);
		//	} else {
		//		//TODO something is wrong 
		//	}
		//}
		
		value webEndpoint = webEndpointConfig.webEndpoint;
		
		if (is WebEndpointAsync w = webEndpoint) {
			wdDispatch(exchange, AsyncInvoker(w, request, response, exchange, utCompletionHandler));
		} else if (is WebEndpoint w = webEndpoint) {
			w.service(request, response);
			response.responseDone();
			utCompletionHandler.handleComplete();
		} 
	}
		
	class AsyncInvoker(WebEndpointAsync webApp, HttpRequest request, HttpResponseImpl response, HttpServerExchange exchange, JHttpCompletionHandler utCompletionHandler) satisfies Runnable {
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
	
	shared void addWebEndpointMapping(WebEndpointConfig webEndpointConfig) {
		WebEndpointConfigInternal internalConfig = WebEndpointConfigInternal(webEndpointConfig);
		webEndpointConfigs.add(internalConfig);
	}
	
	WebEndpointConfigInternal? getWebEndpointConfig(String path) {
		//TODO wildcard/regex matching path
		
		for (config in webEndpointConfigs) {
			if (path.contains(config.path)) {
				return config;
			}
		}
		//return webEndpointConfigs.item(path);
		return null;
	}
}