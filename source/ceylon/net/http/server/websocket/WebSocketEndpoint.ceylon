import ceylon.net.http.server { Matcher, EndpointBase }
import ceylon.io.buffer { ByteBuffer }

void noop() {}

by("Matej Lazar")
shared abstract class WebSocketBaseEndpoint(Matcher path, 
					    onOpen = (WebSocketChannel channel) => noop(),
					    onClose = (WebSocketChannel channel, CloseReason closeReason) => noop(), 
					    onError = (WebSocketChannel channel, Throwable? throwable) => noop())
        of WebSocketEndpoint | WebSocketFragmentedEndpoint
        extends EndpointBase(path) {

    shared void onOpen(WebSocketChannel channel);

    shared void onClose(WebSocketChannel channel, CloseReason closeReason);

    shared void onError(WebSocketChannel channel, Throwable? throwable);
}

shared class WebSocketEndpoint(
            Matcher path,
            void onOpen(WebSocketChannel channel) => noop(),
            void onClose(WebSocketChannel channel, CloseReason closeReason) => noop(),
            void onError(WebSocketChannel channel, Throwable? throwable) => noop(),
            onText = (WebSocketChannel channel, String text) => noop(),
            onBinary = (WebSocketChannel channel, ByteBuffer binary) => noop())	
        extends WebSocketBaseEndpoint(path, onOpen, onClose, onError) {

    shared void onText(WebSocketChannel channel, String text);

    shared void onBinary(WebSocketChannel channel, ByteBuffer binary);
}

shared class WebSocketFragmentedEndpoint(Matcher path,
            void onOpen(WebSocketChannel channel) => noop(),
            void onClose(WebSocketChannel channel, CloseReason closeReason) => noop(),
            void onError(WebSocketChannel channel, Throwable? throwable) => noop(),
	    onText = (WebSocketChannel channel, String text, Boolean finalFragment) => noop(),
	    onBinary = (WebSocketChannel channel, ByteBuffer binary, Boolean finalFragment) => noop())
        extends WebSocketBaseEndpoint(path, onOpen, onClose, onError) {

    shared void onText(WebSocketChannel channel, String text, Boolean finalFragment);

    shared void onBinary(WebSocketChannel channel, ByteBuffer binary, Boolean finalFragment);
}
