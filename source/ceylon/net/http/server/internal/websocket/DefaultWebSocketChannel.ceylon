import ceylon.io.buffer {
    ByteBuffer
}
import ceylon.net.http.server.websocket {
    WebSocketChannel,
    FragmentedBinarySender,
    FragmentedTextSender,
    CloseReason
}

import io.undertow.util {
    Headers {
        hostStringHeader=HOST_STRING
    }
}
import io.undertow.websockets.core {
    UtWebSocketChannel=WebSocketChannel,
    WebSockets {
        wsSendBinary=sendBinary,
        wsSendBinaryBlocking=sendBinaryBlocking,
        wsSendText=sendText,
        wsSendTextBlocking=sendTextBlocking,
        wsSendClose=sendClose,
        wsSendCloseBlocking=sendCloseBlocking
    },
    CloseMessage
}
import io.undertow.websockets.spi {
    WebSocketHttpExchange
}

by("Matej Lazar")
shared class DefaultWebSocketChannel(WebSocketHttpExchange exchange, 
    UtWebSocketChannel channel) 
        satisfies WebSocketChannel {

    shared UtWebSocketChannel underlyingChannel => channel;

    shared actual Boolean closeFrameReceived => channel.closeFrameReceived;

    shared actual Integer idleTimeout => channel.idleTimeout;

    shared actual Boolean open() => channel.open;

    shared actual String schema => channel.requestScheme;

    shared actual FragmentedTextSender fragmentedTextSender() 
            => DefaultFragmentedTextSender(this);

    shared actual FragmentedBinarySender fragmentedBinarySender() 
            => DefaultFragmentedBinarySender(this);

    shared actual void sendBinary(ByteBuffer binary) 
            => wsSendBinaryBlocking(createJavaByteBuffer(binary), channel);

    shared actual void sendBinaryAsynchronous(
            ByteBuffer binary,
            Anything(WebSocketChannel) onCompletion,
            Anything(WebSocketChannel,Throwable)? onError) {

        wsSendBinary(createJavaByteBuffer(binary), channel, 
            wrapCallbackSend(onCompletion, onError, this));
    }

    shared actual void sendText(String text) {
        wsSendTextBlocking(text, channel);
    }

    shared actual void sendTextAsynchronous(
            String text,
            Anything(WebSocketChannel) onCompletion,
            Anything(WebSocketChannel,Throwable)? onError) {

        wsSendText(text, channel, wrapCallbackSend(onCompletion, onError, this));
    }

    shared actual void sendClose(CloseReason reason) {
        wsSendCloseBlocking(CloseMessage(reason.code, reason.reason else "").toByteBuffer(), channel);
    }

    shared actual String hostname => exchange.getRequestHeader(hostStringHeader);

    shared actual String requestPath => exchange.requestURI;

    shared actual void sendCloseAsynchronous(
            CloseReason reason,
            Anything(WebSocketChannel) onCompletion,
            Anything(WebSocketChannel,Throwable)? onError) {

        wsSendClose(
            CloseMessage(reason.code, reason.reason else "").toByteBuffer(),
            channel,
            wrapCallbackSend(onCompletion, onError, this));
    }
}
