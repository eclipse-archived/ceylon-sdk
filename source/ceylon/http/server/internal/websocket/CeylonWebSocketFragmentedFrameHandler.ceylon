import ceylon.buffer {
    ByteBuffer
}
import ceylon.http.server.websocket {
    WebSocketChannel,
    WebSocketFragmentedEndpoint
}
import io.undertow.websockets.core {
    BufferedTextMessage,
    UtWebSocketChannel=WebSocketChannel,
    BufferedBinaryMessage,
    StreamSourceFrameChannel
}
import java.nio {
    JByteBuffer=ByteBuffer
}
import ceylon.http.server.internal {
    toCeylonByteBuffer,
    mergeBuffers
}
import java.lang {
    ObjectArray
}
import org.xnio {
    Pooled
}

by("Matej Lazar")
class CeylonWebSocketFragmentedFrameHandler(
    WebSocketFragmentedEndpoint webSocketEndpoint, 
    WebSocketChannel webSocketChannel)
        extends CeylonWebSocketAbstractFrameHandler(webSocketEndpoint, webSocketChannel) {

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

        Pooled<ObjectArray<JByteBuffer>> data = bufferedBinaryMessage.data;
        try {
            ObjectArray<JByteBuffer> jByteBufferArray = data.resource;
            {ByteBuffer*} bbArray = jByteBufferArray.iterable
                    .map((JByteBuffer? element) => toCeylonByteBuffer(element));
            ByteBuffer binary = mergeBuffers(*bbArray);
            webSocketEndpoint.onBinary(webSocketChannel, binary, messageChannel.finalFragment);
        } catch (Exception e) {
            //TODO handle exception
            e.printStackTrace();
        } finally {
            data.free();
        }
    }
}
