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

import java.nio {
    JByteBuffer=ByteBuffer
}

by("Matej Lazar")

shared ByteBuffer toCeylonByteBuffer(JByteBuffer? jByteBuffer) {
    if (exists jbb = jByteBuffer) {
        Array<Byte> cba;
        if (jbb.hasArray()) {
            cba = jbb.array().byteArray;
        } else {
            cba = Array<Byte>.ofSize(jbb.limit(), 0.byte);
            for (ii in 0: jbb.limit()) {
                cba[ii] = jbb.get(ii);
            }
        }
        ByteBuffer bb = ByteBuffer.ofArray(cba);
        return bb;
    } else {
        return ByteBuffer.ofSize(0);
    }
}

shared ByteBuffer mergeBuffers({ByteBuffer*} payload) {
    variable Integer payloadSize = 0;
    for (ByteBuffer bb in payload) {
        payloadSize = payloadSize + bb.available;
    }
    
    ByteBuffer buffer = ByteBuffer.ofSize(payloadSize);
    if (payloadSize == 0) {
        return buffer;
    }
    
    for (ByteBuffer bb in payload) {
        addBytes(buffer, bb);
    }
    buffer.flip();
    return buffer;
}

void addBytes(ByteBuffer toBuffer, ByteBuffer fromBuffer) {
    while (fromBuffer.hasAvailable) {
        toBuffer.put(fromBuffer.get());
    }
}
