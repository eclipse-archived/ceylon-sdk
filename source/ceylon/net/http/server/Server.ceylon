import ceylon.net.http.server.internal { DefaultServer }
import ceylon.net.http.server.websocket { WebSocketEndpoint }

"Ceylon http server."
by("Matej Lazar")
shared interface Server {

    "Define endpoint by providing an instance of [[Endpoint]]|[[AsynchronousEndpoint]] class."
    shared formal void addEndpoint(Endpoint|AsynchronousEndpoint endpoint);

    shared formal void addWebSocketEndpoint(WebSocketEndpoint endpoint);
    
    shared formal void start(Integer port = 8080, 
            String host = "127.0.0.1", 
            Options serverOptions = Options());
    
    "Starts httpd in a new thread."
    shared formal void startInBackground(Integer port = 8080, 
        String host = "127.0.0.1", 
        Options serverOptions = Options());
    
    shared formal void stop();
    
    "Registers a status change listener."
    see(`StatusListener`)
    shared formal void addListener(StatusListener listener);
    
    "Removes status change listener."
    shared formal void removeListener(StatusListener listener);
}

shared Server createServer({Endpoint|AsynchronousEndpoint*} endpoints) {
    Server server = DefaultServer();
    for (endpoint in endpoints) {
        server.addEndpoint(endpoint);
    }
    return server;
} 
