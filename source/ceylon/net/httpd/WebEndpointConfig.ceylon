import ceylon.net.httpd.internal { DefaultWebEndpointConfig }

doc "Configuration of a web endpoint, it is used to register a web endpoint."
by "Matej Lazar"
shared interface WebEndpointConfig {
    
    doc "Url path mapping."
    shared formal String path;
    
    doc "web endpoint class name. Class must implement WebEndpoint or WebEnpointAsync"
    see (WebEndpoint, WebEndpointAsync)
    shared formal String className;
    
    doc "Id of a module containing a given web endpoint class."
    shared formal String moduleId;
    
    doc "Method to add endpoint configuration attribute that can be read in enpoints init method."
    see (WebEndpointBase)
    shared formal void addAttribute(String name, String paramValue);
    
    doc "Method to read web endpoint attribute."
    shared formal String? attribute(String name);
}

shared WebEndpointConfig newConfig(String path, String className, String moduleId) {
    return DefaultWebEndpointConfig(path, className, moduleId);
}