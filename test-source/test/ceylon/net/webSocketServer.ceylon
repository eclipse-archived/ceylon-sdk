import java.net { URI }
import test.ceylon.net.websocketclient { WebSocketClient }
import ceylon.net.http.server.websocket { WebSocketChannel, CloseReason, WebSocketEndpoint }
import ceylon.test { assertTrue, assertEquals, test }
import ceylon.net.http.server { startsWith, started, Status, stopped, newServer }
import ceylon.io.buffer { ByteBuffer }
import io.netty.channel.nio { NioEventLoopGroup }
import io.netty.channel { EventLoopGroup }
import ceylon.io.charset { utf8 }
import io.netty.handler.codec.http.websocketx { WebSocketHandshakeException }

by("Matej Lazar")
test void testWebSocketServer() {
    
    value server = newServer {};

    variable Integer messagesReceived = 0;
    
    void onOpen(WebSocketChannel channel) {
        //TODO log
        print("server: Channel opened.");
        assertTrue(channel.open(), "Channel should be open.");
    }
    
    void onClose(WebSocketChannel channel, CloseReason closeReason) {
        assertEquals(10, messagesReceived, "Invalid number of received messages.");
        
        //TODO log
        print("server: Closing channel...");
    }
    
    void onError(WebSocketChannel webSocketChannel, Exception? throwable) {
        //TODO
    }

    server.addWebSocketEndpoint(WebSocketEndpoint {
        path = startsWith("/websocket");
        onOpen => onOpen;
        onClose => onClose;
        onError => onError;
        onText = void (WebSocketChannel channel, String text) {
            print("Server received: ``text``");
            assertEquals("Message #``messagesReceived.string``", text);
            messagesReceived++;
            channel.sendText(text.uppercased);
        };
        onBinary = void (WebSocketChannel channel, ByteBuffer binary) {
            String data = utf8.decode(binary);
            print("Server received binary message: ``data``");
            value encoded = utf8.encode(data.uppercased);
            channel.sendBinary(encoded);
        };}
    );
    
    void onStatusChange(Status status) {
        if (status.equals(started)) {
            try {
                URI uri = URI("ws://localhost:8080/websocket");
                EventLoopGroup group = NioEventLoopGroup(); 

                try {
                    value client = WebSocketClient(uri);
                    client.connect(group);
                    client.sendMessages();
                    client.sendBinaryMessages();
                    client.sendPing();
                    client.sendClose();

                    client.waitForClose();

                    value client2 = WebSocketClient(URI("ws://localhost:8080/notfoundwebsocket"));
                    variable String exception = "";
                    try {
                        client2.connect(group);
                    } catch (WebSocketHandshakeException e) {
                        exception = e.message;
                    }
                    if (!exception.contains("404 Not Found")) {
                        throw AssertionException("Expected WebSocketHandshakeException with 404 Not Found.");
                    }
                } finally {
                    group.shutdownGracefully();
                }
            } finally {
                print("Stopping http server ...");
                server.stop();
            }
        }
        if (status.equals(stopped)) {
            testCompleted();
        }
    }
    server.addListener(onStatusChange);
    server.startInBackground();
    waitTestToComplete();
}
