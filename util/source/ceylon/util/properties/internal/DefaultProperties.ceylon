import ceylon.file { Reader }
import ceylon.util.properties { Properties, Property }

shared class DefaultProperties(Reader reader) satisfies Properties {
	
	variable Collection<Property>? properties := null;

	shared actual Property? item(String key) {
		Property[] properties = items(key);
		if (properties.size > 1) {
			//TODO narrow exception
			throw Exception("Expecting only one value for key: " + key );
		} else if (properties.size == 1) {
			return properties.first;
		} else {
			return null;
		}
		
	}

	shared actual Property[] items(String keyPath) {
		value sbItems = SequenceBuilder<Property>();
		
		if (!exists properties) {
			//TODO synchronized properties parser
			properties := parseProperties();
		}
		
		if (exists props = properties) {
			for (propertie in props) {
				if (propertie.key().startsWith(keyPath)) {
					sbItems.append(propertie);
				}
			}
		}
		return sbItems.sequence;
	}

	Collection<Property> parseProperties() {
		value propBuilder = SequenceBuilder<Property>();
		while (is String line = reader.readLine()) {
			if (line.startsWith("#") || line.startsWith(";")) {
				continue;
			}
			value keyVal = line.split("=");
			
			if (keyVal.count != 2) {
				//TODO log
				print("Invalid line in properties file.");
				continue;
			}
			if (exists String key = keyVal.first) {
				if (exists String propValue = keyVal.last) {
					Property property = DefaultProperty(this, key, propValue);
					propBuilder.append(property);
				}
			}
		}
		return propBuilder.sequence;
	}
	
}
