import ceylon.net.http { Header }
doc "An object to assist sending response to the client."
by "Matej Lazar"
shared interface Response {
    
    doc "Writes string to the response."
    shared formal void writeString(String string);
    
    doc "Writes bytes to the response."
    shared formal void writeBytes(Array<Integer> bytes);
    
    doc "Add a header to response. Multiple headers can have the same name."
    shared formal void addHeader(Header header);
    
    doc "The HTTP status code of the response."
    shared formal variable Integer responseStatus;
    
}
