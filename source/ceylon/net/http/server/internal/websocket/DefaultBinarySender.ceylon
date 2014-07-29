import ceylon.io.buffer {
    ByteBuffer
}
import ceylon.net.http.server.websocket {
    FragmentedBinarySender,
    WebSocketChannel
}

import io.undertow.websockets.core {
    WebSockets {
        wsSendBinary=sendBinary,
        wsSendBinaryBlocking=sendBinaryBlocking
    }
}

by("Matej Lazar")
shared class DefaultFragmentedBinarySender(DefaultWebSocketChannel channel)
        satisfies FragmentedBinarySender {

    value fragmentedChannel = channel.underlyingChannel.sendFragmentedBinary();

    shared actual void sendBinary(ByteBuffer binary, Boolean finalFrame) {
        wsSendBinaryBlocking(createJavaByteBuffer(binary), 
            finalFrame, fragmentedChannel);
    }
    
    shared actual void sendBinaryAsynchronous(
            ByteBuffer binary,
            Anything(WebSocketChannel) onCompletion,
            Anything(WebSocketChannel,Exception)? onError,
            Boolean finalFrame) {

        wsSendBinary(
            createJavaByteBuffer(binary),
            finalFrame,
            fragmentedChannel,
            wrapFragmentedCallbackSend(onCompletion, onError, channel));
    }
}
