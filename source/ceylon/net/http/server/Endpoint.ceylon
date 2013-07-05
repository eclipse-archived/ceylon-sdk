import ceylon.net.http { Method }
"Synchronous web endpoint."
by("Matej Lazar")
shared class Endpoint(Matcher path, service, {Method*} acceptMethod)  
        extends EndpointBase(path, acceptMethod) {
    
    shared void service(Request request, Response response);
    
}