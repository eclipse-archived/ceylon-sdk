import io.undertow.server { JHttpServerExchange = HttpServerExchange, HttpHandler}
import ceylon.net.http.server { Request, AsynchronousEndpoint, Endpoint, Options, InternalException, HttpEndpoint }
import ceylon.net.http { Method, allow, parseMethod }
import io.undertow.server.handlers.form { FormParserFactory { formParserFactoryBuilder = builder } }

by("Matej Lazar")
shared class CeylonRequestHandler(Options options, Endpoints endpoints) satisfies HttpHandler {
    
    FormParserFactory formParserFactory = formParserFactoryBuilder().build();
    
    void endResponse(JHttpServerExchange exchange, ResponseImpl response, Integer responseStatus) {
        response.responseStatus = responseStatus;
        response.responseDone();
        exchange.endExchange();
    }
    
    shared actual void handleRequest(JHttpServerExchange? exchange) {
        if (exists exc = exchange) {
            ResponseImpl response = ResponseImpl(exc, options.defaultCharset);
            try {
                String requestPath = exc.requestPath;
                Method method = parseMethod(exc.requestMethod.string.uppercased);
                value endpoint = endpoints.getEndpointMatchingPath(requestPath);
                
                if (is HttpEndpoint e = endpoint) {
                    if (isMethodSupported(e, method)) {
                        RequestImpl request = RequestImpl { 
                            exchange = exc; 
                            formParserFactory = formParserFactory;
                            endpoint = e;
                            path = requestPath;
                            method = method;
                        };
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
