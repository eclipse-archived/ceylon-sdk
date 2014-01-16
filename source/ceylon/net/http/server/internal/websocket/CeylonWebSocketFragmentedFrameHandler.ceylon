import java.nio { JByteBuffer=ByteBuffer { wrapByteBuffer=wrap }}
import ceylon.net.http.server.websocket { WebSocketChannel, CloseReason, WebSocketFragmentedEndpoint, NoReason }
import ceylon.io.buffer { newByteBufferWithData }
import io.undertow.websockets.core { 
    AbstractReceiveListener,
    BufferedTextMessage,
    UtWebSocketChannel = WebSocketChannel,
    BufferedBinaryMessage, 
    WebSockets {sendCloseBlocking}, 
    UTF8Output,
    StreamSourceFrameChannel}
import org.xnio {IoUtils {safeClose}}
import ceylon.interop.java { toIntegerArray }

by("Matej Lazar")
class CeylonWebSocketFragmentedFrameHandler(WebSocketFragmentedEndpoint webSocketEndpoint, WebSocketChannel webSocketChannel)
        extends AbstractReceiveListener() {

    shared actual void onText(UtWebSocketChannel channel, StreamSourceFrameChannel messageChannel) {
        BufferedTextMessage bufferedTextMessage = BufferedTextMessage();
        bufferedTextMessage.readBlocking(messageChannel);
        webSocketEndpoint.onText(webSocketChannel, bufferedTextMessage.data, messageChannel.finalFragment );
    }

    shared actual void onBinary(UtWebSocketChannel channel, StreamSourceFrameChannel messageChannel) {
        BufferedBinaryMessage bufferedBinaryMessage = BufferedBinaryMessage();
        bufferedBinaryMessage.readBlocking(messageChannel);
        webSocketEndpoint.onBinary(
                webSocketChannel, 
                newByteBufferWithData(*toIntegerArray(bufferedBinaryMessage.toByteArray())),
                messageChannel.finalFragment);
    }

    shared actual void onClose(UtWebSocketChannel channel, StreamSourceFrameChannel messageChannel) {
        BufferedBinaryMessage bufferedBinaryMessage = BufferedBinaryMessage();
        bufferedBinaryMessage.readBlocking(messageChannel);

        JByteBuffer buffer = wrapByteBuffer(bufferedBinaryMessage.toByteArray());
        
        if (buffer.remaining() > 2) {
            Integer code = buffer.short;
            String reason = UTF8Output(buffer).extract();
            webSocketEndpoint.onClose(webSocketChannel, CloseReason(code, reason));
        } else {
            webSocketEndpoint.onClose(webSocketChannel, NoReason());
        }
        sendCloseBlocking(bufferedBinaryMessage.data, channel);
    }

    shared actual void onError(UtWebSocketChannel channel, Exception error) {
        webSocketEndpoint.onError(webSocketChannel, error);
        safeClose(channel);
    }
}
