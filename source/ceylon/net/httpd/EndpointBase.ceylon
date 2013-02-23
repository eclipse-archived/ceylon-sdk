abstract shared class EndpointBase(Matcher path) {
    
    shared Boolean pathMatches(String url) => path.matches(url);
    
    shared String relativePath(String requestPath) => path.relativePath(requestPath);
}
