import ceylon.net.http.server.websocket { FragmentedTextSender, SendCallback }
import io.undertow.websockets.core {
    WebSockets {
        wsSendText = sendText,
        wsSendTextBlocking = sendTextBlocking }}

by("Matej Lazar")
shared class DefaultFragmentedTextSender(DefaultWebSocketChannel channel) 
        satisfies FragmentedTextSender {

    value fragmentedChannel = channel.underlyingChannel.sendFragmentedText();

    shared actual void sendText(String text, Boolean finalFrame) {
        wsSendTextBlocking(text, finalFrame, fragmentedChannel);
    }

    shared actual void sendTextAsynchronous(String text, SendCallback? sendCallback, Boolean finalFrame) {
        wsSendText(text, finalFrame, fragmentedChannel, wrapFragmentedCallbackSend(sendCallback, channel));
    }
}
