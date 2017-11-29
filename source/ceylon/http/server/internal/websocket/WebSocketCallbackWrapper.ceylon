/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
import ceylon.http.server {
    HttpException=ServerException
}
import ceylon.http.server.websocket {
    WebSocketChannel
}

import io.undertow.websockets.core {
    WebSocketCallback,
    UtWebSocketChannel=WebSocketChannel
}

import java.lang {
    Void
}

by("Matej Lazar")
class WebSocketCallbackWrapper(
    Anything(WebSocketChannel)? onCompletion,
    Anything(WebSocketChannel,Exception)? onSocketError,
    WebSocketChannel channel)
        satisfies WebSocketCallback<Void> {

    shared actual void complete(UtWebSocketChannel? webSocketChannel, 
        Void? t) {
        if (exists onCompletion) {
            onCompletion(channel);
        }
    }

    shared actual void onError(UtWebSocketChannel? webSocketChannel, 
        Void? t, Throwable? throwable) {
        if (exists onSocketError) {
            if (exists throwable) {
                onSocketError(channel, 
                    HttpException("WebSocket error.", throwable));
            } else {
                onSocketError(channel, 
                    HttpException("WebSocket error, no details available."));
            }
        }
    }
}

WebSocketCallbackWrapper wrapCallbackSend(
    Anything(WebSocketChannel)? onCompletion,
    Anything(WebSocketChannel,Exception)? onError,
    WebSocketChannel channel)
        => WebSocketCallbackWrapper(onCompletion, onError, channel);
