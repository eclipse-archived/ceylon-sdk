import ceylon.http.common {
    Method,
    allow,
    parseMethod
}
import ceylon.http.server {
    Request,
    AsynchronousEndpoint,
    Endpoint,
    Options,
    InternalException,
    HttpEndpoint,
    EndpointBase
}

import io.undertow.server {
    JHttpServerExchange=HttpServerExchange,
    HttpHandler
}
import io.undertow.server.handlers.form {
    FormParserFactory {
        formParserFactoryBuilder=builder
    }
}
import ceylon.collection {
    LinkedList
}

by("Matej Lazar")
shared class CeylonRequestHandler(Options options, Endpoints endpoints) 
        satisfies HttpHandler {
    
    value formParserFactory 
            = formParserFactoryBuilder().build();
    
    void endResponse(JHttpServerExchange exchange, 
            ResponseImpl response, Integer responseStatus) {
        response.responseStatus = responseStatus;
        response.responseDone();
        exchange.endExchange();
    }
    
    shared actual void handleRequest(JHttpServerExchange? exchange) {
        if (exists exc = exchange) {
            ResponseImpl response = 
                    ResponseImpl(exc, options.defaultCharset);
            try {
                String requestPath = exc.requestPath;
                Method method = parseMethod(exc.requestMethod.string.uppercased);
                {EndpointBase*} endpointsMatchingPath = endpoints.getEndpointMatchingPath(requestPath);
                
                if (endpointsMatchingPath.size > 0) {
                    {HttpEndpoint*} httpEndpoints = filterHttpEndpoints(endpointsMatchingPath);
                    {HttpEndpoint*} matchingEndpoints = filterSupportedMethod(httpEndpoints, method);
                    if (is HttpEndpoint endpoint = matchingEndpoints.first) {
                        RequestImpl request = RequestImpl { 
                            exchange = exc; 
                            formParserFactory = formParserFactory;
                            endpoint = endpoint;
                            path = requestPath;
                            method = method;
                        };
                        invokeEndpoint(endpoint, request, response, exc);
                    } else {
                        {Method*} acceptedMethods = getAllAcceptedMethods(httpEndpoints);
                        response.addHeader(allow(acceptedMethods));
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

    void invokeEndpoint(HttpEndpoint endpoint, 
            Request request, ResponseImpl response, 
            JHttpServerExchange exchange ) {
        switch (endpoint)
        case (is AsynchronousEndpoint) {
            exchange.dispatch(AsyncInvoker(endpoint, 
                request, response));
        }
        case (is Endpoint) {
            exchange.dispatch(SynchronousInvoker(endpoint, 
                request, response));
        }
    }

    class AsyncInvoker(AsynchronousEndpoint endpoint, 
            Request request, ResponseImpl response) 
            satisfies HttpHandler {

        shared actual void handleRequest(JHttpServerExchange? httpServerExchange) {
            void complete() {
                response.responseDone();
                endExchange(httpServerExchange);
            }
            endpoint.service(request, response, complete);
        }
    }

    class SynchronousInvoker(Endpoint endpoint, 
            Request request, ResponseImpl response) 
            satisfies HttpHandler {

        shared actual void handleRequest(JHttpServerExchange? httpServerExchange) {
            endpoint.service(request, response);
            response.responseDone();
            endExchange(httpServerExchange);
        }
    }

    """Returns endpoints matching method. If method is not defined on endpoint it accepts all methods."""
    {HttpEndpoint*} filterSupportedMethod({HttpEndpoint*} endpoints, Method method) {
        return endpoints.filter((endpoint) {
            if (endpoint.acceptMethod.size > 0) {
                return endpoint.acceptMethod.contains(method);
            } else {
                return true;
            }
        });
    }

    {HttpEndpoint*} filterHttpEndpoints({EndpointBase*} endpoints) {
        value httpEndpoints = LinkedList<HttpEndpoint>();
        for (EndpointBase endoint in endpoints) {
            if (is HttpEndpoint endoint) {
                httpEndpoints.add(endoint);
            }
        }
        return httpEndpoints;
    }

    {Method*} getAllAcceptedMethods({HttpEndpoint*} endpoints) {
        value acceptedMethods = LinkedList<Method>();
        for (HttpEndpoint endoint in endpoints) {
            acceptedMethods.addAll(endoint.acceptMethod);
        }
        return acceptedMethods;
    }

    void endExchange(JHttpServerExchange? httpServerExchange) {
        if (exists httpServerExchange) {
            httpServerExchange.endExchange();
        } else {
            throw InternalException("HttpExchange shoud not be null!");
        }
    }
}
