shared interface WebEndpoint {
	
	shared formal void service(HttpRequest request, HttpResponse response);
}