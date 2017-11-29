/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
import ceylon.collection {
    LinkedList
}
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
                {EndpointBase*} endpointsMatchingPath = endpoints.getEndpointMatchingPath(requestPath);
                
                if (endpointsMatchingPath.size > 0) {
                    Method method = parseMethod(exc.requestMethod.string.uppercased);
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
        case (AsynchronousEndpoint) {
            exchange.dispatch(AsyncInvoker(endpoint, 
                request, response));
        }
        case (Endpoint) {
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
    {HttpEndpoint*} filterSupportedMethod({HttpEndpoint*} endpoints, Method method)
            => endpoints.filter((endpoint)
                => if (endpoint.acceptMethod.size > 0)
                then method in endpoint.acceptMethod
                else true);

    {HttpEndpoint*} filterHttpEndpoints({EndpointBase*} endpoints)
            => LinkedList<HttpEndpoint> {
                for (endpoint in endpoints)
                if (is HttpEndpoint endpoint)
                endpoint
            };

    {Method*} getAllAcceptedMethods({HttpEndpoint*} endpoints)
            => LinkedList<Method> {
                for (endpoint in endpoints)
                for (method in endpoint.acceptMethod)
                method
            };

    void endExchange(JHttpServerExchange? httpServerExchange) {
        if (exists httpServerExchange) {
            httpServerExchange.endExchange();
        } else {
            throw InternalException("HttpExchange shoud not be null!");
        }
    }
}
