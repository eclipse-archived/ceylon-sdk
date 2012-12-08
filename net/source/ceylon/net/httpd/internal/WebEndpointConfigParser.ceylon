import ceylon.net.httpd.internal { JavaHelper }
import org.jboss.modules { ModuleClassLoader, JModule = Module, ModuleIdentifier { miFromString = fromString} }
import java.lang { ClassLoader }
import ceylon.file { Reader, Path, parseURI, File }
import ceylon.util.properties { Property }
import ceylon.util.properties { loadPropertiesFile, Properties }
import java.net { URL }
import ceylon.net.httpd { WebEndpointConfig }

shared class WebEndpointConfigParser(String moduleId, String configFileName) {

	JavaHelper jh = JavaHelper();
	
	shared WebEndpointConfig[] parse() {
		SequenceBuilder<WebEndpointConfig> sb = SequenceBuilder<WebEndpointConfig>();
		
		ClassLoader cl = getModuleClassLoader(moduleId);

		URL? url = cl.getResource(configFileName);
		if(exists url) { 
			Path filePath = parseURI(url.toURI().string);
			
			if (is File file = filePath.resource) {
				Reader reader = file.reader();
				Properties properties = loadPropertiesFile(reader);
				if (exists activeEndpoints = properties.item("active-endpoints")) {
					for (activeEndpoint in activeEndpoints.asStringSequence()) {
						if (exists endpointProp = properties.item("endpoint." + activeEndpoint)) {
							value endpoint = createEndpointFromProp(endpointProp);
							sb.append(endpoint);
						}
					}
				}
			}
		} else {
			//TODO narrow exception
			throw Exception("Properties file [" configFileName "] not found.");
		}
		return sb.sequence;
	} 

	ClassLoader getModuleClassLoader(String moduleId) {
		ClassLoader cl = jh.getClassLoader(this);
		if (is ModuleClassLoader cl) {
			value mi = miFromString(moduleId);
			JModule m = cl.\imodule.getModule(mi);
			return m.classLoader;
		}
		return cl;
	}

	WebEndpointConfig createEndpointFromProp(Property endpoint) { 
		String path;
		String className;
		String moduleId;
		
		if (exists prop = endpoint.childItem("path")) {
			path = prop.asString();
		} else {
			//TODO narrow exception
			throw Exception("Missing enpoint path mapping.");
		}

		if (exists prop = endpoint.childItem("className")) {
			className = prop.asString();
		} else {
			//TODO narrow exception
			throw Exception("Missing enpoint class name.");
		} 

		if (exists prop = endpoint.childItem("module")) {
			moduleId = prop.asString();
		} else {
			moduleId = this.moduleId;
		}

		WebEndpointConfig webEndpointConfig = DefaultWebEndpointConfig(path, className, moduleId);
		
		value attributes = endpoint.childItems("attrib");
		for (attribute in attributes) {
			String key = attribute.key().replace(endpoint.key() + ".attrib.", "");
			webEndpointConfig.addAttribute(key, attribute.asString());
		}

		return webEndpointConfig;
	}


}