by("Matej Lazar")
shared interface FragmentedTextSender {

    shared formal void sendText(
        String payload, 
        Boolean finalFrame = false);

    shared formal void sendTextAsynchronous(
        String text,
        Anything(WebSocketChannel) onCompletion,
        Anything(WebSocketChannel,Exception)? onError = null,
        Boolean finalFrame = false);

}
