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
import ceylon.http.server.websocket {
    WebSocketChannel
}

by("Matej Lazar")
shared interface FragmentedBinarySender {

    shared formal void sendBinary(
        ByteBuffer payload, 
        Boolean finalFrame = false);

    shared formal void sendBinaryAsynchronous(
        ByteBuffer binary,
        Anything(WebSocketChannel) onCompletion,
        Anything(WebSocketChannel,Exception)? onError = null,
        Boolean finalFrame = false);

}
