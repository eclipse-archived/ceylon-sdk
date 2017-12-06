/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
import ceylon.buffer {
    ByteBuffer
}
import ceylon.io {
    Socket
}

import java.nio {
    JavaByteBuffer=ByteBuffer
}
import java.nio.channels {
    SocketChannel,
    SelectionKey,
    Selector
}

class SocketImpl(channel) 
        satisfies Socket {
    
    shared SocketChannel channel;
    
    close() => channel.close();
    
    shared default actual Integer read(ByteBuffer buffer) {
        assert(is JavaByteBuffer impl = buffer.implementation);
        return channel.read(impl);
    }
    shared default actual Integer write(ByteBuffer buffer) {
        assert(is JavaByteBuffer impl = buffer.implementation);
        return channel.write(impl);
    }
    
    shared actual Boolean blocking 
            => channel.blocking;
    assign blocking 
            => channel.configureBlocking(blocking);
    
    shared default SelectionKey register(Selector selector, 
        Integer ops, Object attachment)
            => channel.register(selector, ops, attachment);
    
    shared default void interestOps(SelectionKey key, Integer ops) 
            => key.interestOps(ops);
}


