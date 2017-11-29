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
import ceylon.buffer.charset {
    Charset
}

"Transforms a [consumer] method that accepts [[String]]s into a consumer method
 that accepts [[ByteBuffer]]s, according to the given [[charset]].
 
 Another way to see it is that this method returns a method which accepts
 [[ByteBuffer]] parameters, decodes them using the given [[charset]], and
 passes them on to the given [[consumer]] method which accepts decoded
 [[String]] objects."
by ("Stéphane Épardaud")
shared Anything(ByteBuffer) byteConsumerToStringConsumer
        (Charset charset, void consumer(String buffer)) {
    void translator(ByteBuffer buffer) {
        value decoded = charset.decode(buffer);
        if (!decoded.empty) {
            consumer(decoded);
        }
    }
    return translator;
}

"Transforms a [[string]] into a producer method that produces [[ByteBuffer]]s,
 according to the given [[charset]].
 
 Another way to see it is that this method returns a method which accepts
 [[ByteBuffer]] parameters, and fills them with the given [[string]], encoded
 using the given [[charset]]."
by ("Stéphane Épardaud")
shared Anything(ByteBuffer) stringToByteProducer
        (Charset charset, String string) {
    value encoder = charset.chunkEncoder();
    value chars = string.iterator().next;
    void producer(ByteBuffer buffer) {
        encoder.convert(buffer, chars, true);
    }
    return producer;
}
