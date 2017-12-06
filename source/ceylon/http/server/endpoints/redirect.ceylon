/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
import ceylon.http.server {
    Request,
    Response
}
import ceylon.http.common {
    Header
}

"Endpoint for HTTP redirection. _Must_ be attached to an
 [[ceylon.http.server::AsynchronousEndpoint]].
 
 For example:
 
     shared void run() 
            => newServer {
        AsynchronousEndpoint {
            path = isRoot();
            acceptMethod = { get };
            service = redirect(\"/index.html\");
        }
     };"
shared void redirect(String url, 
        RedirectType type=RedirectType.seeOther)
        (Request request, Response response, void complete()) {
    response.status = type.statusCode;
    response.addHeader(Header("Location", url));
    complete();
}

shared class RedirectType {
    shared Integer statusCode;
    shared new movedPermanently { statusCode=301; }
    shared new seeOther { statusCode=303; }
    shared new temporaryRedirect { statusCode=307; }
    string => statusCode.string;
}