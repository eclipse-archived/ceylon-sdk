import ceylon.io.buffer { ByteBuffer }
import ceylon.net.http.server.websocket { WebSocketChannel }

by("Matej Lazar")
shared interface FragmentedBinarySender {

    shared formal void sendBinary(ByteBuffer payload, Boolean finalFrame = false);

    shared formal void sendBinaryAsynchronous(
        ByteBuffer binary,
        Anything(WebSocketChannel) onCompletion,
        Anything(WebSocketChannel,Exception)? onError = null,
        Boolean finalFrame = false);

}
