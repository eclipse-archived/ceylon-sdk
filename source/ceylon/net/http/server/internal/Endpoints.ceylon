import ceylon.collection {
    LinkedList
}
import ceylon.net.http.server {
    EndpointBase
}

shared class Endpoints() {

    value _endpoints = LinkedList<EndpointBase>();
    shared {EndpointBase*} endpoints => _endpoints;

    shared void add(EndpointBase endpoint)
        => _endpoints.add(endpoint);

    shared {EndpointBase*} getEndpointMatchingPath(String requestPath) {
        return endpoints.filter((endpoint) {return endpoint.path.matches(requestPath);});
    }
}
