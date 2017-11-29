/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
import ceylon.http.server.websocket {
    FragmentedTextSender,
    WebSocketChannel
}

import io.undertow.websockets.core {
    WebSockets {
        wsSendText=sendText,
        wsSendTextBlocking=sendTextBlocking,
        wsSendClose=sendClose,
        wsSendCloseBlocking=sendCloseBlocking
    },
    WebSocketFrameType
}
import java.nio {
    JByteBuffer=ByteBuffer
}
import ceylon.buffer.charset {
    utf8
}
import ceylon.language.meta.model {
    IncompatibleTypeException
}

by("Matej Lazar")
class DefaultFragmentedTextSender(DefaultWebSocketChannel channel) 
        satisfies FragmentedTextSender {

    value fragmentedChannel = channel.underlyingChannel.send(WebSocketFrameType.text);
    
    shared actual void sendText(String text, Boolean finalFrame) {
        value wsChannel = fragmentedChannel.webSocketChannel;
        if (finalFrame) {
            Object? jByteBuffer = utf8.encodeBuffer(text).implementation;
            if (is JByteBuffer jByteBuffer) {
                wsSendCloseBlocking(jByteBuffer , wsChannel);
            } else {
                throw IncompatibleTypeException("Inalid underlying implementation, Java ByteBuffer was expected.");
            }
        } else {
            wsSendTextBlocking(text, wsChannel);
        }
    }
    
    shared actual void sendTextAsynchronous(String text,
            Anything(WebSocketChannel) onCompletion,
            Anything(WebSocketChannel,Exception)? onError,
            Boolean finalFrame) {
        
        value wsChannel = fragmentedChannel.webSocketChannel;
        
        if (finalFrame) {
            Object? jByteBuffer = utf8.encodeBuffer(text).implementation;
            if (is JByteBuffer jByteBuffer) {
                wsSendClose(jByteBuffer , wsChannel, wrapCallbackSend(onCompletion, onError, channel));
            } else {
                throw IncompatibleTypeException("Inalid underlying implementation, Java ByteBuffer was expected.");
            }
        } else {
            wsSendText(text, wsChannel, wrapCallbackSend(onCompletion, onError, channel));
        }
    }

}
