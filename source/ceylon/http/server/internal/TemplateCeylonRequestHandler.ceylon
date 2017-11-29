/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
import ceylon.http.common {
	Method,
	parseMethod
}
import ceylon.http.server {
	Options,
	InternalException,
	Request,
	Endpoint,
	TemplateMatcher,
    HttpEndpoint,
    AsynchronousEndpoint
}

import io.undertow.server {
	HttpHandler,
	JHttpServerExchange=HttpServerExchange
}
import io.undertow.server.handlers.form {
	FormParserFactory {
		formParserFactoryBuilder=builder
	}
}
import io.undertow.util {
	PathTemplateMatch
}

import java.lang {
	JString=String
}
import java.util {
	JMap=Map
}

class TemplateCeylonRequestHandler(Options options, HttpEndpoint endpoint)
         satisfies HttpHandler {

	assert (is TemplateMatcher templateMatcher = endpoint.path);
	
    value formParserFactory 
            = formParserFactoryBuilder().build();

    shared actual void handleRequest(JHttpServerExchange? exchange) {
        if (exists exc = exchange) {
            ResponseImpl response = 
                    ResponseImpl(exc, options.defaultCharset);
            try {
                String requestPath = exc.requestPath;
                Method method = parseMethod(exc.requestMethod.string.uppercased);
                
                // if method matches {
                // TODO check method
                value jParams = exc.getAttachment(PathTemplateMatch.attachmentKey).parameters;
                RequestImpl request = RequestImpl { 
                    exchange = exc; 
                    formParserFactory = formParserFactory;
                    endpoint = endpoint;
                    path = requestPath;
                    matchedTemplate = exc.getAttachment(PathTemplateMatch.attachmentKey).matchedTemplate;
                    pathParameters = makeCeylonStringMap(jParams);
                    method = method;
                };
                invokeEndpoint(endpoint, request, response, exc);
                /*
                 } else { // method does not match
                 {Method*} acceptedMethods = getAllAcceptedMethods(httpEndpoints);
                 response.addHeader(allow(acceptedMethods));
                 endResponse(exc, response, 405);
                 }*/
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

    //TODO: use CeylonStringMap in ceylon.interop.java?
    Map<String, String> makeCeylonStringMap(JMap<JString, JString> jMap)
            => map {
                for (jEntry in jMap.entrySet())
                jEntry.key.string -> jEntry.\ivalue.string
            };

    void invokeEndpoint(HttpEndpoint endpoint, 
        Request request, ResponseImpl response, 
        JHttpServerExchange exchange ) {

        value invoker = if (is Endpoint endpoint) 
        then SynchronousInvoker(endpoint, request, response)
        else AsynchronousInvoker(endpoint, request, response);

        exchange.dispatch(invoker);
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
    
    class AsynchronousInvoker(AsynchronousEndpoint endpoint, 
        Request request, ResponseImpl response) 
            satisfies HttpHandler {
        
        shared actual void handleRequest(JHttpServerExchange? httpServerExchange) {
            endpoint.service(request, response, () {
                response.responseDone();
                endExchange(httpServerExchange);
            });
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