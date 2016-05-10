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
