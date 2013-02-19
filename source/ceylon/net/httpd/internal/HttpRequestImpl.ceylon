import ceylon.net.httpd { HttpRequest, HttpSession, WebEndpoint, InternalException, WebEndpointAsync }
import io.undertow.server { HttpServerExchange }
import java.util { Deque, JMap = Map }
import java.lang { JString = String }
import ceylon.io { SocketAddress }
import io.undertow.util { Headers { headerConntentType = \iCONTENT_TYPE}, HttpString}
import io.undertow.server.handlers.form {
    FormEncodedDataHandler {applicationXWwwFormUrlEncoded = \iAPPLICATION_X_WWW_FORM_URLENCODED}, 
    MultiPartHandler {multiparFormData = \iMULTIPART_FORM_DATA},
    FormDataParser {fdpAttachmentKey = \iATTACHMENT_KEY}, 
    FormData 
}
import io.undertow.server.session { 
    SessionManager {smAttachmentKey = \iATTACHMENT_KEY}, 
    UtSession = Session, SessionCookieConfig
}
import ceylon.collection { HashMap }
import org.xnio { IoFuture }

by "Matej Lazar"
shared class HttpRequestImpl(HttpServerExchange exchange) satisfies HttpRequest {
    
    variable WebEndpoint|WebEndpointAsync|Null endpoint = null;
    
    HashMap<String, String[]> parametersMap = HashMap<String, String[]>(); 
    variable FormData? formData = null;
    
    shared actual String? header(String name) {
        return exchange.requestHeaders.getFirst(HttpString(name));
    }
    
    shared actual String[] headers(String name) {
        Deque<JString> headers = exchange.requestHeaders.get(HttpString(name));
        SequenceBuilder<String> sequenceBuilder = SequenceBuilder<String>();
        
        value it = headers.iterator();
        while (exists header = it.next()) {
            sequenceBuilder.append(header.string);
        }
        
        return sequenceBuilder.sequence;
    }
    
    shared actual String[] parameters(String name) {
        
        if (parametersMap.contains(name)) {
            if (exists params = parametersMap.get(name)) {
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
    
    shared actual String? parameter(String name) {
        value params = parameters(name);
        if (nonempty params) {
            return params.first;
        } else {
            return null;
        }
    }
    
    
    shared actual String uri() {
        return exchange.requestURI;
    }
    
    shared actual String path() {
        return exchange.requestPath;
    }
    
    shared actual String relativePath() {
        String requestPath = path();
        if (exists e = endpoint) {
            String mappingPath;
            
            switch(e)
            case(is WebEndpoint) {
                mappingPath = e.getPath();
            }
            case (is WebEndpointAsync) {
                mappingPath = e.getPath();
            }
            
            return requestPath[mappingPath.size .. (requestPath.size - 1 )];
        }
        return requestPath;
    }
    
    shared actual SocketAddress destinationAddress() {
        value address = exchange.destinationAddress;
        return SocketAddress(address.hostString, address.port);
    }
    
    shared actual String method() {
        return exchange.requestMethod.string;
    }
    
    shared actual String queryString() {
        return exchange.queryString;
    }
    
    shared actual String scheme() {
        return exchange.requestScheme;
    }

    shared void webEndpoint(WebEndpoint|WebEndpointAsync webEndpoint) {
        endpoint = webEndpoint;
    }
    
    shared actual SocketAddress sourceAddress() {
        value address = exchange.sourceAddress;
        return SocketAddress(address.hostString, address.port);
    }
    
    shared actual String? mimeType() {
        return header(headerConntentType.string);
    }
    
    shared actual HttpSession session() {
    	variable UtSession? utSession = null;
        SessionManager sessionManager = exchange.getAttachment(smAttachmentKey);
        
        //TODO configurable session cookie
        SessionCookieConfig sessionCookieConfig = SessionCookieConfig();
        
        IoFuture<UtSession> sessionFuture = sessionManager.getSession(exchange, sessionCookieConfig);
        utSession = sessionFuture.get();
        
        if (!utSession exists) {
            IoFuture<UtSession> sessionFutureNew = sessionManager.createSession(exchange, sessionCookieConfig);
            utSession = sessionFutureNew.get();
        }
        
        if (exists u = utSession) {
            return DefaultHttpSession(u);
        } else {
            throw InternalException("Cannot get or create session.");
        }
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
                    //is EagerFormParsingHandler is in chain, parsing is already done
                    formData = formDataParser.parseBlocking();
                }
            } 
            //If it is not parsable, construct empty
            if (!formData exists) {
                formData = FormData();
            }
        }
        return formData;
    }
}

