/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
import ceylon.io.impl {
    ServerSocketImpl
}

"Represents a server socket: a socket open on the current 
 host that accepts incoming connections from other hosts.
 
 This supports synchronous and asynchronous modes of 
 operations.
 
 The server socket is bound immediately to the specified 
 address (or to every local network interface if not set), 
 but it will only accept incoming connections when you 
 call [[accept]] or [[acceptAsync]].
 
 New server sockets are created with [[newServerSocket]]."
by("Stéphane Épardaud")
see(`function newServerSocket`)
shared sealed interface ServerSocket {
    
    "Returns the local address this server socket is 
     listening on."
    shared formal SocketAddress localAddress;
    
    "Accepts an incoming connection and return its 
     associated [[Socket]]. Will block the current thread 
     until there is an incoming connection."
    shared formal Socket accept();
    
    "Registers an `accept` listener on the given [[selector]], 
     that will be notified every time there is an incoming 
     connection.
     
     If you wish to stop accepting connections, your listener 
     should return `false` when invoked."
    see(`interface Selector`)
    shared formal void acceptAsync(Selector selector, 
        Boolean accept(Socket socket));
    
    "Closes this server socket."
    shared formal void close();
}

"Instantiates and binds a new server socket."
see(`interface ServerSocket`)
shared ServerSocket newServerSocket(SocketAddress? address = null, 
    Integer backlog = 0)
        => ServerSocketImpl(address, backlog);
