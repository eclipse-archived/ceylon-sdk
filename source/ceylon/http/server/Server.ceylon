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
import ceylon.http.server.internal {
    DefaultServer
}
import ceylon.http.server.websocket {
    WebSocketBaseEndpoint
}

"A HTTP server."
by("Matej Lazar")
see(`function newServer`)
shared sealed interface Server {
    
    "Start the server in the current thread."
    shared formal void start(
        SocketAddress socketAddress 
                = SocketAddress("127.0.0.1", 8080), 
        Options serverOptions = Options());
    
    "Start the server in a new thread."
    shared formal void startInBackground(
        SocketAddress socketAddress 
                = SocketAddress("127.0.0.1", 8080), 
        Options serverOptions = Options());
    
    "Stop the server."
    shared formal void stop();
    
    "Define endpoint by providing an 
     [[Endpoint]] or [[AsynchronousEndpoint]]."
    shared formal void addEndpoint(HttpEndpoint endpoint);
    
    "Define an endpoint by providing a
     [[ceylon.http.server.websocket::WebSocketEndpoint]] or 
     [[ceylon.http.server.websocket::WebSocketFragmentedEndpoint]]"
    shared formal void addWebSocketEndpoint(WebSocketBaseEndpoint endpoint);

    "Registers a status change listener.
     Listeners are called on [[status|Status]] changes. 
     Statuses are: 
     [[starting|Status.starting]], 
     [[started|Status.started]], 
     [[stopping|Status.stopping]], 
     [[stopped|Status.stopped]]."
    shared formal void addListener(void listener(Status status));

}

"Create a new HTTP server."
shared Server newServer({HttpEndpoint|WebSocketBaseEndpoint*} endpoints) 
        => DefaultServer(endpoints);
