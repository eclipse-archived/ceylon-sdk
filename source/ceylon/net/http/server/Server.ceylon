import ceylon.net.http.server.internal { DefaultServer }
import ceylon.net.http.server.websocket { WebSocketEndpoint, WebSocketFragmentedEndpoint }

"Ceylon http server."
by("Matej Lazar")
see(`function createServer`)
shared interface Server {

    "Define endpoint by providing an instance of [[Endpoint]]|[[AsynchronousEndpoint]] class."
    shared formal void addEndpoint(HttpEndpoint endpoint);

    shared formal void addWebSocketEndpoint(WebSocketEndpoint endpoint);
    
    shared formal void start(Integer port = 8080, //TODO use SocketAddress 
            String host = "127.0.0.1", 
            Options serverOptions = Options());
    
    "Starts httpd in a new thread."
    shared formal void startInBackground(Integer port = 8080, 
        String host = "127.0.0.1", 
        Options serverOptions = Options());
    
    shared formal void stop();
    
    "Registers a status change listener."
    see(`interface StatusListener`)
    shared formal void addListener(StatusListener listener);
    
    "Removes status change listener."
    shared formal void removeListener(StatusListener listener);
}

shared Server createServer({Endpoint|AsynchronousEndpoint|WebSocketEndpoint|WebSocketFragmentedEndpoint*} endpoints) {
    Server server = DefaultServer();
    for (endpoint in endpoints) {
        switch(endpoint)
        case (is WebSocketEndpoint) {
            server.addWebSocketEndpoint(endpoint);
        }
        case (is HttpEndpoint) {
            server.addEndpoint(endpoint);
        }
        else {
            //TODO remove all cases are handled
        }
    }
    return server;
} 
