"""This module defines APIs for defining HTTP endpoints and executing HTTP servers.
   
   A [[ceylon.http.server::Server]] represents a HTTP 
   server. A new `Server` may be defined using 
   [[ceylon.http.server::newServer]].
   
       void runServer() {
           //create a HTTP server
           value server = newServer {
               //an endpoint, on the path /hello
               Endpoint {
                   path = startsWith("/hello");
                   //handle requests to this path
                   service(Request request, Response response) 
                           => response.writeString("hello world");
               },
               WebSocketEndpoint {
                   path = startsWith("/websocket");
                   onOpen(WebSocketChannel channel) 
                           => print("Channel opened");
                   onClose(WebSocketChannel channel, CloseReason closeReason) 
                           => print("Channel closed");
                   void onError(WebSocketChannel webSocketChannel, Exception? throwable) {}
                   void onText(WebSocketChannel channel, String text) {
                       print("Received text:");
                       print(text);
                       channel.sendText(text.uppercased);
                   }
                   void onBinary(WebSocketChannel channel, ByteBuffer binary) {
                       String data = utf8.decode(binary);
                       print("Received binary:");
                       print(data);
                       value encoded = utf8.encode(data.uppercased);
                       channel.sendBinary(encoded);
                   }
               }
           };
   
           //start the server on port 8080
           server.start(SocketAddress("127.0.0.1",8080));
       }"""

by("Stéphane Épardaud", "Matej Lazar")
license("Apache Software License")
native("jvm")
module ceylon.http.server maven:"org.ceylon-lang" "**NEW_VERSION**-SNAPSHOT" {
    
    shared import ceylon.http.common "**NEW_VERSION**-SNAPSHOT";
    shared import ceylon.collection "**NEW_VERSION**-SNAPSHOT";
    shared import ceylon.io "**NEW_VERSION**-SNAPSHOT";
    shared import "com.redhat.ceylon.module-resolver" "**NEW_VERSION**-SNAPSHOT";
    import ceylon.file "**NEW_VERSION**-SNAPSHOT";
    
    // -- java modules --
    
    import java.base "7";
    
    import io.undertow.core "1.4.4.Final";

    import org.jboss.xnio.nio "3.3.6.Final";
    import ceylon.interop.java "**NEW_VERSION**-SNAPSHOT";
    
}
