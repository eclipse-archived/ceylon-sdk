doc "Synchronous web endpoint."
by "Matej Lazar"
shared class Endpoint(Matcher path, service) 
        extends EndpointBase(path) {
    
    shared void service(Request request, Response response);
    
}