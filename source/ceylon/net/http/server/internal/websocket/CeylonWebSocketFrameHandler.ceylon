import java.nio { JByteBuffer=ByteBuffer { wrapByteBuffer=wrap }}
import ceylon.net.http.server.websocket { WebSocketChannel, WebSocketEndpoint, CloseReason, NoReason }
import ceylon.io.buffer { newByteBufferWithData }
import io.undertow.websockets.core { 
    AbstractReceiveListener, 
    BufferedTextMessage, 
    UtWebSocketChannel = WebSocketChannel, 
    BufferedBinaryMessage, 
    WebSockets { sendCloseBlocking }, 
    UTF8Output}
import org.xnio {IoUtils {safeClose}}
import ceylon.interop.java { toIntegerArray }

by("Matej Lazar")
class CeylonWebSocketFrameHandler(WebSocketEndpoint webSocketEndpoint, WebSocketChannel webSocketChannel)
        extends AbstractReceiveListener() {

    shared actual void onFullTextMessage(UtWebSocketChannel channel, BufferedTextMessage message) {
        webSocketEndpoint.onText(webSocketChannel, message.data );
    }

    shared actual void onFullBinaryMessage(UtWebSocketChannel channel, BufferedBinaryMessage message) {
        webSocketEndpoint.onBinary(webSocketChannel, newByteBufferWithData(*toIntegerArray(message.toByteArray())));
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
