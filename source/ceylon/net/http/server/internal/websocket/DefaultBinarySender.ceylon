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
class DefaultFragmentedBinarySender(DefaultWebSocketChannel channel)
        satisfies FragmentedBinarySender {

    value fragmentedChannel = channel.underlyingChannel.sendFragmentedBinary();

    sendBinary(ByteBuffer binary, Boolean finalFrame)
            //TODO: is this copy really necessary or can
            //we just send the underlying implementation?
            => wsSendBinaryBlocking(copyToJavaByteBuffer(binary), 
                finalFrame, fragmentedChannel);
    
    sendBinaryAsynchronous(
            ByteBuffer binary,
            Anything(WebSocketChannel) onCompletion,
            Anything(WebSocketChannel,Exception)? onError,
            Boolean finalFrame)
        => wsSendBinary(
            //TODO: is this copy really necessary or can
            //we just send the underlying implementation?
            copyToJavaByteBuffer(binary),
            finalFrame,
            fragmentedChannel,
            wrapFragmentedCallbackSend(onCompletion, onError, channel));
    
}
