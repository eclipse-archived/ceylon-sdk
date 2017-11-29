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
    LinkedList
}
import ceylon.http.server {
    EndpointBase
}

shared class Endpoints() {

    value _endpoints = LinkedList<EndpointBase>();
    shared {EndpointBase*} endpoints => _endpoints;

    shared void add(EndpointBase endpoint)
        => _endpoints.add(endpoint);

    shared {EndpointBase*} getEndpointMatchingPath(String requestPath) {
        return endpoints.filter((endpoint) {return endpoint.path.matches(requestPath);});
    }
}
