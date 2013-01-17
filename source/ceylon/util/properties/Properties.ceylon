import ceylon.file { Reader }
import ceylon.util.properties.internal { DefaultProperties }

by "Matej Lazar"
shared interface Properties {
	
	shared formal Property? item(String key);

	shared formal Property[] items(String key);

}

shared Properties loadPropertiesFile(Reader reader) {
	return DefaultProperties(reader);
}