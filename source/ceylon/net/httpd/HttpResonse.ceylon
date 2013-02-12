doc "An object to assist sending response to the client."
by "Matej Lazar"
shared interface HttpResponse {
    
    doc "Writes string to the response."
    shared formal void writeString(String string);
    
    doc "Writes bytes to the response."
    shared formal void writeBytes(Array<Integer> bytes);
    
    doc "Add a header to response. Multiple headers can have the same name."
    shared formal void addHeader(String headerName, String headerValue);
    
    doc "Sets http status code to response."
    shared formal void responseStatus(Integer responseStatusCode);
    
}
