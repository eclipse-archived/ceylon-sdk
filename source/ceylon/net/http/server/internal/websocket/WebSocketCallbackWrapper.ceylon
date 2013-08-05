import ceylon.net.http.server.websocket { SendCallback, WebSocketChannel }
import io.undertow.websockets.core { WebSocketCallback, UtWebSocketChannel = WebSocketChannel, FragmentedMessageChannel }
import java.lang { Void }
import ceylon.net.http.server { HttpException = Exception }

by("Matej Lazar")
shared class WebSocketCallbackWrapper(SendCallback sendCallback, WebSocketChannel channel) 
        satisfies WebSocketCallback<Void> {

    shared actual void complete(UtWebSocketChannel? webSocketChannel, Void? t) {
        sendCallback.onCompletion(channel);
    }

    shared actual void onError(UtWebSocketChannel? webSocketChannel, Void? t, Exception? throwable) {
        if (exists throwable) {
            //TODO better exception handling
            sendCallback.onError(channel, HttpException("", throwable));
        } else {
            sendCallback.onError(channel, HttpException("No description."));
        }
    }
}

shared class WebSocketCallbackFragmentedWrapper(SendCallback sendCallback, WebSocketChannel channel)
        satisfies WebSocketCallback<FragmentedMessageChannel> {

    shared actual void complete(UtWebSocketChannel? webSocketChannel, FragmentedMessageChannel ch) {
        sendCallback.onCompletion(channel);
    }

    shared actual void onError(UtWebSocketChannel? webSocketChannel, FragmentedMessageChannel ch, Exception? throwable) {
        if (exists throwable) {
            //TODO better exception handling
            sendCallback.onError(channel, HttpException("", throwable));
        } else {
            sendCallback.onError(channel, HttpException("No description."));
        }
    }
}

shared WebSocketCallbackWrapper? wrapCallbackSend(SendCallback? sendCallback, WebSocketChannel channel) {
    if (exists sendCallback) {
        return WebSocketCallbackWrapper(sendCallback, channel);
    } else {
        return null;
    }
}

shared WebSocketCallbackFragmentedWrapper? wrapFragmentedCallbackSend(SendCallback? sendCallback, WebSocketChannel channel) {
    if (exists sendCallback) {
        return WebSocketCallbackFragmentedWrapper(sendCallback, channel);
    } else {
        return null;
    }
}
