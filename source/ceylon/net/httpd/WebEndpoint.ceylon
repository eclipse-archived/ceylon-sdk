doc "Synchronous web endpoint."
by "Matej Lazar"
shared class WebEndpoint(path, service) {
    
    shared String path;
    
    shared void service(Request request, Response response);
    
}