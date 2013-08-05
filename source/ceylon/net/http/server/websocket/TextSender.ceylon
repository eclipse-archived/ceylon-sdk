by("Matej Lazar")
shared interface FragmentedTextSender {

    shared formal void sendText(String payload, Boolean finalFrame = false);

    shared formal void sendTextAsynchronous(String payload, SendCallback? sendCallback, Boolean finalFrame = false);
}
