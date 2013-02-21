import ceylon.collection { HashMap }
import ceylon.io { SocketAddress }
import ceylon.net.httpd { Request, Session, Endpoint, 
                          InternalException, AsynchronousEndpoint }

import io.undertow.server { HttpServerExchange }
import io.undertow.server.handlers.form { 
        FormEncodedDataHandler { applicationXWwwFormUrlEncoded=APPLICATION_X_WWW_FORM_URLENCODED }, 
        MultiPartHandler { multiparFormData=MULTIPART_FORM_DATA }, 
        FormDataParser { fdpAttachmentKey=ATTACHMENT_KEY }, FormData }
import io.undertow.server.session { 
        SessionManager { smAttachmentKey=ATTACHMENT_KEY }, 
        UtSession=Session, SessionCookieConfig }
import io.undertow.util { Headers { headerConntentType=CONTENT_TYPE }, HttpString }

import java.lang { JString=String }
import java.util { Deque, JMap=Map }

import org.xnio { IoFuture }

by "Matej Lazar"
shared class HttpRequestImpl(HttpServerExchange exchange) satisfies Request {
    
    variable Endpoint|AsynchronousEndpoint|Null endpoint = null;
    
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
    
    
    shared actual String uri => exchange.requestURI;
    
    shared actual String path => exchange.requestPath;
    
    shared actual String relativePath {
        String requestPath = path;
        if (exists e = endpoint) {
            String mappingPath;
            
            switch(e)
            case(is Endpoint) {
                mappingPath = e.path;
            }
            case (is AsynchronousEndpoint) {
                mappingPath = e.path;
            }
            
            return requestPath[mappingPath.size...];
        }
        return requestPath;
    }
    
    shared actual SocketAddress destinationAddress {
        value address = exchange.destinationAddress;
        return SocketAddress(address.hostString, address.port);
    }
    
    shared actual String method => exchange.requestMethod.string;
    
    shared actual String queryString => exchange.queryString;
    
    shared actual String scheme => exchange.requestScheme;
    
    shared void webEndpoint(Endpoint|AsynchronousEndpoint webEndpoint) {
        endpoint = webEndpoint;
    }
    
    shared actual SocketAddress sourceAddress {
        value address = exchange.sourceAddress;
        return SocketAddress(address.hostString, address.port);
    }
    
    shared actual String? mimeType => header(headerConntentType.string);
    
    shared actual Session session {
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
            String? mimeType = this.mimeType;
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

