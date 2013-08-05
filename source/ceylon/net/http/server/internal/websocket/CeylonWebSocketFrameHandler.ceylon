import java.nio { JByteBuffer = ByteBuffer }
import ceylon.net.http.server.websocket { WebSocketChannel, WebSocketEndpoint, CloseReason, NoReason }
import ceylon.io.buffer { newByteBufferWithData }
import io.undertow.websockets.core { 
    AbstractReceiveListener, 
    BufferedTextMessage, 
    UtWebSocketChannel = WebSocketChannel, 
    BufferedBinaryMessage, 
    WebSockets { sendCloseBlocking }, 
    UTF8Output}
import ceylon.net.http.server.internal {JavaHelper {wrapByteBuffer}}
import org.xnio {IoUtils {safeClose}}

by("Matej Lazar")
class CeylonWebSocketFrameHandler(WebSocketEndpoint webSocketEndpoint, WebSocketChannel webSocketChannel)
        extends AbstractReceiveListener() {

    shared actual void onFullTextMessage(UtWebSocketChannel channel, BufferedTextMessage message) {
        webSocketEndpoint.onText(webSocketChannel, message.data );
    }

    shared actual void onFullBinaryMessage(UtWebSocketChannel channel, BufferedBinaryMessage message) {
        webSocketEndpoint.onBinary(webSocketChannel, newByteBufferWithData(*message.toByteArray().array));
    }

    shared actual void onFullCloseMessage(UtWebSocketChannel channel, BufferedBinaryMessage message) {
        JByteBuffer buffer = wrapByteBuffer(message.toByteArray());

        if (buffer.remaining() > 2) {
            Integer code = buffer.short;
            String reason = UTF8Output(buffer).extract();
            webSocketEndpoint.onClose(webSocketChannel, CloseReason(code, reason));
        } else {
            webSocketEndpoint.onClose(webSocketChannel, NoReason());
        }
        sendCloseBlocking(message.data, channel);
    }

    shared actual void onError(UtWebSocketChannel channel, Exception error) {
        webSocketEndpoint.onError(webSocketChannel, error);
        safeClose(channel);
    }
}
