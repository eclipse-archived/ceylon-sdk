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
    SocketAddress,
    ServerSocket,
    Socket,
    Selector
}

import java.net {
    InetSocketAddress
}
import java.nio.channels {
    ServerSocketChannel {
        openSocket=open
    },
    JavaSelector=Selector,
    SelectionKey
}

shared class ServerSocketImpl(SocketAddress? bindAddress, 
    Integer backlog = 0) 
        satisfies ServerSocket{

    shared ServerSocketChannel channel = openSocket();
    shared actual SocketAddress localAddress;

    if(exists bindAddress) {
        value address = 
                InetSocketAddress(bindAddress.address, bindAddress.port);
        channel.bind(address, backlog);
    }else{
        channel.bind(null, backlog);
    }

    assert(is InetSocketAddress socketAddress = channel.localAddress);
    localAddress = SocketAddress(socketAddress.hostString, socketAddress.port);

    accept() => SocketImpl(channel.accept());

    shared actual void acceptAsync(Selector selector, 
            Boolean accept(Socket socket)) {
        channel.configureBlocking(false);
        channel.accept();
        selector.addAcceptListener(this, accept);
    }

    close() => channel.close();
    
    shared default SelectionKey register(JavaSelector selector, 
        Integer ops, Object attachment)
            => channel.register(selector, ops, attachment);
    
    shared default void interestOps(SelectionKey key, Integer ops) 
            => key.interestOps(ops);
}