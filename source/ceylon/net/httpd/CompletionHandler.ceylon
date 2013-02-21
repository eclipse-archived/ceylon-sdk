by "Matej Lazar"
doc "The handler which is called when a [[WebEndpointAsync]] 
     has completely finished processing a request. The handler 
     may be called from the same thread as the request handler's 
     original execution, or a different thread."
shared interface Completion {
    
    doc "Signify completion of the request handler's execution."
    shared formal void complete();
    
}