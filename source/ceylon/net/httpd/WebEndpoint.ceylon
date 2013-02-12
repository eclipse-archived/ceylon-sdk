doc "Interface for a synchronous web endpoint."
by "Matej Lazar"
shared interface WebEndpoint satisfies WebEndpointBase {
    
    doc "Method is called by server, when a new request is received."
    see (HttpRequest, HttpResponse)
    shared formal void service(HttpRequest request, HttpResponse response);
    
}