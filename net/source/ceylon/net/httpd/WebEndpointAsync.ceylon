shared interface WebEndpointAsync satisfies WebEndpointBase {
	
	shared formal void service(HttpRequest request, HttpResponse response, HttpCompletionHandler completionHandler);
	
}