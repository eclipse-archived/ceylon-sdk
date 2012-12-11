import ceylon.net.httpd.internal { DefaultHttpdServer }

by "Matej Lazar"
shared interface Httpd {
	
	doc "Not implemented yet! Use addWebEndpointConfig."
	shared formal void loadWebEndpointConfig(String? moduleId = null, String pathToModuleConfig = "web.properties");

	doc "Not implemented yet! Use addWebEndpointConfig. Scan for endpoint configs."
	shared formal void scan();
	
	shared formal void addWebEndpointConfig(WebEndpointConfig webEndpointConfig);
	
	shared formal void start(Integer port = 8080, String host = "127.0.0.1", HttpdOptions httpdOptions = HttpdOptions());
	
}

shared Httpd newInstance() = DefaultHttpdServer;