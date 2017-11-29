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
    ReadableFileDescriptor
}

import java.io {
    InputStream
}
import java.nio {
    JavaByteBuffer=ByteBuffer
}
import java.nio.channels {
    ReadableByteChannel,
    Channels
}

shared class InputStreamAdapter(InputStream stream) satisfies ReadableFileDescriptor {
    ReadableByteChannel channel = Channels.newChannel(stream);
    
    shared actual void close() => channel.close();
    
    shared actual Integer read(ByteBuffer buffer) {
        assert (is JavaByteBuffer implementation = buffer.implementation);
        return channel.read(implementation);
    }
}
