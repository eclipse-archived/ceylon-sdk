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
    WebSockets {
        sendCloseBlocking
    },
    UTF8Output,
    StreamSourceFrameChannel
}

import java.nio {
    JByteBuffer=ByteBuffer {
        wrapByteBuffer=wrap
    }
}

import org.xnio {
    IoUtils {
        safeClose
    }
}

by("Matej Lazar")
class CeylonWebSocketFragmentedFrameHandler(
    WebSocketFragmentedEndpoint webSocketEndpoint, 
    WebSocketChannel webSocketChannel)
        extends AbstractReceiveListener() {

    shared actual void onText(UtWebSocketChannel channel, 
            StreamSourceFrameChannel messageChannel) {
        BufferedTextMessage bufferedTextMessage = BufferedTextMessage();
        bufferedTextMessage.readBlocking(messageChannel);
        webSocketEndpoint.onText(webSocketChannel, 
            bufferedTextMessage.data, messageChannel.finalFragment);
    }

    shared actual void onBinary(UtWebSocketChannel channel, 
            StreamSourceFrameChannel messageChannel) {
        value bufferedBinaryMessage = BufferedBinaryMessage();
        bufferedBinaryMessage.readBlocking(messageChannel);
        webSocketEndpoint.onBinary(
                webSocketChannel, 
                newByteBufferWithData(*bufferedBinaryMessage.toByteArray().byteArray),
                messageChannel.finalFragment);
    }

    shared actual void onClose(UtWebSocketChannel channel, 
            StreamSourceFrameChannel messageChannel) {
        value bufferedBinaryMessage = BufferedBinaryMessage();
        bufferedBinaryMessage.readBlocking(messageChannel);

        JByteBuffer buffer = wrapByteBuffer(bufferedBinaryMessage.toByteArray());
        
        if (buffer.remaining() > 2) {
            Integer code = buffer.short;
            String reason = UTF8Output(buffer).extract();
            webSocketEndpoint.onClose(webSocketChannel, 
                CloseReason(code, reason));
        } else {
            webSocketEndpoint.onClose(webSocketChannel, 
                NoReason());
        }
        sendCloseBlocking(bufferedBinaryMessage.data, channel);
    }

    shared actual void onError(UtWebSocketChannel channel, Throwable? error) {
        webSocketEndpoint.onError(webSocketChannel, error);
        safeClose(channel);
    }
}
