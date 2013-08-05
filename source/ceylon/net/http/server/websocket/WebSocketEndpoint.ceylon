import ceylon.net.http.server { Matcher, EndpointBase }
import ceylon.io.buffer { ByteBuffer }

by("Matej Lazar")
shared abstract class WebSocketBaseEndpoint(Matcher path, onOpen, onClose, onError)
        extends EndpointBase(path) {

    shared void onOpen(WebSocketChannel channel);

    shared void onClose(WebSocketChannel channel, CloseReason closeReason);

    shared void onError(WebSocketChannel channel, Exception? throwable);
}

shared class WebSocketEndpoint(
            Matcher path,
            void onOpen(WebSocketChannel channel),
            void onClose(WebSocketChannel channel, CloseReason closeReason),
            void onError(WebSocketChannel channel, Exception? throwable),
            onText,
            onBinary)
        extends WebSocketBaseEndpoint(path, onOpen, onClose, onError) {

    shared void onText(WebSocketChannel channel, String text);

    shared void onBinary(WebSocketChannel channel, ByteBuffer binary);
}

shared class WebSocketFragmentedEndpoint(Matcher path,
            void onOpen(WebSocketChannel channel),
            void onClose(WebSocketChannel channel, CloseReason closeReason),
            void onError(WebSocketChannel channel, Exception? throwable),
            onText,
            onBinary)
        extends WebSocketBaseEndpoint(path, onOpen, onClose, onError) {

    shared void onText(WebSocketChannel channel, String text, Boolean finalFragment);

    shared void onBinary(WebSocketChannel channel, ByteBuffer binary, Boolean finalFragment);
}
