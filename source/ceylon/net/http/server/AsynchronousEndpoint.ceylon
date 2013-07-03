import ceylon.net.http { Method }
"Asynchronous web endpoint. Enpoint is executed 
 asynchronously. End of request proccessing must be 
 signaled by calling `complete()`."
by("Matej Lazar")
shared class AsynchronousEndpoint(Matcher path, service, {Method+} acceptMethod) 
        extends EndpointBase(path, acceptMethod) {
    
    shared void service(Request request, Response response,
            void complete());
    
}