import ceylon.net.http { Method }
abstract shared class EndpointBase(path) {
    shared Matcher path;

    "returns true if method is handled by endpoint."
    shared Boolean acceptMethod(Method method) {
    	return true;
    }
}
