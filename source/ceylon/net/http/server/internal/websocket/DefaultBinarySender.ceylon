import ceylon.net.http.server.websocket { FragmentedBinarySender, SendCallback }
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
    
    shared actual void sendBinaryAsynchronous(ByteBuffer binary, SendCallback? sendCallback, Boolean finalFrame) {
        wsSendBinary(toJavaByteBuffer(binary), finalFrame, fragmentedChannel, wrapFragmentedCallbackSend(sendCallback, channel));
    }
}
