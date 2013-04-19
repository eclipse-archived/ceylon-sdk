import io.undertow.server { JHttpServerExchange = HttpServerExchange, HttpHandler}
import ceylon.net.http.server { Request, AsynchronousEndpoint, Endpoint, Options, InternalException }
import ceylon.collection { LinkedList }
import java.lang { Runnable }
import ceylon.net.http { Method }

by("Matej Lazar")
shared class CeylonRequestHandler() satisfies HttpHandler {
    
    value endpoints = LinkedList<Endpoint|AsynchronousEndpoint>();
    
    shared variable Options? options = null;
    
    shared void addWebEndpoint(Endpoint|AsynchronousEndpoint endpoint) {
        endpoints.add(endpoint);
    }
    
    shared actual void handleRequest(JHttpServerExchange? exchange) {
        if (exists o = options) {
            if (exists exc = exchange) {
                RequestImpl request = RequestImpl(exc);
                ResponseImpl response = ResponseImpl(exc, o.defaultCharset);
                
                try {
                    String requestPath = request.path;
                    Method method = request.method;
                    Endpoint|AsynchronousEndpoint|Null endpoint = getWebEndpoint(requestPath, method);
                    
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
                throw InternalException("Underlying HttpServerExchange must be provided.");
            }
        } else {
            throw InternalException("Options must be set before handling request.");
        }
    }

    void invokeEndpoint(Endpoint|AsynchronousEndpoint endpoint, Request request, ResponseImpl response, JHttpServerExchange exchange ) {
        switch (endpoint)
        case (is AsynchronousEndpoint) {
            exchange.dispatch(AsyncInvoker(endpoint, request, response, exchange));
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
    

    Endpoint|AsynchronousEndpoint|Null getWebEndpoint(String requestPath, Method method) {
        for (endpoint in endpoints) {
            if (endpoint.path.matches(requestPath) && endpoint.acceptMethod(method) ) {
                return endpoint;
            }
        }
        return null;
    }
}
