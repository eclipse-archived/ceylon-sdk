"""This module defines APIs for:
   
   - representing and manipulating URIs, 
   - connecting to HTTP servers, and 
   - defining HTTP endpoints and executing HTTP servers.
   
   The [[ceylon.net.uri::Uri]] class supports connection 
   to an HTTP URI. A new `Uri` may be obtained using
   [[ceylon.net.uri::parse]].
   
       void getit(String uriAsString) {
           URI uri = parse(uriAsString);
           Request request = uri.get();
           Response response = request.execute();
           print(response.contents);
       }
   
   A [[ceylon.net.http.server::Server]] represents a HTTP 
   server. A new `Server` may be defined using 
   [[ceylon.net.http.server::newServer]].
   
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

by("Stéphane Épardaud, Matej Lazar")
license("Apache Software License")
module ceylon.net "1.0.1" {
    shared import ceylon.collection "1.0.0";
    shared import ceylon.io "1.0.0";
    import ceylon.file "1.0.0";

    import java.base "7";
    
    // -- java modules --
    import io.undertow.core "1.0.0.Beta20";

    import "org.jboss.xnio.api" "3.1.0.CR7";
    import "org.jboss.xnio.nio" "3.1.0.CR7";
    import ceylon.interop.java "1.0.0";
    
    //TODO remove transitive dependency
    //import org.jboss.logging "3.1.2.GA";
}
