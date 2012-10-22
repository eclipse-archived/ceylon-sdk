import ceylon.collection { HashMap }


shared class WebEndpointConfig(path, moduleName, className, moduleSlot) {

	shared String path;
	shared String moduleName;
	shared String className;
	shared String moduleSlot;
	HashMap<String, String> parameters = HashMap<String, String>();

	shared void addParameter(String name, String paramValue) {
		parameters.put(name, paramValue);
	}

	shared String? parameter(String name) {
		return parameters.item(name); 
	}

}