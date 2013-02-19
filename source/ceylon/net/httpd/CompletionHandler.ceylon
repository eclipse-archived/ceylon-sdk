by "Matej Lazar"
doc "The handler which is called when an {@link CeylonRequestHandler} has completely finished processing a request.
     The handler may be called from the same thread as the request handler's original execution, or a different thread."
shared interface CompletionHandler {
    
    doc "Signify completion of the request handler's execution."
    shared formal void handleComplete();
}