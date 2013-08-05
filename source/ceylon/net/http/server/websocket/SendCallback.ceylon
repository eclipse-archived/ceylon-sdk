by("Matej Lazar")
shared interface SendCallback {

    shared formal void onCompletion(WebSocketChannel webSocketChannel);

    shared formal void onError(WebSocketChannel webSocketChannel, Exception exception);
}
