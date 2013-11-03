import ceylon.io.buffer { ByteBuffer }

by("Matej Lazar")
shared interface WebSocketChannel {

    "Idle timeout in milliseconds for this WebSocketSession. 
     The session will be closed if nothing was received or send in this time.
     If smaller then 1 no timeout is used."
    shared formal Number idleTimeout;

    "Return true if the session is open and connected"
    shared formal Boolean open();

    "Return true if a close frame has been recieved"
    shared formal Boolean closeFrameReceived;

    shared formal void sendBinary(ByteBuffer binary);

    shared formal void sendBinaryAsynchronous(
            ByteBuffer binary,
            Callable<Anything, [WebSocketChannel]> onCompletion,
            Callable<Anything, [WebSocketChannel, Exception]>? onError = null);

    "Send the a text websocket frame and blocks until complete.
     The implementation is responsible to queue them up and send them in the correct order.
     
     The payload must be valid UTF8."
    shared formal void sendText(String text);

    "Send a text websocket frame and notify the SendCallback once done.
     It is possible to send multiple frames at the same time even if the SendCallback is not triggered yet.
     The implementation is responsible to queue them up and send them in the correct order.
     
     The payload which must be valid UTF8.
     The callback is called when sending is done, use without sendCallback if no notification should be done."
    shared formal void sendTextAsynchronous(
            String text,
            Callable<Anything, [WebSocketChannel]> onCompletion,
            Callable<Anything, [WebSocketChannel, Exception]>? onError = null);

    "Send the a CLOSE websocket frame and notify the `SendCallback` once done.
     After the CLOSE is sent the connections will be closed.
     The `callback` that is called when sending is done or `null` if no notification
     should be done."
    shared formal void sendCloseAsynchronous(
            CloseReason reason,
            Callable<Anything, [WebSocketChannel]> onCompletion,
            Callable<Anything, [WebSocketChannel, Exception]>? onError = null);

    "Send the a CLOSE websocket frame and blocks until complete.
     After the CLOSE is sent the connections will be closed."
    shared formal void sendClose(CloseReason reason);

    shared formal FragmentedBinarySender fragmentedBinarySender();

    shared formal FragmentedTextSender fragmentedTextSender();

    shared formal String schema;

    shared formal String hostname;

    shared formal String requestPath;

}
