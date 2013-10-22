by("Matej Lazar")
shared interface SendCallback {
    
    shared formal void onCompletion(Response response);
    
    shared formal void onError(Response response, Exception exception);
}
