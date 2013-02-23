abstract shared class EndpointBase(Matcher path) {
    
    shared Boolean pathMatches(String url) => path.matches(url);
    
    shared String relativePath(String requestPath) {
        variable value relativePath = requestPath;
        value rules = path.findStartRulesMatching(requestPath);
        for(rule in rules) {
            value mappingPath = rule.string; 
            if (relativePath.startsWith(mappingPath)) {
                relativePath = relativePath[mappingPath.size...];
            }
        }
        return relativePath;
    }
}
