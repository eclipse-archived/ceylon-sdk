import ceylon.collection { HashMap }
import ceylon.net.httpd.internal { WebEndpointConfigParser }
import ceylon.net.httpd { WebEndpointConfig }

shared List<WebEndpointConfig> parseWebEndpointConfig(String moduleId, String pathToModuleConfig) {
	WebEndpointConfigParser webEndpointConfigParser = WebEndpointConfigParser(moduleId, pathToModuleConfig);
	return webEndpointConfigParser.parse();
}


shared class DefaultWebEndpointConfig(path, className, moduleId) satisfies WebEndpointConfig {

	shared actual String path;
	shared actual String className;
	shared actual String moduleId;
	
	HashMap<String, String> attributes = HashMap<String, String>();

	shared actual void addAttribute(String name, String paramValue) {
		attributes.put(name, paramValue);
	}

	shared actual String? attribute(String name) {
		return attributes.item(name); 
	}
	
}