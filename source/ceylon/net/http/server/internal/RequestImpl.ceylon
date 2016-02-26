import ceylon.collection {
    HashMap,
    ArrayList
}
import ceylon.file {
    parsePath
}
import ceylon.interop.java {
    javaByteArray,
    toByteArray
}
import ceylon.io {
    SocketAddress
}
import ceylon.net.http {
    Method,
    contentTypeMultipartFormData
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
        smAttachmentKey=\iATTACHMENT_KEY
    },
    UtSession=Session,
    SessionCookieConfig
}
import io.undertow.util {
    Headers {
        headerConntentType=\iCONTENT_TYPE
    },
    HttpString
}

import java.io {
    BufferedReader,
    InputStreamReader,
    ByteArrayOutputStream
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

    String? getHeader(String name) 
            => exchange.requestHeaders.getFirst(HttpString(name));

    contentType => getHeader(headerConntentType.string);

    header(String name) => getHeader(name);
    
    shared actual String read() {
        exchange.startBlocking();
        value inputStream = exchange.inputStream;
        try {
            value inputStreamReader = 
                    InputStreamReader(inputStream, 
                        exchange.requestCharset);
            value reader = BufferedReader(inputStreamReader);
            value builder = StringBuilder();
            while (exists line = reader.readLine()) {
                builder.append(line).appendNewline();
            }
            return builder.string;
        }
        finally {
            inputStream.close();
        }
    }

    shared actual Byte[] readBinary() {
        exchange.startBlocking();
        value inputStream = exchange.inputStream;
        try {
            value buf = javaByteArray(Array<Byte>.ofSize(4096, Byte(0)));
            value byteArrayOutputStream = ByteArrayOutputStream();
            variable Integer n;
            while ((n = inputStream.read(buf)) >= 0) {
                byteArrayOutputStream.write(buf, 0, n);
            }
            value x = byteArrayOutputStream.toByteArray();
            // FIXME not good: this copies the final content a second time!
            return toByteArray(x).sequence();
        }
        finally {
            inputStream.close();
        }
    }

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
        // multipart/form-data parsing requires blocking mode
        String? contentType = exchange.requestHeaders.getFirst(HttpString(headerConntentType.string));
        if (is String contentType) {
            if (contentType.startsWith(contentTypeMultipartFormData)) {
                exchange.startBlocking();
            }
        }
        
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
    value queryParametersMap => lazyQueryParameters 
            else (lazyQueryParameters = readQueryParameters());

    variable FormData? lazyFormData = null;
    value formData => lazyFormData 
            else (lazyFormData = buildFormData()) ;

    shared actual String[] formParameters(String name)
        => if (exists params = formData.parameters[name])
            then params else [];

    shared actual String? formParameter(String name)
        => if (nonempty params = formData.parameters[name])
            then params.first else null;

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

	deprecated("Not specifying if the parameter's values should come from the query part
	            in the URL or from the request body is discouraged at this level.
	            Please use either [[queryParametersMap]] or [[formParameters]].")
    shared actual String[] parameters(String name, 
            Boolean forceFormParse) {

        value mergedParams = ArrayList<String>();
        if (queryParametersMap.keys.contains(name)) {
            if (exists params = queryParametersMap[name]) {
                if (forceFormParse || initialized(lazyFormData)) {
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

    deprecated("Not specifying if the parameter's values should come from the query part
                in the URL or from the request body is discouraged at this level.
                Please use either [[queryParameters]] or [[formParameters]].")
    shared actual String? parameter(String name, 
            Boolean forceFormParsing) {
        value params = parameters(name);
        if (nonempty params) {
            return params.first;
        } else {
            return null;
        }
    }
    
    shared  actual String[] queryParameters(String name)
        => if (exists params = queryParametersMap[name])
        	then params else [];
    
    shared  actual String? queryParameter(String name)
        => if (nonempty params = queryParametersMap[name])
             then params.first else null;

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
