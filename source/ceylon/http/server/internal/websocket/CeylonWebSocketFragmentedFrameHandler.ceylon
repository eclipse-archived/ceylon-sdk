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
    WebSocketChannel,
    WebSocketFragmentedEndpoint
}
import io.undertow.websockets.core {
    BufferedTextMessage,
    UtWebSocketChannel=WebSocketChannel,
    BufferedBinaryMessage,
    StreamSourceFrameChannel
}
import java.nio {
    JByteBuffer=ByteBuffer
}
import ceylon.http.server.internal {
    toCeylonByteBuffer,
    mergeBuffers
}
import java.lang {
    ObjectArray
}
import org.xnio {
    Pooled
}

by("Matej Lazar")
class CeylonWebSocketFragmentedFrameHandler(
    WebSocketFragmentedEndpoint webSocketEndpoint, 
    WebSocketChannel webSocketChannel)
        extends CeylonWebSocketAbstractFrameHandler(webSocketEndpoint, webSocketChannel) {

    shared actual void onText(UtWebSocketChannel channel, 
            StreamSourceFrameChannel messageChannel) {
        BufferedTextMessage bufferedTextMessage = BufferedTextMessage(true);
        bufferedTextMessage.readBlocking(messageChannel);
        webSocketEndpoint.onText(webSocketChannel, 
            bufferedTextMessage.data, messageChannel.finalFragment);
    }

    shared actual void onBinary(UtWebSocketChannel channel, 
            StreamSourceFrameChannel messageChannel) {

        value bufferedBinaryMessage = BufferedBinaryMessage(true);
        bufferedBinaryMessage.readBlocking(messageChannel);

        Pooled<ObjectArray<JByteBuffer>> data = bufferedBinaryMessage.data;
        try {
            ObjectArray<JByteBuffer> jByteBufferArray = data.resource;
            ByteBuffer binary = mergeBuffers{ 
                for (jbb in jByteBufferArray.iterable) toCeylonByteBuffer(jbb)
            };
            webSocketEndpoint.onBinary(webSocketChannel, binary, messageChannel.finalFragment);
        } catch (Exception e) {
            //TODO handle exception
            e.printStackTrace();
        } finally {
            data.free();
        }
    }
}
