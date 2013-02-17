doc "Asynchronous web endpoint. Enpoint is executed asynchronously.
     End of request proccessing must be signaled by calling completionHandler."
by "Matej Lazar"
shared class WebEndpointAsync(shared String path, shared void service(HttpRequest request, HttpResponse response, CompletionHandler completionHandler)) {
    
    //TODO do we realy need shared method
    shared void callService(HttpRequest request, HttpResponse response, CompletionHandler completionHandler) {
        service(request, response, completionHandler);
    }

    //TODO do we realy need shared method
    shared String getPath() {
        return path;
    }    

}