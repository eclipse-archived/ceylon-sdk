import ceylon.buffer {
    ByteBuffer
}
import ceylon.http.server.websocket {
    WebSocketChannel,
    WebSocketEndpoint
}

import io.undertow.websockets.core {
    BufferedTextMessage,
    UtWebSocketChannel=WebSocketChannel,
    BufferedBinaryMessage
}

import java.nio {
    JByteBuffer=ByteBuffer
}
import java.lang {
    ObjectArray
}
import org.xnio {
    Pooled
}
import ceylon.http.server.internal {
    toCeylonByteBuffer,
    mergeBuffers
}


by("Matej Lazar")
class CeylonWebSocketFrameHandler(WebSocketEndpoint webSocketEndpoint, WebSocketChannel webSocketChannel)
        extends CeylonWebSocketAbstractFrameHandler(webSocketEndpoint, webSocketChannel) {

    shared actual void onFullTextMessage(UtWebSocketChannel channel, BufferedTextMessage message) 
            => webSocketEndpoint.onText(webSocketChannel, message.data );

    shared actual void onFullBinaryMessage(UtWebSocketChannel channel, BufferedBinaryMessage message) {
        Pooled<ObjectArray<JByteBuffer>> data = message.data;
        try {
            ObjectArray<JByteBuffer> jByteBufferArray = data.resource;
            ByteBuffer binary = mergeBuffers{ 
                for (jbb in jByteBufferArray.iterable) toCeylonByteBuffer(jbb) 
            };
            webSocketEndpoint.onBinary(webSocketChannel, binary);
        } catch (Exception e) {
            //TODO handle exception
            e.printStackTrace();
        } finally {
            data.free();
        }
    }
    

}
