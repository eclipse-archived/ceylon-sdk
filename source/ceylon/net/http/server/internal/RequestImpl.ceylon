import ceylon.collection {
    HashMap,
    ArrayList
}
import ceylon.file {
    parsePath
}
import ceylon.io {
    SocketAddress
}
import ceylon.net.http {
    Method
}
import ceylon.net.http.server {
    Request,
    Session,
    InternalException,
    HttpEndpoint,
    UploadedFile
}
import ceylon.net.http.server.internal {
    JavaHelper {
        paramIsFile,
        paramFile,
        paramValue
    }
}

import io.undertow.server {
    HttpServerExchange
}
import io.undertow.server.handlers.form {
    UtFormData=FormData,
    FormParserFactory
}
import io.undertow.server.session {
    SessionManager {
        smAttachmentKey=ATTACHMENT_KEY
    },
    UtSession=Session,
    SessionCookieConfig
}
import io.undertow.util {
    Headers {
        headerConntentType=CONTENT_TYPE
    },
    HttpString
}

import java.lang {
    JString=String
}

by("Matej Lazar")
class RequestImpl(HttpServerExchange exchange, 
    FormParserFactory formParserFactory, endpoint, path, method)
        satisfies Request {

    shared HttpEndpoint endpoint;

    shared actual String path;

    shared actual Method method;

    UtFormData getUtFormData() {
        if (exists fdp = formParserFactory.createParser(exchange)) {
            return fdp.parseBlocking();
            //TODO ASYNC parsing for async endpoint formData = fdp.parse(nextHandler);
        } else {
            //If no parser exists for requeste content-type, construct empty form data
            return UtFormData(1);
        }
    }

    FormData buildFormData() {
        value formDataBuilder = FormDataBuilder();
        
        value utFormData = getUtFormData();
        
        value formDataIt = utFormData.iterator();
        while (formDataIt.hasNext()) {
            JString key = formDataIt.next(); 
            value valuesIt = utFormData.get(key.string).iterator();
            while (valuesIt.hasNext()) {
                value parameterValue = valuesIt.next();
                if (paramIsFile(parameterValue)) {
                    value uploadedFile = UploadedFile { 
                        file = parsePath(paramFile(parameterValue).absolutePath);
                        fileName = parameterValue.fileName;
                    };
                    formDataBuilder.addFile(key.string, uploadedFile);
                } else {
                    formDataBuilder.addParameter(key.string, 
                        paramValue(parameterValue));
                }
            }
        }
        return formDataBuilder.build();
    }
    
    Map<String, String[]> readQueryParameters() {
        value queryParameters = HashMap<String, String[]>();
        value utQueryParameters = exchange.queryParameters;
        
        value it = utQueryParameters.keySet().iterator();
        while (it.hasNext()) {
            JString key = it.next();
            value values = utQueryParameters.get(key); 
            value valuesIt = values.iterator();
            value sequenceBuilder = ArrayList<String>();
            while (valuesIt.hasNext()) {
                value paramValue = valuesIt.next(); 
                sequenceBuilder.add(paramValue.string);
            }
            queryParameters.put(key.string, sequenceBuilder.sequence());
        }
        return queryParameters;
    }

    variable Map<String, String[]>? lazyQueryParameters = null;
    value queryParameters => lazyQueryParameters 
            else (lazyQueryParameters = readQueryParameters());

    variable FormData? lazyFormData = null;
    value formData => lazyFormData 
            else (lazyFormData = buildFormData()) ;

    shared actual String[] headers(String name) {
        value headers = exchange.requestHeaders.get(HttpString(name));
        value sequenceBuilder = ArrayList<String>();
        
        value it = headers.iterator();
        while (it.hasNext()) {
            value header = it.next();
            sequenceBuilder.add(header.string);
        }
        
        return sequenceBuilder.sequence();
    }

    shared actual String[] parameters(String name, 
            Boolean forseFormParse) {

        value mergedParams = ArrayList<String>();
        if (queryParameters.keys.contains(name)) {
            if (exists params = queryParameters[name]) {
                if (forseFormParse || initialized(lazyFormData)) {
                    mergedParams.addAll(params);
                } else {
                    return params;
                }
            }
        }

        if (exists posted = formData.parameters[name]) {
            mergedParams.addAll(posted);
        }
        return mergedParams.sequence();
    }

    shared actual String? parameter(String name, 
            Boolean forceFormParsing) {
        value params = parameters(name);
        if (nonempty params) {
            return params.first;
        } else {
            return null;
        }
    }

    shared actual UploadedFile[] files(String name) {
        if (exists files = formData.files[name]) {
            return files;
        }
        return [];
    }

    shared actual UploadedFile? file(String name) {
        UploadedFile[] uploadedFiles = files(name);
        if (nonempty uploadedFiles) {
            return uploadedFiles.first;
        } else {
            return null;
        }
    }

    uri => exchange.requestURI;

    relativePath => endpoint.path.relativePath(path);

    queryString => exchange.queryString;

    scheme => exchange.requestScheme;

    contentType => getHeader(headerConntentType.string);
    
    header(String name) => getHeader(name);
    
    String? getHeader(String name) 
            => exchange.requestHeaders.getFirst(HttpString(name));
    
    shared actual SocketAddress sourceAddress {
        value address = exchange.sourceAddress;
        return SocketAddress(address.hostString, address.port);
    }

    shared actual SocketAddress destinationAddress {
        value address = exchange.destinationAddress;
        return SocketAddress(address.hostString, address.port);
    }
    
    shared actual Session session {
        SessionManager sessionManager 
                = exchange.getAttachment(smAttachmentKey);

        //TODO configurable session cookie
        value sessionCookieConfig = SessionCookieConfig();

        variable UtSession? utSession = 
                sessionManager.getSession(exchange, sessionCookieConfig);

        if (!utSession exists) {
            utSession = sessionManager.createSession(exchange, sessionCookieConfig);
        }

        if (exists s = utSession) {
            return DefaultSession(s);
        } else {
            throw InternalException("Cannot get or create session.");
        }
    }

    Boolean initialized(Object? obj) { 
        if (exists obj) {
            return true;
        }
        return false;
    }
}
