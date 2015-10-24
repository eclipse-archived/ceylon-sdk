import ceylon.net.http.server {
    Request,
    Response
}
import ceylon.net.http {
    Header
}

"Endpoint for HTTP redirection. _Must_ be attached to an
 [[ceylon.net.http.server::AsynchronousEndpoint]].
 
 For example:
 
     shared void run() 
            => newServer {
        AsynchronousEndpoint {
            path = isRoot();
            acceptMethod = { get };
            service = redirect(\"/index.html\");
        }
     };"
shared void redirect(String url)
        (Request request, Response response, void complete()) {
    response.responseStatus = 301;
    response.addHeader(Header("Location", url));
    complete();
}