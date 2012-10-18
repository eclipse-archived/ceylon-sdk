shared interface HttpResponse {

	shared formal void writeString(String string);
	shared formal void writeBytes(Array<Integer> bytes);

	shared formal void addHeader(String headerName, String headerValue);
	shared formal void responseDone();
	
	shared formal void responseStatus(Integer responseStatusCode);
}
