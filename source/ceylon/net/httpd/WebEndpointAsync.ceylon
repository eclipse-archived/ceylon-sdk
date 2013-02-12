doc "Interface for an asynchronous web endpoint.
     Enpoint implementing this interface will be executed asynchronously.
     End of request proccessing must be signaled by calling completionHandler."
by "Matej Lazar"
shared interface WebEndpointAsync satisfies WebEndpointBase {
    
    doc "Method is called by server, when new request is received."
    see (HttpRequest, HttpResponse, HttpCompletionHandler)
    shared formal void service(HttpRequest request, HttpResponse response, HttpCompletionHandler completionHandler);
    
}