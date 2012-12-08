import ceylon.net.httpd { WebEndpoint, WebEndpointAsync, WebEndpointConfig}

class WebEndpointConfigInternal(WebEndpointConfig webEndpointConfig) satisfies WebEndpointConfig {

	shared variable WebEndpoint|WebEndpointAsync|Nothing webEndpoint := null;

	shared actual String path {
		return webEndpointConfig.path;
	}
	
	shared actual String className {
		return webEndpointConfig.className;
	}

	shared actual String moduleId {
		return webEndpointConfig.moduleId;
	}

	shared actual void addAttribute(String name, String paramValue) {
		webEndpointConfig.addAttribute(name, paramValue);
	}
	
	shared actual String? attribute(String name) {
		return webEndpointConfig.attribute(name);
	}
		
	shared void setWebEndpoint(WebEndpoint|WebEndpointAsync webEndpoint) {
		this.webEndpoint := webEndpoint;
	}
}