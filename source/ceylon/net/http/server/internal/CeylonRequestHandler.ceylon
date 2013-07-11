import io.undertow.server { JHttpServerExchange = HttpServerExchange, HttpHandler}
import ceylon.net.http.server { Request, AsynchronousEndpoint, Endpoint, Options, InternalException }
import ceylon.collection { LinkedList }
import java.lang { Runnable }
import ceylon.net.http { Method, allow }
import io.undertow.server.handlers.form { FormParserFactory { formParserFactoryBuilder = builder } }

by("Matej Lazar")
shared class CeylonRequestHandler() satisfies HttpHandler {
    
    value endpoints = LinkedList<Endpoint|AsynchronousEndpoint>();
    
    shared variable Options? options = null;
    
    FormParserFactory formParserFactory = formParserFactoryBuilder().build();
    
    shared void addWebEndpoint(Endpoint|AsynchronousEndpoint endpoint) {
        endpoints.add(endpoint);
    }
    
    void endResponse(JHttpServerExchange exchange, ResponseImpl response, Integer responseStatus) {
        response.responseStatus = responseStatus;
        response.responseDone();
        exchange.endExchange();
    }
    
    shared actual void handleRequest(JHttpServerExchange? exchange) {
        if (exists o = options) {
            if (exists exc = exchange) {
                
                RequestImpl request = RequestImpl(exc, formParserFactory);
                ResponseImpl response = ResponseImpl(exc, o.defaultCharset);
                
                try {
                    String requestPath = request.path;
                    Endpoint|AsynchronousEndpoint|Null endpoint = getWebEndpointMatchingPath(requestPath);
                    
                    if (exists e = endpoint) {
                        if (isMethodSupported(e, request.method)) {
                            request.endpoint = e;
                            invokeEndpoint(e, request, response, exc);
                        } else {
                            response.addHeader(allow(e.acceptMethod));
                            endResponse(exc, response, 405);
                        }
                    } else {
                        endResponse(exc, response, 404);
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
    
    Endpoint|AsynchronousEndpoint|Null getWebEndpointMatchingPath(String requestPath) {
        for (endpoint in endpoints) {
            if (endpoint.path.matches(requestPath)) {
                return endpoint;
            }
        }
        return null;
    }
    
    Boolean isMethodSupported(Endpoint|AsynchronousEndpoint endpoint, Method method) { 
        if (endpoint.acceptMethod.size > 0) {
            return endpoint.acceptMethod.contains(method);
        } else {
            return true;
        }
    }
}
