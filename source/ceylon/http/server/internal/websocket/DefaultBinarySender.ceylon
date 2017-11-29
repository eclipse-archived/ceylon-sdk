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
    FragmentedBinarySender,
    WebSocketChannel
}

import io.undertow.websockets.core {
    WebSockets {
        wsSendBinary=sendBinary,
        wsSendBinaryBlocking=sendBinaryBlocking,
        wsSendClose=sendClose,
        wsSendCloseBlocking=sendCloseBlocking
    },
    WebSocketFrameType
}
import java.nio {
    JByteBuffer=ByteBuffer
}
import ceylon.language.meta.model {
    IncompatibleTypeException
}

by("Matej Lazar")
class DefaultFragmentedBinarySender(DefaultWebSocketChannel channel)
        satisfies FragmentedBinarySender {

    value fragmentedChannel = channel.underlyingChannel.send(WebSocketFrameType.binary);

    shared actual void sendBinary(ByteBuffer binary, Boolean finalFrame) {
        value wsChannel = fragmentedChannel.webSocketChannel;

        Object? jByteBuffer = binary.implementation;
        if (is JByteBuffer jByteBuffer) {
            if (finalFrame) {
                wsSendCloseBlocking(jByteBuffer , wsChannel);
            } else {
                wsSendBinaryBlocking(jByteBuffer, wsChannel);
            }
        } else {
            throw IncompatibleTypeException("Inalid underlying implementation, Java ByteBuffer was expected.");
        }
    }
    
    shared actual void sendBinaryAsynchronous(
            ByteBuffer binary,
            Anything(WebSocketChannel) onCompletion,
            Anything(WebSocketChannel,Exception)? onError,
            Boolean finalFrame) {

        value wsChannel = fragmentedChannel.webSocketChannel;

        Object? jByteBuffer = binary.implementation;
        if (is JByteBuffer jByteBuffer) {
            if (finalFrame) {
                wsSendClose(jByteBuffer , wsChannel, wrapCallbackSend(onCompletion, onError, channel));
            } else {
                wsSendBinary(jByteBuffer, wsChannel, wrapCallbackSend(onCompletion, onError, channel));
            }
        } else {
            throw IncompatibleTypeException("Inalid underlying implementation, Java ByteBuffer was expected.");
        }
    }
}
