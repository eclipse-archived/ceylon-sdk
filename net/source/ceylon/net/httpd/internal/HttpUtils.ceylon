import ceylon.collection {HashMap}

by "Matej Lazar"
shared Map<String, String> parseQueryParameters(String queryString) {
	HashMap<String, String> params = HashMap<String, String>();
	
	value paramsSplit = queryString.split("&");
	for (param in paramsSplit) {
		value keyVal = param.split("=");
		value key = keyVal.first;
		value val = keyVal.last;
		if (exists key) {
			if (exists val) {
				params.put(key, val);
			}
		}
	}
	return params;
}
