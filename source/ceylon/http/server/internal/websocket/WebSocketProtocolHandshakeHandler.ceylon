/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
import ceylon.collection {
    HashSet
}

import io.undertow.server {
    HttpHandler,
    HttpServerExchange,
    HttpUpgradeListener
}
import io.undertow.util {
    Methods {
        methodGet = GET
    }
}
import io.undertow.websockets {
    UtWebSocketProtocolHandshakeHandler=WebSocketProtocolHandshakeHandler
}
import io.undertow.websockets.core.protocol {
    Handshake
}
import io.undertow.websockets.core.protocol.version07 {
    Hybi07Handshake
}
import io.undertow.websockets.core.protocol.version08 {
    Hybi08Handshake
}
import io.undertow.websockets.core.protocol.version13 {
    Hybi13Handshake
}
import io.undertow.websockets.spi {
    AsyncWebSocketHttpServerExchange
}
import org.xnio {
    StreamConnection
}
import io.undertow.websockets.core {
    WebSocketChannel
}

by ("Matej Lazar")
shared class WebSocketProtocolHandshakeHandler(
        CeylonWebSocketHandler webSocketHandler, 
    HttpHandler next)
        extends UtWebSocketProtocolHandshakeHandler(webSocketHandler, next) {

    Set<Handshake> handshakes = HashSet {
        Hybi13Handshake(),
        Hybi08Handshake(),
        Hybi07Handshake()
    };

    shared actual void handleRequest(HttpServerExchange exchange) {
        if (!exchange.requestMethod.equals(methodGet)) {
            // Only GET is supported to start the handshake
            next.handleRequest(exchange);
            return;
        }
        value facade = AsyncWebSocketHttpServerExchange(exchange, peerConnections);
        variable Handshake? handshaker = null;
        for (Handshake method in handshakes) {
            if (method.matches(facade)) {
                handshaker = method;
                break;
            }
        }

        if (exists h = handshaker) {
            handleWebSocketRequest(exchange, facade, h);
        } else {
            next.handleRequest(exchange);
            return;
        }
    }
    
    void handleWebSocketRequest(HttpServerExchange exchange, 
            AsyncWebSocketHttpServerExchange facade, 
            Handshake handshaker) {
        if (webSocketHandler.endpointExists(exchange.requestPath)) {
            
            object httpUpgradeListener satisfies HttpUpgradeListener {
                shared actual void handleUpgrade(StreamConnection? streamConnection, HttpServerExchange? httpServerExchange) {
                    WebSocketChannel channel = handshaker.createChannel(facade, streamConnection, facade.bufferPool);
                    peerConnections.add(channel);
                    webSocketHandler.onConnect(facade, channel);
                }
            }
            exchange.upgradeChannel(httpUpgradeListener);
            handshaker.handshake(facade);
        } else {
            exchange.setStatusCode(404);
            exchange.endExchange();
            return;
        }
    }

}
