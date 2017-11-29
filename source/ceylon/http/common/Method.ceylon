/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
"Http request method"
by ("Jean-Charles Roger", "Matej Lazar")
shared interface Method {
    shared default actual Boolean equals(Object that) 
            => methodEquals(this, that);
    
    shared default actual Integer hash
            => string.hash;
}

Boolean methodEquals(Object thisObject, Object that) {
    if (is Method that) {
        return that.string.equals(thisObject.string);
    } else {
        return false;
    }
}

shared abstract class AbstractMethod()
    of options | get | head | post | put | delete | trace | connect 
    satisfies Method {

    shared actual Boolean equals(Object that) 
            => methodEquals(this, that);
    shared actual Integer hash => string.hash;
}

shared object options 
        extends AbstractMethod() {
    string => "OPTIONS";
}

shared object get 
        extends AbstractMethod() {
    string => "GET";
}

shared object head 
        extends AbstractMethod() {
    string => "HEAD";
}

shared object post 
        extends AbstractMethod() {
    string => "POST";
}

shared object put 
        extends AbstractMethod() {
    string => "PUT";
}

shared object delete 
        extends AbstractMethod() {
    string => "DELETE";
}

shared object trace 
        extends AbstractMethod() {
    string => "TRACE";
}

shared object connect 
        extends AbstractMethod() {
    string => "CONNECT";
}

"Parse a method string to Method instance"
shared Method parseMethod(String method) {
    
    if ( method == options.string ) {
        return options;
    } else if ( method == get.string ) {
        return get;
    } else if ( method == head.string ) {
        return head;
    } else if ( method == post.string ) {
        return post;
    } else if ( method == put.string ) {
        return put;
    } else if ( method == delete.string ) {
        return delete;
    } else if ( method == trace.string ) {
        return trace;
    } else if ( method == connect.string ) {
        return connect;
    } else {
        object m satisfies Method {
            shared actual String string = method.uppercased;
            shared actual Boolean equals(Object that) 
                    => methodEquals(this, that); 
            shared actual Integer hash => string.hash;
        }
        return m;
    }
}