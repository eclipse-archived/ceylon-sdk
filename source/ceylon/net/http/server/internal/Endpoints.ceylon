import ceylon.collection {
    LinkedList
}
import ceylon.net.http.server {
    EndpointBase,
	TemplateEndpoint
}

shared class Endpoints() {

    value endpoints = LinkedList<EndpointBase>();
    value _templateEndpoints = LinkedList<TemplateEndpoint>();
    shared {TemplateEndpoint*} templateEndpoints => _templateEndpoints;

    shared void add(EndpointBase endpoint) {
        if (is TemplateEndpoint endpoint) {
            _templateEndpoints.add(endpoint);
        }
        else {
            endpoints.add(endpoint);
        }
    }

    shared {EndpointBase*} getEndpointMatchingPath(String requestPath) {
        return endpoints.filter((endpoint) {return endpoint.path.matches(requestPath);});
    }
}
