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
import ceylon.file {
    Resource
}
import ceylon.io {
    OpenFile
}

import java.nio {
    JavaByteBuffer=ByteBuffer
}
import java.nio.channels {
    FileChannel {
        javaOpenFileChannel=open
    }
}
import java.nio.file {
    Paths {
        javaGetPath=get
    },
    StandardOpenOption
}

shared class OpenFileImpl(resource) 
        satisfies OpenFile {
    
    shared actual Resource resource;

	FileChannel channel = 
			javaOpenFileChannel(javaGetPath(resource.path.string),
                StandardOpenOption.create,
                StandardOpenOption.write,
                StandardOpenOption.read);
    
    close() => channel.close();

    size => channel.size();
    
    truncate(Integer size) => channel.truncate(size);
    
    shared actual Integer position => channel.position();
    assign position => channel.position(position);

    shared actual Integer read(ByteBuffer buffer) {
        assert(is JavaByteBuffer impl = buffer.implementation);
        return channel.read(impl);
    }

    shared actual Integer write(ByteBuffer buffer) {
        assert(is JavaByteBuffer impl = buffer.implementation);
        return channel.write(impl);
    }

    shared actual Object implementation => channel;
}