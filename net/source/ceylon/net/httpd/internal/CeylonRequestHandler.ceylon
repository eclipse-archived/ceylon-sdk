import io.undertow.server { HttpServerExchange, JHttpCompletionHandler = HttpCompletionHandler, HttpHandler}
import io.undertow.util { WorkerDispatcher {wdDispatch = dispatch}}
import ceylon.net.httpd { HttpRequest, WebEndpoint, WebEndpointConfig, WebEndpointAsync, HttpCompletionHandler }
import ceylon.collection { HashMap }
import java.lang { Runnable }
import io.undertow.server.handlers.form { FormDataParser, FormData }

shared class CeylonRequestHandler() satisfies HttpHandler {

	HashMap<String, WebEndpointConfig> webEndpointConfigs = HashMap<String, WebEndpointConfig>();

	shared actual void handleRequest(HttpServerExchange? httpServerExchange, JHttpCompletionHandler? utCompletionHandler) {
		if (exists httpServerExchange, exists utCompletionHandler) {
			HttpRequestImpl request = HttpRequestImpl(httpServerExchange);
			HttpResponseImpl response = HttpResponseImpl(httpServerExchange);

			try {
				String requestPath = request.path();
				WebEndpointConfig? webEndpointConfig = getWebEndpointConfig(requestPath);
				
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
	
	void invokeWebEndpoint(WebEndpointConfig webEndpointConfig, HttpRequest request, HttpResponseImpl response, HttpServerExchange exchange, JHttpCompletionHandler utCompletionHandler ) {

		WebModuleLoader webModuleLoader = WebModuleLoader();
		WebEndpoint|WebEndpointAsync webApp = webModuleLoader.instance(webEndpointConfig);
		
		if (is WebEndpointAsync webApp) {
			wdDispatch(exchange, AsyncInvoker(webApp, request, response, exchange, utCompletionHandler));
		} else if (is WebEndpoint webApp) {
			webApp.service(request, response);
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
		webEndpointConfigs.put(webEndpointConfig.path, webEndpointConfig);
	}
	
	WebEndpointConfig? getWebEndpointConfig(String path) {
		//TODO wildcard/regex matching path
		
		for (config in webEndpointConfigs) {
			if (path.contains(config.key)) {
				return config.item;
			}
		}
		//return webEndpointConfigs.item(path);
		return null;
	}
}