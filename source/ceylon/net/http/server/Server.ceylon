import ceylon.net.http.server.internal { DefaultServer }
import ceylon.net.http.server.websocket { WebSocketBaseEndpoint }
import ceylon.io { SocketAddress }

"Ceylon http server."
by("Matej Lazar")
see(`function newServer`)
shared interface Server {

    shared formal void start(
        SocketAddress socketAddress = SocketAddress("127.0.0.1", 8080), 
        Options serverOptions = Options());
    
    "Starts httpd in a new thread."
    shared formal void startInBackground(
        SocketAddress socketAddress = SocketAddress("127.0.0.1", 8080), 
        Options serverOptions = Options());
    
    shared formal void stop();
    
    "Define endpoint by providing an instance of [[Endpoint]]|[[AsynchronousEndpoint]] class."
    shared formal void addEndpoint(HttpEndpoint endpoint);

    shared formal void addWebSocketEndpoint(WebSocketBaseEndpoint endpoint);

    "Registers a status change listener.
     Listeners are called on status changes. 
     Statuses are: [[starting]], [[started]], [[stopping]], [[stopped]]."
    shared formal void addListener(void listener(Status status));

}

shared Server newServer(
        {HttpEndpoint|WebSocketBaseEndpoint*} endpoints) 
    => DefaultServer(endpoints);
