doc "Synchronous web endpoint."
by "Matej Lazar"
shared class Endpoint(path, service) extends EndpointBase(path) {
    
    shared Matcher path;
    
    shared void service(Request request, Response response);
    
}