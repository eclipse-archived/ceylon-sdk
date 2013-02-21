doc "Asynchronous web endpoint. Enpoint is executed 
     asynchronously. End of request proccessing must be 
     signaled by calling completionHandler."
by "Matej Lazar"
shared class AsynchronousEndpoint(path, service) extends EndpointBase(path) {
    
    shared Matcher path;
    
    shared void service(Request request, Response response,
            void completionHandler());
    
}