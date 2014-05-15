import ceylon.io.buffer { ByteBuffer }

import ceylon.net.http.server.websocket { WebSocketChannel, FragmentedBinarySender, FragmentedTextSender, CloseReason }

import ceylon.net.http.server.internal { toJavaByteBuffer}
import io.undertow.websockets.core { 
    UtWebSocketChannel = WebSocketChannel,
    WebSockets {
        wsSendBinary = sendBinary,
        wsSendBinaryBlocking = sendBinaryBlocking,
        wsSendText = sendText,
        wsSendTextBlocking = sendTextBlocking,
        wsSendClose = sendClose,
        wsSendCloseBlocking = sendCloseBlocking
        }, CloseMessage
    }
import io.undertow.websockets.spi { WebSocketHttpExchange }
import io.undertow.util { Headers {hostStringHeader = \iHOST_STRING} }

by("Matej Lazar")
shared class DefaultWebSocketChannel(WebSocketHttpExchange exchange, UtWebSocketChannel channel) satisfies WebSocketChannel {

    shared UtWebSocketChannel underlyingChannel => channel;

    shared actual Boolean closeFrameReceived => channel.closeFrameReceived;

    shared actual Integer idleTimeout => channel.idleTimeout;

    shared actual Boolean open() => channel.open;

    shared actual String schema => channel.requestScheme;

    shared actual FragmentedTextSender fragmentedTextSender() {
        return DefaultFragmentedTextSender(this);
    }

    shared actual FragmentedBinarySender fragmentedBinarySender() {
        return DefaultFragmentedBinarySender(this);
    }

    shared actual void sendBinary(ByteBuffer binary) {
        wsSendBinaryBlocking(toJavaByteBuffer(binary), channel);
    }

    shared actual void sendBinaryAsynchronous(
            ByteBuffer binary,
            Callable<Anything, [WebSocketChannel]> onCompletion,
            Callable<Anything, [WebSocketChannel, Throwable]>? onError) {

        wsSendBinary(toJavaByteBuffer(binary), channel, wrapCallbackSend(onCompletion, onError, this));
    }

    shared actual void sendText(String text) {
        wsSendTextBlocking(text, channel);
    }

    shared actual void sendTextAsynchronous(
            String text,
            Callable<Anything, [WebSocketChannel]> onCompletion,
            Callable<Anything, [WebSocketChannel, Throwable]>? onError) {

        wsSendText(text, channel, wrapCallbackSend(onCompletion, onError, this));
    }

    shared actual void sendClose(CloseReason reason) {
        wsSendCloseBlocking(CloseMessage(reason.code.integer, reason.reason else "").toByteBuffer(), channel);
    }

    shared actual String hostname => exchange.getRequestHeader(hostStringHeader);

    shared actual String requestPath => exchange.requestURI;

    shared actual void sendCloseAsynchronous(
            CloseReason reason,
            Callable<Anything, [WebSocketChannel]> onCompletion,
            Callable<Anything, [WebSocketChannel, Throwable]>? onError) {

        wsSendClose(
            CloseMessage(reason.code.integer, reason.reason else "").toByteBuffer(),
            channel,
            wrapCallbackSend(onCompletion, onError, this));
    }
}
