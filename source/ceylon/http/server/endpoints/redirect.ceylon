import ceylon.http.server {
    Request,
    Response
}
import ceylon.http.common {
    Header
}

"Endpoint for HTTP redirection. _Must_ be attached to an
 [[ceylon.http.server::AsynchronousEndpoint]].
 
 For example:
 
     shared void run() 
            => newServer {
        AsynchronousEndpoint {
            path = isRoot();
            acceptMethod = { get };
            service = redirect(\"/index.html\");
        }
     };"
shared void redirect(String url, 
        RedirectType type=RedirectType.seeOther)
        (Request request, Response response, void complete()) {
    response.status = type.statusCode;
    response.addHeader(Header("Location", url));
    complete();
}

shared class RedirectType {
    shared Integer statusCode;
    shared new movedPermanently { statusCode=301; }
    shared new seeOther { statusCode=303; }
    shared new temporaryRedirect { statusCode=307; }
    string => statusCode.string;
}