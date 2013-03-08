doc "Asynchronous web endpoint. Enpoint is executed 
     asynchronously. End of request proccessing must be 
     signaled by calling `complete()`."
by "Matej Lazar"
shared class AsynchronousEndpoint(Matcher path, service) 
        extends EndpointBase(path) {
    
    shared void service(Request request, Response response,
            void complete());
    
}