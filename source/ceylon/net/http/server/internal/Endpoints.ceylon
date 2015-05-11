import ceylon.collection {
    LinkedList
}
import ceylon.net.http.server {
    EndpointBase
}

shared class Endpoints() {

    value endpoints = LinkedList<EndpointBase>();

    shared void add(EndpointBase endpoint) 
            => endpoints.add(endpoint);

    shared {EndpointBase*} getEndpointMatchingPath(String requestPath) {
        return endpoints.filter((endpoint) {return endpoint.path.matches(requestPath);});
    }
}
