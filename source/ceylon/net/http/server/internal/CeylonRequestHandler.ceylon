import io.undertow.server { JHttpServerExchange = HttpServerExchange, HttpHandler}
import io.undertow.util { WorkerDispatcher {wdDispatch = dispatch}}
import ceylon.net.http.server { Request, AsynchronousEndpoint, Endpoint }
import ceylon.collection { LinkedList }
import java.lang { Runnable }
import ceylon.io.charset { Charset }

by "Matej Lazar"
shared class CeylonRequestHandler(Charset defaultCharset) satisfies HttpHandler {
    
    value endpoints = LinkedList<Endpoint|AsynchronousEndpoint>();
    
    shared void addWebEndpoint(Endpoint|AsynchronousEndpoint endpoint) {
        endpoints.add(endpoint);
    }
    
    shared actual void handleRequest(JHttpServerExchange? exchange) {
        
        if (exists exc = exchange) {
            RequestImpl request = RequestImpl(exc);
            ResponseImpl response = ResponseImpl(exc, defaultCharset);
            
            try {
                String requestPath = request.path;
                Endpoint|AsynchronousEndpoint|Null endpoint = getWebEndpoint(requestPath);
                
                if (exists e = endpoint) {
                    request.endpoint = e;
                    invokeEndpoint(e, request, response, exc);
                } else {
                    response.responseStatus=404;
                    response.responseDone();
                    exc.endExchange();
                }
            } catch(Exception e) {
                //TODO write to log
                e.printStackTrace();
                response.responseStatus=500;
                response.responseDone();
                exc.endExchange();
            }
        } else {
            //TODO log fatal
            print("Underlying HttpServerExchange or CompletionHandler must be provided.");
        }
    }

    void invokeEndpoint(Endpoint|AsynchronousEndpoint endpoint, Request request, ResponseImpl response, JHttpServerExchange exchange ) {
        switch (endpoint)
        case (is AsynchronousEndpoint) {
            wdDispatch(exchange, AsyncInvoker(endpoint, request, response, exchange));
        }
        case (is Endpoint) {
            endpoint.service(request, response);
            response.responseDone();
            exchange.endExchange();
        }
    }
    
    class AsyncInvoker(AsynchronousEndpoint endpoint, Request request, ResponseImpl response, JHttpServerExchange exchange) 
            satisfies Runnable {
        shared actual void run() {
            void complete() {
                response.responseDone();
                exchange.endExchange();
            }
            endpoint.service(request, response, complete);
        }
    }
    

    Endpoint|AsynchronousEndpoint|Null getWebEndpoint(String requestPath) {
        for (endpoint in endpoints) {
            if (endpoint.path.matches(requestPath)) {
                return endpoint;
            }
        }
        return null;
    }
}
