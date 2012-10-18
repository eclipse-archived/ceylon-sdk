shared interface WebEndpointAsync {
	shared formal void service(HttpRequest request, HttpResponse response, HttpCompletionHandler completionHandler);
}