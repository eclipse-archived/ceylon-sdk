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
    LinkedList,
    MutableList
}
import ceylon.buffer.charset {
    Charset
}

"Represents an HTTP Header"
by("Stéphane Épardaud")
shared class Header(name, String* initialValues) {
    
    "Header name"
    shared String name;
    
    "Header value"
    shared MutableList<String> values = LinkedList<String>();
    
    for(val in initialValues) {
        values.add(val);
    }
    
    shared actual String string =>
            "`` name ``: `` ",".join(values) ``";
}

shared Header contentType(String contentType, Charset? charset = null) {
    String headerValue;
    if (exists charset) {
        headerValue = "``contentType``; charset=``charset.name``";
    } else {
        headerValue = contentType;
    }
    return Header("Content-Type", headerValue);
}

shared Header contentLength(String contentLength) 
        => Header("Content-Length", contentLength);

Header allowHeaders({Method*} methods) {
    StringBuilder sb = StringBuilder();
    for (i -> method in methods.indexed) {
        if (i > 0) {
            sb.append(", ");
        }
        sb.append(method.string);
    }
    return Header("Allow", sb.string);
}
shared Header allow({Method*} methods = empty) 
        => allowHeaders(methods);

shared String contentTypeFormUrlEncoded 
        = "application/x-www-form-urlencoded";

shared String contentTypeMultipartFormData 
        = "multipart/form-data";
