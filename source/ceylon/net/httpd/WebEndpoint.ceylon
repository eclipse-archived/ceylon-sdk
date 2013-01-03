doc "Interface of synchroneus endpoint implementation."
by "Matej Lazar"
shared interface WebEndpoint satisfies WebEndpointBase {
	
	shared formal void service(HttpRequest request, HttpResponse response);
	
}