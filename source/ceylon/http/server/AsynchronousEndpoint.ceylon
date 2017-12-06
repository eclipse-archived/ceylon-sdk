/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
import ceylon.http.common {
    Method
}

"Asynchronous web endpoint. Endpoint is executed 
 asynchronously. End of request processing must be 
 signaled by calling `complete()`."
by("Matej Lazar")
shared class AsynchronousEndpoint(Matcher path, service, 
    {Method*} acceptMethod) 
        extends HttpEndpoint(path, acceptMethod) {
    
    "Process the request. Implementors must call [[complete]]
     when done."
    shared void service(Request request, Response response,
            void complete());
    
}