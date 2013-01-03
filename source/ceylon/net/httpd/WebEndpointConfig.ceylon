import ceylon.net.httpd.internal { DefaultWebEndpointConfig }

by "Matej Lazar"
shared interface WebEndpointConfig {
	
	shared formal String path;
	
	shared formal String className;

	shared formal String moduleId;

	shared formal void addAttribute(String name, String paramValue);

	shared formal String? attribute(String name);
}

shared WebEndpointConfig newConfig(String path, String className, String moduleId) {
	return DefaultWebEndpointConfig(path, className, moduleId);
}