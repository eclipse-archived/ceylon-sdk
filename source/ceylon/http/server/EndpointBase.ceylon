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

abstract shared class EndpointBase(path) {
    shared Matcher path;
}

abstract shared class HttpEndpoint(Matcher path, acceptMethod) 
        of AsynchronousEndpoint | Endpoint 
        extends EndpointBase(path) {
    shared {Method*} acceptMethod;
}
