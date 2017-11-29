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
    MutableList,
    LinkedList
}
import ceylon.io {
    newSocketConnector,
    SocketAddress,
    newSslSocketConnector
}
import ceylon.buffer.charset {
    ascii,
    Charset,
    utf8
}
import ceylon.http.common {
    Header,
    contentType,
    contentTypeFormUrlEncoded,
    contentLength,
    get,
    Method,
    post
}
import ceylon.uri {
    Uri,
    Parameter
}
import ceylon.buffer {
    ByteBuffer
}

"Represents an HTTP Request"
by ("Stéphane Épardaud", "Matej Lazar", "Alex Szczuczko")
shared class Request(uri,
    method = get,
    data = null,
    dataContentType = "application/octet-stream",
    bodyCharset = utf8,
    initialParameters = empty,
    initialHeaders = empty) {
    
    // constant
    String crLf = "\r\n";
    
    "The initial values for [[parameters]]"
    {Parameter*} initialParameters;
    
    "The initial values for [[headers]]"
    {Header*} initialHeaders;
    
    "This request URI, must be absolute."
    shared Uri uri;
    
    "Data of type [[dataContentType]] to include in the request body. Usually
     this is [[null]] for idempotent methods (GET, HEAD, etc.), but it does not
     have to be.
     
     If [[parameters]] is not empty, and [[method]] is [[post]], then the
     parameters will be used instead of this value. String values will be
     encoded with [[bodyCharset]]."
    // TODO a use case for the future serialisation API?
    shared variable ByteBuffer|String? data;
    
    "Content-Type (MIME) value for [[data]]. As with [[data]], if
     [[parameters]] is not empty, and [[method]] is [[post]], then this will
     not be used ([[contentTypeFormUrlEncoded]] will be used instead)."
    shared variable String dataContentType;
    
    "Charset to use when encoding the the request body. This will not be used
     if [[data]] is selected as the body, and it is a [[ByteBuffer]]."
    shared variable Charset bodyCharset;
    
    "The list of request parameters. Initialised by [[initialParameters]]."
    shared MutableList<Parameter> parameters = LinkedList<Parameter>(initialParameters);
    
    "The list of request headers. Initialised by [[initialHeaders]]."
    shared MutableList<Header> headers = LinkedList<Header>(initialHeaders);
    
    "The request method, such as `GET`, `POST`…"
    shared variable Method method;
    
    "The port to connect to. Defaults to 80 for `http` Uris and to 443 for `https` uris, unless
     overridden in the [[uri]]."
    shared variable Integer port = 80;
    
    "Set to true to use SSL. Defaults to true for port 443."
    shared variable Boolean ssl = false;
    
    if (uri.relative) {
        throw Exception("Can't request a relative URI");
    }
    if (exists String scheme = uri.scheme) {
        if (scheme != "http"
                    && scheme != "https") {
            throw Exception("Only HTTP and HTTPS schemes are supported");
        }
        if (exists tmpPort = uri.authority.port) {
            port = tmpPort;
        } else if (scheme == "http") {
            port = 80;
        } else if (scheme == "https") {
            port = 443;
            ssl = true;
        }
    } else {
        throw Exception("Missing URI scheme");
    }
    
    "The host to connect to. Extracted from the specified [[uri]]."
    shared String host;
    if (exists tmpHost = uri.authority.host) {
        host = tmpHost;
    } else {
        throw Exception("URI host is not set");
    }
    
    "Returns a sequence of request headers with [[names|Header.name]] equal to [[name]].
     The comparison is case insensitive."
    shared Header[]? getHeaders(String name) => headers.select((header) => header.name.lowercased.equals(name.lowercased));
    
    "Returns the first request header with [[name|Header.name]] equal to [[name]],
     if one exists. The comparison is case insensitive. Use [[getHeaders]] to
     find multiple items with the same name."
    shared Header? getHeader(String name) => headers.find((header) => header.name.lowercased.equals(name.lowercased));
    
    "Adds all [[values]] to the first request header with [[name|Header.name]]
     equal to [[name]], creating the header if it does not exist."
    shared void setHeader(String name, String* values) {
        if (exists header = getHeader(name)) {
            header.values.clear();
            header.values.addAll(values);
        } else {
            headers.add(Header(name, *values));
        }
    }
    
    // initial headers
    setHeader("Host", host);
    setHeader("Accept", "*/*");
    setHeader("User-Agent", "curl/7.21.6 (x86_64-pc-linux-gnu) libcurl/7.21.6 OpenSSL/1.0.0e zlib/1.2.3.4 libidn/1.22 librtmp/2.3");
    setHeader("Accept-Charset", "UTF-8");
    
    "Returns a sequence of parameters with [[names|Parameter.name]] equal to [[name]]."
    shared Parameter[] getParameters(String name) => parameters.select((parameter) => parameter.name.equals(name));
    
    "Returns the first parameter with [[name|Parameter.name]] equal to [[name]],
     if one exists. Use [[getParameters]] to find multiple items with the same name."
    shared Parameter? getParameter(String name) => parameters.find((parameter) => parameter.name.equals(name));
    
    "Adds [[parameter]] to [[parameters]]"
    shared void setParameter(Parameter parameter) {
        parameters.add(parameter);
    }
    
    String externalisableParameters => "&".join({ for (parameter in parameters) parameter.toRepresentation(false) });
    
    String prepareRequestPrefix(Integer bodySize, String? contentTypeValue) {
        value builder = StringBuilder();
        
        // method
        builder.append(method.string)
            .append(" ");
        
        // path
        String path = uri.pathPart;
        if (path.empty) {
            builder.append("/");
        } else {
            builder.append(path);
        }
        variable Boolean queryParamsAdded = false;
        if (exists query = uri.queryPart) {
            builder.append("?")
                .append(query);
            queryParamsAdded = true;
        }
        if (!parameters.empty && method == get) {
            if (!queryParamsAdded) {
                builder.append("?");
            } else {
                builder.append("&");
            }
            builder.append(externalisableParameters);
        }
        
        // version
        builder.append(" ")
            .append("HTTP/1.1")
            .append(crLf);
        
        // add content type header
        if (exists contentTypeValue, !getHeader("Content-Type") exists) {
            headers.add(contentType(contentTypeValue, bodyCharset));
        }
        
        // add length header
        if (bodySize != 0 && !getHeader("Content-Length") exists) {
            headers.add(contentLength(bodySize.string));
        }
        
        // headers
        for (header in headers) {
            for (val in header.values) {
                builder.append(header.name)
                    .append(": ")
                    .append(val)
                    .append(crLf);
            }
        }
        builder.append(crLf);
        
        // body encoded seperately
        
        return builder.string;
    }
    
    "Executes this request by connecting to the server and returns a [[Response]]."
    shared Response execute() {
        // prepare request body
        String? contentType;
        ByteBuffer requestBodyBuffer;
        if (!parameters.empty && method == post) {
            requestBodyBuffer = bodyCharset.encodeBuffer(externalisableParameters);
            contentType = contentTypeFormUrlEncoded;
        } else if (is String d = data) {
            requestBodyBuffer = bodyCharset.encodeBuffer(d);
            contentType = dataContentType;
        } else if (is ByteBuffer b = data) {
            requestBodyBuffer = b;
            contentType = dataContentType;
        } else {
            requestBodyBuffer = ByteBuffer.ofSize(0);
            contentType = null;
        }
        
        // prepare the request prefix
        String requestPrefix = prepareRequestPrefix(requestBodyBuffer.available, contentType);
        // convert to a byte buffer. Prefix must be ASCII.
        ByteBuffer requestPrefixBuffer = ascii.encodeBuffer(requestPrefix);
        
        // now open a socket to the host
        value socketAddress = SocketAddress(host, port);
        value connector = ssl then newSslSocketConnector(socketAddress)
                else newSocketConnector(socketAddress);
        value socket = connector.connect();
        
        // send the full request
        socket.writeFully(requestPrefixBuffer);
        socket.writeFully(requestBodyBuffer);
        
        // now parse the response
        return Parser(socket).parseResponse();
    }
}
