import ceylon.net.http.server.websocket {
    FragmentedTextSender,
    WebSocketChannel
}

import io.undertow.websockets.core {
    WebSockets {
        wsSendText=sendText,
        wsSendTextBlocking=sendTextBlocking
    }
}

by("Matej Lazar")
class DefaultFragmentedTextSender(DefaultWebSocketChannel channel) 
        satisfies FragmentedTextSender {

    value fragmentedChannel = channel.underlyingChannel.sendFragmentedText();

    sendText(String text, Boolean finalFrame) 
            => wsSendTextBlocking(text, finalFrame, fragmentedChannel);
    
    sendTextAsynchronous(String text,
        Anything(WebSocketChannel) onCompletion,
        Anything(WebSocketChannel,Exception)? onError,
        Boolean finalFrame) 
            => wsSendText(text, finalFrame, fragmentedChannel, 
                    wrapFragmentedCallbackSend(onCompletion, onError, channel));
}
