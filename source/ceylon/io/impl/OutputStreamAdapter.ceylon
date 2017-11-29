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
    WritableFileDescriptor
}

import java.io {
    OutputStream
}
import java.nio {
    JavaByteBuffer=ByteBuffer
}
import java.nio.channels {
    WritableByteChannel,
    Channels
}

shared class OutputStreamAdapter(OutputStream stream) satisfies WritableFileDescriptor {
    WritableByteChannel channel = Channels.newChannel(stream);
    
    close() => channel.close();
    
    shared actual Integer write(ByteBuffer buffer) {
        assert (is JavaByteBuffer implementation = buffer.implementation);
        return channel.write(implementation);
    }
}
