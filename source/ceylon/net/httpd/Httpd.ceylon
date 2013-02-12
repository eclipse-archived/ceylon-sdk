import ceylon.net.httpd.internal { DefaultHttpdServer }

by "Matej Lazar"
doc "Ceylon http server."
shared interface Httpd {

    doc "Not implemented yet! Use addWebEndpointConfig."
    shared formal void loadWebEndpointConfig(String? moduleId = null, String pathToModuleConfig = "web.properties");
    
    doc "Not implemented yet! Use addWebEndpointConfig. Scan for endpoint configs."
    shared formal void scan();
    
    doc "Define webEndpoint by providing an instance of WebEndpointConfig class."
    shared formal void addWebEndpointConfig(WebEndpointConfig webEndpointConfig);
    
    shared formal void start(Integer port = 8080, String host = "127.0.0.1", HttpdOptions httpdOptions = HttpdOptions());

    doc "Starts httpd in new thread."
    shared formal void startInBackground(Integer port = 8080, String host = "127.0.0.1", HttpdOptions httpdOptions = HttpdOptions());
    
    shared formal void stop();
    
    doc "Registers a status change listener."
    see (HttpdStatusListerner)
    shared formal void addListener(HttpdStatusListerner listener);
    
    doc "Removes status change listener."
    shared formal void removeListener(HttpdStatusListerner listener);

}

shared Httpd newInstance() => DefaultHttpdServer();