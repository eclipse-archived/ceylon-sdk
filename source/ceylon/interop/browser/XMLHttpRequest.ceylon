/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
import ceylon.interop.browser.dom {
    EventHandler,
    EventTarget,
    Document
}
import ceylon.interop.browser.internal {
    newXMLHttpRequestInternal
}

"Defines an API that provides scripted client functionality for
 transferring data between a client and a server.
 
 See [http://www.w3.org/TR/XMLHttpRequest/](http://www.w3.org/TR/XMLHttpRequest/)"
shared dynamic XMLHttpRequest satisfies XMLHttpRequestEventTarget {
    // event handler
    "Dispatched when the [[readyState]] attribute changes value, except
     when it changes to [[UNSENT]]."
    shared formal variable EventHandler? onreadystatechange;
    
    // states
    "The object has been constructed."
    shared formal Integer \iUNSENT;
    
    "The [[open]] method has been successfully invoked.
     During this state request headers can be set using [[setRequestHeader]]
     and the request can be made using the [[send]] method."
    shared formal Integer \iOPENED;
    
    "All redirects (if any) have been followed and all HTTP headers of the
     final response have been received. Several response members of the object
     are now available."
    shared formal Integer \iHEADERS_RECEIVED;
    
    "The response entity body is being received."
    shared formal Integer \iLOADING;
    
    "The data transfer has been completed or something went wrong during
     the transfer (e.g. infinite redirects)."
    shared formal Integer \iDONE;
    
    "Returns the current state."
    shared formal Integer readyState;
    
    // request
    "Sets the [[request method|method]], [[request URL|url]], and
     [[synchronous flag|async]]."
    shared formal void open(String method, String url,
        Boolean async = false, String? username = null, String? password = null);
    
    "Appends an header to the list of author request headers, or if header
     is already in the list of author request headers, combines its value
     with value."
    shared formal void setRequestHeader(String header, String val);
    
    "Can be set to a time in milliseconds. When set to a non-zero value
     will cause fetching to terminate after the given time has passed.
     When the time has passed, the request has not yet completed, and the
     synchronous flag is unset, a timeout event will then be dispatched,
     or a `TimeoutError` exception will be thrown otherwise
     (for the send() method)."
    shared formal variable Integer timeout;
    
    "True when user credentials are to be included in a cross-origin request.
     False when they are to be excluded in a cross-origin request and when
     cookies are to be ignored in its response. Initially false."
    shared formal variable Boolean withCredentials;
    
    "Returns the associated XMLHttpRequestUpload object. It can be used
     to gather transmission information when data is transferred to a server."
    shared formal XMLHttpRequestUpload upload;
    
    "Initiates the request. The optional argument provides the request
     entity body. The argument is ignored if request method is `GET` or `HEAD`."
    // TODO (ArrayBufferView or Blob or Document or [EnsureUTF16] DOMString or FormData)
    shared formal void send(String? data = null);
    
    "Cancels any network activity."
    shared formal void abort();
    
    // response
    "Returns the HTTP status code."
    shared formal Integer status;
    
    "Returns the HTTP status text."
    shared formal String statusText;
    
    "Returns the header field value from the response of which the field name
     matches header, unless the field name is `Set-Cookie` or `Set-Cookie2`."
    shared formal String? getResponseHeader(String header);
    
    "Returns all headers from the response, with the exception of those whose
     field name is `Set-Cookie` or `Set-Cookie2`."
    shared formal String getAllResponseHeaders();
    
    "Sets the `Content-Type` header for the response to mime."
    shared formal void overrideMimeType(String mime);
    
    "Returns the response type.
    
     Can be set to change the response type.
     Possible values are defined in [[XMLHttpRequestResponseType]]"
    see (`interface XMLHttpRequestResponseType`)
    shared formal String responseType;
    
    "Returns the response entity body."
    shared formal dynamic response;
    
    "Returns the text response entity body."
    shared formal String responseText;
    
    "Returns the document response entity body."
    shared formal Document? responseXml;
}

"Creates a new instance of [[XMLHttpRequest]]."
shared XMLHttpRequest newXMLHttpRequest()
        => newXMLHttpRequestInternal();

shared dynamic XMLHttpRequestEventTarget satisfies EventTarget {
    // event handlers
    "Dispatched when the request starts."
    shared formal variable EventHandler? onloadstart;
    
    "Dispatched when transmitting data."
    shared formal variable EventHandler? onprogress;
    
    "Dispatched when the request has been aborted. For instance,
     by invoking the `abort()` method."
    shared formal variable EventHandler? onabort;
    
    "Dispatched when the request has failed."
    shared formal variable EventHandler? onerror;
    
    "Dispatched when the request has successfully completed."
    shared formal variable EventHandler? onload;
    
    "Dispatched when the author specified timeout has passed before
     the request completed."
    shared formal variable EventHandler? ontimeout;
    
    "Dispatched when the request has completed (either in success or failure)."
    shared formal variable EventHandler? onloadend;
}

"Used to gather transmission information when data is transferred to a server."
shared dynamic XMLHttpRequestUpload satisfies XMLHttpRequestEventTarget {
}

"Possible values for [[XMLHttpRequest.responseType]]."
shared interface XMLHttpRequestResponseType {
    shared String empty => "";
    shared String arrayBuffer => "arraybuffer";
    shared String blob => "blob";
    shared String document => "document";
    shared String json => "json";
    shared String text => "text";
}
