abstract shared class EndpointBase(path) {
    shared Matcher path;

    doc "returns true if method is handled be endpoint."
    shared Boolean acceptMethod(Method method) {
    	return true;
    }
}
