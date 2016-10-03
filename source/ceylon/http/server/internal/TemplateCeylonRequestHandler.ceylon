import ceylon.interop.java {
	CeylonSet
}
import ceylon.http.common {
	Method,
	parseMethod
}
import ceylon.http.server {
	Options,
	InternalException,
	Request,
	Endpoint,
	TemplateMatcher
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

class TemplateCeylonRequestHandler(Options options, Endpoint endpoint)
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

    Map<String, String> makeCeylonStringMap(JMap<JString, JString> jMap)
    {
        value cEntries = CeylonSet(jMap.entrySet()).map(
            (JMap<out Object, out Object>.Entry<JString, JString> jEntry)
                    => jEntry.key.string -> jEntry.\ivalue.string
        );
        return map(cEntries);
        
    }

    void invokeEndpoint(Endpoint endpoint, 
        Request request, ResponseImpl response, 
        JHttpServerExchange exchange ) {

        exchange.dispatch(SynchronousInvoker(endpoint, 
                request, response));
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
    
    void endExchange(JHttpServerExchange? httpServerExchange) {
        if (exists httpServerExchange) {
            httpServerExchange.endExchange();
        } else {
            throw InternalException("HttpExchange shoud not be null!");
        }
    }
}