shared interface HttpRequest {

	shared formal String url();
	shared formal String path();
	
	shared formal String? parameter(String name);
	shared formal String? header(String name);
	shared formal String[] headers(String name);

}