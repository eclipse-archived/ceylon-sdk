import ceylon.net.http.server.websocket { WebSocketChannel }
import io.undertow.websockets.core { WebSocketCallback, UtWebSocketChannel = WebSocketChannel, FragmentedMessageChannel }
import java.lang { Void }
import ceylon.net.http.server { HttpException = Exception }

by("Matej Lazar")
shared class WebSocketCallbackWrapper(
            Callable<Anything, [WebSocketChannel]>? onCompletion,
            Callable<Anything, [WebSocketChannel, Exception]>? onSocketError,
            WebSocketChannel channel)
        satisfies WebSocketCallback<Void> {

    shared actual void complete(UtWebSocketChannel? webSocketChannel, Void? t) {
        if (exists onCompletion) {
            onCompletion(channel);
        }
    }

    shared actual void onError(UtWebSocketChannel? webSocketChannel, Void? t, Exception? throwable) {
        if (exists onSocketError) {
            if (exists throwable) {
                onSocketError(channel, HttpException("WebSocket error.", throwable));
            } else {
                onSocketError(channel, HttpException("WebSocket error, no details available."));
            }
        }
    }
}

shared class WebSocketCallbackFragmentedWrapper(
        Callable<Anything, [WebSocketChannel]>? onCompletion,
        Callable<Anything, [WebSocketChannel, Exception]>? onSocketError,
        WebSocketChannel channel)
        satisfies WebSocketCallback<FragmentedMessageChannel> {

    shared actual void complete(UtWebSocketChannel? webSocketChannel, FragmentedMessageChannel ch) {
        if (exists onCompletion) {
            onCompletion(channel);
        }
    }

    shared actual void onError(UtWebSocketChannel? webSocketChannel, FragmentedMessageChannel ch, Exception? throwable) {
        if (exists onSocketError) {
            if (exists throwable) {
                onSocketError(channel, HttpException("WebSocket error.", throwable));
            } else {
                onSocketError(channel, HttpException("WebSocket error, no details available."));
            }
        }
    }
}

shared WebSocketCallbackWrapper wrapCallbackSend(
        Callable<Anything, [WebSocketChannel]>? onCompletion,
        Callable<Anything, [WebSocketChannel, Exception]>? onError,
        WebSocketChannel channel) {

    return WebSocketCallbackWrapper(onCompletion, onError, channel);
}

shared WebSocketCallbackFragmentedWrapper wrapFragmentedCallbackSend(
        Callable<Anything, [WebSocketChannel]>? onCompletion,
        Callable<Anything, [WebSocketChannel, Exception]>? onError,
        WebSocketChannel channel) {

    return WebSocketCallbackFragmentedWrapper(onCompletion, onError, channel);
}
