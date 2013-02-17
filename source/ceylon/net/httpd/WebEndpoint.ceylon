doc "Synchronous web endpoint."
by "Matej Lazar"
shared class WebEndpoint(String path, void service(HttpRequest request, HttpResponse response)) {

    //TODO do we realy need shared method
    shared void callService(HttpRequest request, HttpResponse response) {
        service(request, response);
    }
    
    //TODO do we realy need shared method
    shared String getPath() {
        return path;
    }
}