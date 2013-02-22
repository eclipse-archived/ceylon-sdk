import io.undertow.server { JHttpServerExchange = HttpServerExchange, JHttpCompletionHandler = HttpCompletionHandler, HttpHandler}
import io.undertow.util { WorkerDispatcher {wdDispatch = dispatch}}
import ceylon.net.httpd { Request, AsynchronousEndpoint, Endpoint }
import ceylon.collection { LinkedList }
import java.lang { Runnable }
import ceylon.io.charset { Charset }

by "Matej Lazar"
shared class CeylonRequestHandler(Charset defaultCharset) satisfies HttpHandler {
    
    value webEndpoints = LinkedList<Endpoint|AsynchronousEndpoint>();
    
    shared void addWebEndpoint(Endpoint|AsynchronousEndpoint webEndpoint) {
        webEndpoints.add(webEndpoint);
    }
    
    shared actual void handleRequest(JHttpServerExchange? httpServerExchange, JHttpCompletionHandler? utCompletionHandler) {
        
        if (exists hse = httpServerExchange, exists utCompletionHandler) {
            HttpRequestImpl request = HttpRequestImpl(hse);
            HttpResponseImpl response = HttpResponseImpl(hse, defaultCharset);
            
            try {
                String requestPath = request.path;
                Endpoint|AsynchronousEndpoint|Null webEndpoint = getWebEndpoint(requestPath);
                
                if (exists w = webEndpoint) {
                    request.endpoint = w;
                    invokeWebEndpoint(w, request, response, hse, utCompletionHandler);
                } else {
                    response.responseStatus=404;
                    response.responseDone();
                    utCompletionHandler.handleComplete();
                }
            } catch(Exception e) {
                //TODO write to log
                process.writeErrorLine("" + e.string + "");
                e.printStackTrace();
                response.responseStatus=500;
                response.responseDone();
                utCompletionHandler.handleComplete();
            }
        } else {
            //TODO log fatal
            print("Underlying HttpServerExchange or CompletionHandler must be provided.");
        }
    }

    void invokeWebEndpoint(Endpoint|AsynchronousEndpoint webEndpoint, Request request, HttpResponseImpl response, JHttpServerExchange exchange, JHttpCompletionHandler utCompletionHandler ) {
        switch (webEndpoint)
        case (is AsynchronousEndpoint) {
            wdDispatch(exchange, AsyncInvoker(webEndpoint, request, response, exchange, utCompletionHandler));
        }
        case (is Endpoint) {
            webEndpoint.service(request, response);
            response.responseDone();
            utCompletionHandler.handleComplete();
        }
    }
    
    class AsyncInvoker(AsynchronousEndpoint webEndpoint, Request request, HttpResponseImpl response, JHttpServerExchange exchange, JHttpCompletionHandler utCompletionHandler) satisfies Runnable {
        shared actual void run() {
            void completionHandler() {
                response.responseDone();
                utCompletionHandler.handleComplete();
            }
            webEndpoint.service(request, response, completionHandler);
        }
    }
    

    Endpoint|AsynchronousEndpoint|Null getWebEndpoint(String requestPath) {
        /*TODO
        create an implementation of Set, which would let you write:
        startsWith("/home") & (endsWith(".jsf") | endsWith(".csf"))
        */
        for (webEndpoint in webEndpoints) {
            if (webEndpoint.pathMatches(requestPath)) {
                return webEndpoint;
            }
        }
        return null;
    }
}
