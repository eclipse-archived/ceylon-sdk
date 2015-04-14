import ceylon.io.buffer {
    newByteBufferWithData
}
import ceylon.net.http.server.websocket {
    WebSocketChannel,
    WebSocketEndpoint,
    CloseReason,
    NoReason
}

import io.undertow.websockets.core {
    AbstractReceiveListener,
    BufferedTextMessage,
    UtWebSocketChannel=WebSocketChannel,
    BufferedBinaryMessage
}

import java.nio {
    JByteBuffer=ByteBuffer
}

import org.xnio {
    IoUtils {
        safeClose
    }
}
import ceylon.net.http.server.internal {
    toBytes
}
import ceylon.language.meta.model {
    IncompatibleTypeException
}

by("Matej Lazar")
class CeylonWebSocketFrameHandler(WebSocketEndpoint webSocketEndpoint, WebSocketChannel webSocketChannel)
        extends AbstractReceiveListener() {

    shared actual void onFullTextMessage(UtWebSocketChannel channel, BufferedTextMessage message) 
            => webSocketEndpoint.onText(webSocketChannel, message.data );

    shared actual void onFullBinaryMessage(UtWebSocketChannel channel, BufferedBinaryMessage message) {
        Object? jByteBufferArray = message.data.resource.iterable;
        if (is JByteBuffer[] jByteBufferArray) {
            webSocketEndpoint.onBinary(webSocketChannel, newByteBufferWithData(*toBytes(jByteBufferArray)));
        } else {
            throw IncompatibleTypeException("Invalid object type. Java ByteBuffer array was expected.");
        } 
    }

    shared actual void onFullCloseMessage(UtWebSocketChannel channel, BufferedBinaryMessage message) {
        Object? jByteBufferArray = message.data.resource.iterable;
        if (is JByteBuffer[] jByteBufferArray) {
            {Byte*} bytes = toBytes(jByteBufferArray);
            if (bytes.size > 2) {
                CloseReasonAdapter closeReasonAdapter = CloseReasonAdapter(bytes);
                webSocketEndpoint.onClose(webSocketChannel, CloseReason(closeReasonAdapter.code, closeReasonAdapter.reason));
            } else {
                webSocketEndpoint.onClose(webSocketChannel, NoReason());
            }
        } else {
            throw IncompatibleTypeException("Invalid object type. Java ByteBuffer array was expected.");
        }
        //close is sent back to the client by Undertow
    }

    shared actual void onError(UtWebSocketChannel channel, Throwable error) {
        webSocketEndpoint.onError(webSocketChannel, error);
        safeClose(channel);
    }
}
