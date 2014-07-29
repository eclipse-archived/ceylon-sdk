import ceylon.net.http.server.websocket { FragmentedBinarySender, WebSocketChannel }
import ceylon.io.buffer { ByteBuffer }
import ceylon.net.http.server.internal { toJavaByteBuffer }
import io.undertow.websockets.core { FragmentedMessageChannel,
    WebSockets {
        wsSendBinary = sendBinary,
        wsSendBinaryBlocking = sendBinaryBlocking }}

by("Matej Lazar")
shared class DefaultFragmentedBinarySender( DefaultWebSocketChannel channel )
        satisfies FragmentedBinarySender {

    FragmentedMessageChannel fragmentedChannel = channel.underlyingChannel.sendFragmentedBinary();

    shared actual void sendBinary(ByteBuffer binary, Boolean finalFrame) {
        wsSendBinaryBlocking(toJavaByteBuffer(binary), finalFrame, fragmentedChannel);
    }
    
    shared actual void sendBinaryAsynchronous(
            ByteBuffer binary,
            Anything(WebSocketChannel) onCompletion,
            Anything(WebSocketChannel,Exception)? onError,
            Boolean finalFrame) {

        wsSendBinary(
            toJavaByteBuffer(binary),
            finalFrame,
            fragmentedChannel,
            wrapFragmentedCallbackSend(onCompletion, onError, channel));
    }
}
