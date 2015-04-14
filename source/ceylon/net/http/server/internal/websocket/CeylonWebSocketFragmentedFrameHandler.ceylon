import ceylon.io.buffer {
    newByteBufferWithData
}
import ceylon.net.http.server.websocket {
    WebSocketChannel,
    CloseReason,
    WebSocketFragmentedEndpoint,
    NoReason
}
import io.undertow.websockets.core {
    AbstractReceiveListener,
    BufferedTextMessage,
    UtWebSocketChannel=WebSocketChannel,
    BufferedBinaryMessage,
    StreamSourceFrameChannel
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
class CeylonWebSocketFragmentedFrameHandler(
    WebSocketFragmentedEndpoint webSocketEndpoint, 
    WebSocketChannel webSocketChannel)
        extends AbstractReceiveListener() {

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

        Object? jByteBufferArray = bufferedBinaryMessage.data.resource.iterable;
        if (is JByteBuffer[] jByteBufferArray) {
            webSocketEndpoint.onBinary(
                webSocketChannel, 
                newByteBufferWithData(*toBytes(jByteBufferArray)), 
                messageChannel.finalFragment);
        } else {
            throw IncompatibleTypeException("Invalid object type. Java ByteBuffer array was expected.");
        }
    }

    shared actual void onClose(UtWebSocketChannel channel,
            StreamSourceFrameChannel messageChannel) {

        value bufferedBinaryMessage = BufferedBinaryMessage(true);
        bufferedBinaryMessage.readBlocking(messageChannel);

        Object? jByteBufferArray = bufferedBinaryMessage.data.resource.iterable;
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

    shared actual void onError(UtWebSocketChannel channel, Throwable? error) {
        webSocketEndpoint.onError(webSocketChannel, error);
        safeClose(channel);
    }
}
