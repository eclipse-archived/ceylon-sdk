import ceylon.io { SocketAddress }
shared interface HttpRequest {

	shared formal String? parameter(String name);

	shared formal String[]|Empty parameters(String name);
	
	shared formal String? header(String name);

	shared formal String[] headers(String name);

    doc "Get the HTTP request method. {OPTIONS, GET, HEAD, POST, PUT, DELETE, TRACE, CONNECT}"
    shared formal String method();

	doc "Get the request URI scheme. {http, https}"
    shared formal String scheme();

    doc "Gets the request URI, including hostname, protocol etc if specified by the client."
    shared formal String uri();

	doc "Get the request URI path.  This is the whole original request path."
    shared formal String path();

	doc "Return path relative to endpoint mapping path."
	shared formal String relativePath();

    shared formal String queryString();

    doc "Get the source address of the HTTP request."
    shared formal SocketAddress sourceAddress();

    doc "Get the destination address of the HTTP request."
    shared formal SocketAddress destinationAddress();

	shared formal String? mimeType();
 
}