import ceylon.util.properties { Property, Properties }

class DefaultProperty(Properties properties, String propKey, String propValue) satisfies Property {
	
	shared actual String key() {
		return propKey;
	}
	
	shared actual String asString() {
		return propValue;
	}

	shared actual Integer asInteger() {
		Integer? val = parseInteger(propValue); 
		if (exists val) {
			return val;
		} else {
			throw Exception("Cannot read value ``propValue`` as Integer.");
		}
	}
	
	shared actual String[] asStringSequence() {
		return propValue.split(",").sequence;
	}
	
	shared actual Property[] allChildItems() {
		return properties.items(propKey + ".");
	}
	
	shared actual Property[] childItems(String childKey) {
		return properties.items(propKey + "." + childKey);
	}

	shared actual Property? childItem(String childKey) {
		return properties.item(propKey + "." + childKey);
	}

}