import ceylon.net.httpd { HttpRequest, HttpSession, WebEndpointConfig }
import io.undertow.server { HttpServerExchange }
import java.util { Deque, JMap = Map }
import java.lang { JString = String }
import ceylon.io { SocketAddress }
import io.undertow.util { Headers { headerConntentType = \iCONTENT_TYPE}}
import io.undertow.server.handlers.form {
	FormEncodedDataHandler {applicationXWwwFormUrlEncoded = \iAPPLICATION_X_WWW_FORM_URLENCODED}, 
	MultiPartHandler {multiparFormData = \iMULTIPART_FORM_DATA},
	FormDataParser {fdpAttachmentKey = \iATTACHMENT_KEY}, 
	FormData 
}
import io.undertow.server.handlers {
	Cookie { utRequestCookies = getRequestCookies , utResponseCookies = getResponseCookies }
}

import io.undertow.server.session { 
	SessionManager {smAttachmentKey = \iATTACHMENT_KEY}, 
	UtSession = Session,
	SessionCookieConfig { defaultSessionCookieName = \iDEFAULT_SESSION_ID }
}
import ceylon.collection { HashMap }
import org.xnio { IoFuture }

shared class HttpRequestImpl(HttpServerExchange exchange) satisfies HttpRequest {
	
	variable WebEndpointConfig? endpointConfig := null;
	
	HashMap<String, String[]> parametersMap = HashMap<String, String[]>(); 
	variable FormData? formData := null;
								
	shared actual String? header(String name) {
		return exchange.requestHeaders.getFirst(name);
	}

	shared actual String[] headers(String name) {
		Deque<JString> headers = exchange.requestHeaders.get(name);
		SequenceBuilder<String> sequenceBuilder = SequenceBuilder<String>();

		value it = headers.iterator();
		while (exists header = it.next()) {
			sequenceBuilder.append(header.string);
		}
		
		return sequenceBuilder.sequence;
	}

	shared actual String? parameter(String name) {
		value params = parameters(name);
		if (nonempty params) {
			return params.first;
		} else {
			return null;
		}
	}

	shared actual String[]|Empty parameters(String name) {
		
		if (parametersMap.contains(name)) {
			if (exists params = parametersMap.item(name)) {
				return params;
			}
		}
		
		SequenceBuilder<String> sequenceBuilder = SequenceBuilder<String>();
		value paramName = JString(name);
		JMap<JString,Deque<JString>> qp = exchange.queryParameters;
			
		if (qp.containsKey(paramName)) {
			Deque<JString> params = qp.get(paramName);
			value it = params.iterator();
			while (it.hasNext()) {
				value param = it.next(); 
				sequenceBuilder.append(param.string);
			}
		}
		
		addPostValues(sequenceBuilder, name);
		value params = sequenceBuilder.sequence;
		parametersMap.put(name, params);
		return params;
	}

	shared actual String uri() {
		return exchange.requestURI;
	}
	
	shared actual String path() {
		return exchange.requestPath;
	}
	
	shared actual String relativePath() {
		String requestPath = path();
		if (exists e = endpointConfig) {
			//TODO path could be regex
			String mappingPath = e.path;
			return requestPath[mappingPath.size .. (requestPath.size - 1 )];
		}
		return requestPath;
	}
	
	shared actual SocketAddress destinationAddress() {
		value address = exchange.destinationAddress;
		return SocketAddress(address.hostString, address.port);
	}
	
	shared actual String method() {
		return exchange.requestMethod;
	}
	
	shared actual String queryString() {
		return exchange.queryString;
	}
	
	shared actual String scheme() {
		return exchange.requestScheme;
	}
	
	shared void webEndpointConfig(WebEndpointConfig webEndpointConfig) {
		endpointConfig := webEndpointConfig;
	}
	
	shared actual SocketAddress sourceAddress() {
		value address = exchange.sourceAddress;
		return SocketAddress(address.hostString, address.port);
	}

	shared actual String? mimeType() {
		return header(headerConntentType);
	}

	shared actual HttpSession session() {
		variable UtSession? utSession := null;
		SessionManager sessionManager = exchange.getAttachment(smAttachmentKey);
   		if (exists String sessionId = findSessionId()) {
   			IoFuture<UtSession> sessionFuture = sessionManager.getSession(exchange, sessionId);
	   		utSession := sessionFuture.get();
   		}

		if (!exists utSession) {
			IoFuture<UtSession> sessionFuture = sessionManager.createSession(exchange);
	   		utSession := sessionFuture.get();
		}
		
   		if (exists u = utSession) {
   			return DefaultHttpSession(u);
   		}
   		
   		//TODO narrow exception
   		throw Exception("Cannot get or create session.");
	}

	void addPostValues(SequenceBuilder<String> sequenceBuilder, String paramName) {
		if (exists formData = parseFormData()) {
			if (formData.contains(paramName)) {
				Deque<FormData.FormValue> params = formData.get(paramName);
				value it = params.iterator();
				while (it.hasNext()) {
					FormData.FormValue param = it.next(); 
					String? fileName = param.fileName;
					if (exists fileName) {
						//TODO handle uploaded file	
					} else {
						sequenceBuilder.append(param.\ivalue);
					}
				}
			}
		}
	}

	FormData? parseFormData() {
		if (exists f = formData) {
			return f;
		} else { 
			String? mimeType = this.mimeType();
	       	if (exists mimeType) {
	       		//TODO use equals instead of startsWith (workaround for parsing bug)
	       		if (mimeType.equals(applicationXWwwFormUrlEncoded) || mimeType.startsWith(multiparFormData)) {
	        		FormDataParser formDataParser = exchange.getAttachment(fdpAttachmentKey);
	        		//is EagerFormParsingHandler is in chanin, parsing is already done
	        		formData := formDataParser.parseBlocking();
	       		}
	    	} 
	    	//If not parsable construct empty
	    	if (!exists formData) {
	    		formData := FormData();
	    	}
		}
    	return formData;
	}
	
	String? findSessionId() {
        JMap<JString, Cookie>? cookies = utRequestCookies(exchange);
        if(exists cookies) {
            Cookie? sessionId = cookies.get(JString(defaultSessionCookieName));
            if(exists sessionId) {
                return sessionId.\ivalue;
            }
        }
        return null;
    }
	
}