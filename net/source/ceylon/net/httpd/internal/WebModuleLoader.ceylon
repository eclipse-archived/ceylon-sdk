import ceylon.net.httpd { WebEndpoint, WebEndpointAsync, HttpdException }

import com.redhat.ceylon.javaadapter { ClassLoaderHelper { clCreateInstance = createInstance }}
import ceylon.collection { HashMap }
import java.lang { ClassNotFoundException }

shared class WebModuleLoader() {

	value cache = HashMap<String, WebEndpoint|WebEndpointAsync>(); 

	shared WebEndpoint|WebEndpointAsync instance(String moduleName, String className, String? moduleSlot = null) {
		
		value sb = StringBuilder();
		sb.append(moduleName);
		sb.append(className);
		if (exists moduleSlot) {
			sb.append(moduleSlot);
		}
		String key = sb.string;

		WebEndpoint|WebEndpointAsync|Nothing instance = cache.item(key);
		
		//TODO use synchronized to make shure that WebEndpoint is singleton
		if (exists instance) {
			return instance;
		} else {
			try {
				Object instanceObj = clCreateInstance(this, moduleName, className, moduleSlot);
				if (is WebEndpoint|WebEndpointAsync instanceObj) {
					cache.put(key, instanceObj);
					return instanceObj;
				} else {
					throw HttpdException("Web endpoint does not satisfy WebEndpoint|WebEndpointAsync.");
				}
			} catch(ClassNotFoundException e) {
				throw HttpdException("Web endpoint class " className " not found.");
			}
		}
	} 

	
}