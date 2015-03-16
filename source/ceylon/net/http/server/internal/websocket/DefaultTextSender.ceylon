import ceylon.net.http.server.websocket {
    FragmentedTextSender,
    WebSocketChannel
}

import io.undertow.websockets.core {
    WebSockets {
        wsSendText=sendText,
        wsSendTextBlocking=sendTextBlocking,
        wsSendClose=sendClose,
        wsSendCloseBlocking=sendCloseBlocking
    },
    WebSocketFrameType
}
import java.nio {
    JByteBuffer=ByteBuffer
}
import ceylon.io.charset {
    utf8
}

by("Matej Lazar")
class DefaultFragmentedTextSender(DefaultWebSocketChannel channel) 
        satisfies FragmentedTextSender {

    value fragmentedChannel = channel.underlyingChannel.send(WebSocketFrameType.\iTEXT);
    
    shared actual void sendText(String text, Boolean finalFrame) {
        value wsChannel = fragmentedChannel.webSocketChannel;
        if (finalFrame) {
            Object? jByteBuffer = utf8.encode(text).implementation;
            if (is JByteBuffer jByteBuffer) {
                wsSendCloseBlocking(jByteBuffer , wsChannel);
            } else {
                //TODO shouldn't be here
            }
        } else {
            wsSendTextBlocking(text, wsChannel);
        }
    }
    
    shared actual void sendTextAsynchronous(String text,
            Anything(WebSocketChannel) onCompletion,
            Anything(WebSocketChannel,Exception)? onError,
            Boolean finalFrame) {
        
        value wsChannel = fragmentedChannel.webSocketChannel;
        
        if (finalFrame) {
            Object? jByteBuffer = utf8.encode(text).implementation;
            if (is JByteBuffer jByteBuffer) {
                wsSendClose(jByteBuffer , wsChannel, wrapCallbackSend(onCompletion, onError, channel));
            } else {
                //TODO shouldn't be here
            }
        } else {
            wsSendText(text, wsChannel, wrapCallbackSend(onCompletion, onError, channel));
        }
    }

}
