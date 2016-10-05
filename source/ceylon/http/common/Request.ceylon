import ceylon.uri { Uri }

"Common interface of an HTTP Request."
shared interface Request {

    "URI of the HTTP Request"
    shared formal Uri uri;

    "The HTTP request method.
     {OPTIONS, GET, HEAD, POST, PUT, DELETE, TRACE, CONNECT}"
    shared formal Method method;

    "The HTTP request headers."
    shared formal Headers headers;

    "Request headers.
     "
    shared interface Headers satisfies {Header*} & Correspondence<String, Header[]> {
        shared formal MediaType[] accept;
        shared formal MediaType? contentType;
    }

    "Content-Type (MIME Type) of the HTTP request"
    shared formal MediaType contentType;

}