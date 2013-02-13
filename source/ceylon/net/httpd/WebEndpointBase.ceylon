by "Matej Lazar"
shared interface WebEndpointBase {
    
    doc "Method is called when web endpoint is accessed for the first time."
    shared formal void init(WebEndpointConfig webEndpointConfig);
    
}