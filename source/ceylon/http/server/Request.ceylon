/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
import ceylon.io {
    SocketAddress
}
import ceylon.http.common {
    Method
}
import ceylon.locale {
    Locale
}

"Defines an object to provide client request information 
 to a web endpoint."
by("Matej Lazar")
shared interface Request {
    
    "Returns a single parameters with given name. If there 
     are more, the first one is returned. If 
     [[forceFormParsing]] is false (default) and parameter 
     with the same name exists in a query string, posted 
     data is not parsed."
    deprecated("Not specifying if the parameter's value should come from the query part
                in the URL or from the request body is discouraged at this level.
                Please use either [[queryParameter]] or [[formParameter]].")
    shared formal String? parameter(String name, 
        Boolean forceFormParsing = false);
    
    "Returns all parameters with given name. If 
     [[forceFormParsing]] is false (default) and parameter 
     with the same name exists in a query string, posted 
     data is not parsed. It is returned, only if it is 
     already parsed."
    deprecated("Not specifying if the parameter's values should come from the query part
                in the URL or from the request body is discouraged at this level.
                Please use either [[queryParameters]] or [[formParameters]].")
    shared formal String[] parameters(String name, 
        Boolean forceFormParsing = false);

    shared formal UploadedFile? file(String name);

    shared formal UploadedFile[] files(String name);
    
    "Returns a single header with given name."
    shared formal String? header(String name);
    
    "Returns all headers with given name."
    shared formal String[] headers(String name);

	"Returns a single query parameter with the given name (from the query part of the request URL)."
    shared formal String? queryParameter(String name);

	"Returns all single query parameter with the given name (from the query part of the request URL)."
    shared formal String[] queryParameters(String name);

    "Returns a single form parameter with the given name from the request body. Content-Type must be application/x-www-form-urlencoded."
    shared formal String? formParameter(String name);

    "Returns all form parameters with the given name from the request body. Content-Type must be application/x-www-form-urlencoded."
    shared formal String[] formParameters(String name);

    "Get the HTTP request method.
     {OPTIONS, GET, HEAD, POST, PUT, DELETE, TRACE, CONNECT}"
    shared formal Method method;

    "Returns the request charset. If none was explicitly specified it will return
     *ISO-8859-1*, which is the default charset for HTTP requests."
    shared formal String requestCharset;

    "Get the request URI scheme. {http, https}"
    shared formal String scheme;
    
    "Gets the request URI, including hostname, protocol
     etc if specified by the client."
    shared formal String uri;
    
    "Get the request URI path.  This is the whole original
     request path."
    shared formal String path;

    "Get the matched template path when using a TemplateEndpoint."
    shared formal String? matchedTemplate;

    "Get a path parameter corresponding to a path component
     in curly braces when using a TemplateEndpoint."
    shared formal String? pathParameter(String name);

    "Read the contents of the request as text."
    shared formal String read();

    "Read the contents of the request as binary byte array."
    shared formal Byte[] readBinary();

    "Return path relative to endpoint mapping path.
     Relative path is a substring of path without
     [[startsWith]] mappings.
    
     Note that endpoints mapped with [[And]] and [[endsWith]] 
     will return complete path instead of relative. See 
     [[Matcher.relativePath]] for details."
    shared formal String relativePath;
    
    shared formal String queryString;
    
    "Get the source address of the HTTP request."
    shared formal SocketAddress sourceAddress;
    
    "Get the destination address of the HTTP request."
    shared formal SocketAddress destinationAddress;
    
    "Returns request content type, read from header."
    shared formal String? contentType;
    
    "Returns the preferred [[Locale]] that the client
     accepts content in, based on the Accept-Language header.
     If the client request doesn't provide an Accept-Language header,
     this method returns the default locale for the server."
    shared formal Locale locale;
    
    "Returns sequence of [[Locale]] objects indicating,
     in decreasing order starting with the preferred locale, the locales
     that are acceptable to the client based on the Accept-Language header.
     If the client request doesn't provide an Accept-Language header,
     this method returns sequence containing one [[Locale]],
     the default locale for the server."
    shared formal [Locale+] locales;
    
    "Returns users http session. If session doesn't exists, 
     a new is created."
    shared formal Session session;

}
