import io.undertow.server { JHttpServerExchange = HttpServerExchange, JHttpCompletionHandler = HttpCompletionHandler, HttpHandler}
import io.undertow.util { WorkerDispatcher {wdDispatch = dispatch}}
import ceylon.net.httpd { HttpRequest, WebEndpointAsync, CompletionHandler, WebEndpoint }
import ceylon.collection { LinkedList }
import java.lang { Runnable }

by "Matej Lazar"
shared class CeylonRequestHandler() satisfies HttpHandler {
    
    value webEndpoints = LinkedList<WebEndpoint|WebEndpointAsync>();
    
    shared void addWebEndpoint(WebEndpoint|WebEndpointAsync webEndpoint) {
        webEndpoints.add(webEndpoint);
    }
    
    shared actual void handleRequest(JHttpServerExchange? httpServerExchange, JHttpCompletionHandler? utCompletionHandler) {
        
        if (exists hse = httpServerExchange, exists utCompletionHandler) {
            HttpRequestImpl request = HttpRequestImpl(hse);
            HttpResponseImpl response = HttpResponseImpl(hse);
            
            try {
                String requestPath = request.path();
                WebEndpoint|WebEndpointAsync|Null webEndpoint = getWebEndpoint(requestPath);
                
                if (exists w = webEndpoint) {
                    request.webEndpoint(w);
                    invokeWebEndpoint(w, request, response, hse, utCompletionHandler);
                } else {
                    response.responseStatus(404);
                    response.responseDone();
                    utCompletionHandler.handleComplete();
                }
            } catch(Exception e) {
                //TODO write to log
                process.writeErrorLine("" + e.string + "");
                e.printStackTrace();
                response.responseStatus(500);
                response.responseDone();
                utCompletionHandler.handleComplete();
            }
        } else {
            //TODO log error
        }
    }
    
    void invokeWebEndpoint(WebEndpoint|WebEndpointAsync webEndpoint, HttpRequest request, HttpResponseImpl response, JHttpServerExchange exchange, JHttpCompletionHandler utCompletionHandler ) {
        
        switch (webEndpoint)
        case (is WebEndpointAsync) {
            wdDispatch(exchange, AsyncInvoker(webEndpoint, request, response, exchange, utCompletionHandler));
        }
        case (is WebEndpoint) {
            webEndpoint.callService(request, response);
            response.responseDone();
            utCompletionHandler.handleComplete();
        }
    }
    
    class AsyncInvoker(WebEndpointAsync webEndpoint, HttpRequest request, HttpResponseImpl response, JHttpServerExchange exchange, JHttpCompletionHandler utCompletionHandler) satisfies Runnable {
        shared actual void run() {
            object completionHandler satisfies CompletionHandler {
                shared actual void handleComplete() {
                    response.responseDone();
                    utCompletionHandler.handleComplete();
                }
            }
            webEndpoint.callService(request, response, completionHandler);
        }
    }
    
    WebEndpoint|WebEndpointAsync|Null getWebEndpoint(String requestPath) {
        //TODO ends with
        /*
So you need endsWith() as well. No problem, add it.
And you could even write yourself an and() method so that this works:
    
    and(startsWith("/home"), endsWith(".jsf"))

Hell, you could even go as far as writing an implementation of Set,
which would let you write:

    startsWith("/home") & (endsWith(".jsf") | endsWith(".csf"))
            */

        for (webEndpoint in webEndpoints) {
            String endpointPath;
            switch (webEndpoint)
            case (is WebEndpointAsync) {
                endpointPath = webEndpoint.getPath();
            }
            case (is WebEndpoint) {
                endpointPath = webEndpoint.getPath();
            }
            

            if (requestPath.contains(endpointPath)) {
                return webEndpoint;
            }
        }
        return null;
    }   
}