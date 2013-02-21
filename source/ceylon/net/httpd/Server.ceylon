import ceylon.net.httpd.internal { DefaultServer }

by "Matej Lazar"
doc "Ceylon http server."
shared interface Server {

    doc "Define webEndpoint by providing an instance of WebEndpointConfig class."
    shared formal void addEndpoint(Endpoint|AsynchronousEndpoint endpoint);
    
    shared formal void start(Integer port = 8080, 
            String host = "127.0.0.1", 
            Options httpdOptions = Options());
    
    doc "Starts httpd in a new thread."
    shared formal void startInBackground(Integer port = 8080, 
        String host = "127.0.0.1", 
        Options httpdOptions = Options());
    
    shared formal void stop();
    
    doc "Registers a status change listener."
    see (StatusListener)
    shared formal void addListener(StatusListener listener);
    
    doc "NOT IMPLMENTED YET! Removes status change listener."
    shared formal void removeListener(StatusListener listener);
    
}

shared Server createServer({Endpoint|AsynchronousEndpoint*} endpoints) {
    Server server = DefaultServer();
    for (endpoint in endpoints) {
        server.addEndpoint(endpoint);
    }
    return server;
} 
