import io.undertow.server { JHttpServerExchange = HttpServerExchange, HttpHandler}
import ceylon.net.http.server { Request, AsynchronousEndpoint, Endpoint, Options, InternalException, HttpEndpoint }
import java.lang { Runnable }
import ceylon.net.http { Method, allow }
import io.undertow.server.handlers.form { FormParserFactory { formParserFactoryBuilder = builder } }

by("Matej Lazar")
shared class CeylonRequestHandler() satisfies HttpHandler {
    
    value endpoints = Endpoints();
    
    shared variable Options? options = null;
    
    FormParserFactory formParserFactory = formParserFactoryBuilder().build();
    
    shared void addWebEndpoint(HttpEndpoint endpoint) {
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
                    value endpoint = endpoints.getEndpointMatchingPath(requestPath);
                    
                    if (is HttpEndpoint e = endpoint) {
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

    void invokeEndpoint(HttpEndpoint endpoint, Request request, ResponseImpl response, JHttpServerExchange exchange ) {
        switch (endpoint)
        case (is AsynchronousEndpoint) {
            exchange.dispatch(AsyncInvoker(endpoint, request, response));
        }
        case (is Endpoint) {
            exchange.dispatch(SynchronousInvoker(endpoint, request, response));
        }
    }

    class AsyncInvoker(AsynchronousEndpoint endpoint, Request request, ResponseImpl response) 
            satisfies HttpHandler {

        shared actual void handleRequest(JHttpServerExchange? httpServerExchange) {
            void complete() {
                response.responseDone();
                endExchange(httpServerExchange);
            }
            endpoint.service(request, response, complete);
        }
    }

    class SynchronousInvoker(Endpoint endpoint, Request request, ResponseImpl response) 
            satisfies HttpHandler {

        shared actual void handleRequest(JHttpServerExchange? httpServerExchange) {
            endpoint.service(request, response);
            response.responseDone();
            endExchange(httpServerExchange);
        }
    }

    Boolean isMethodSupported(HttpEndpoint endpoint, Method method) { 
        if (endpoint.acceptMethod.size > 0) {
            return endpoint.acceptMethod.contains(method);
        } else {
            return true;
        }
    }

    void endExchange(JHttpServerExchange? httpServerExchange) {
        if (exists httpServerExchange) {
            httpServerExchange.endExchange();
        } else {
            throw InternalException("HttpExchange shoud not be null!");
        }
    }
}
