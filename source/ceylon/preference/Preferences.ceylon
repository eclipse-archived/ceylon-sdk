import ceylon.language.meta.declaration { Module }
import ceylon.preference.internal { JVMPreferencesMap, EphemeralPreferencesMap }
import ceylon.collection { MutableMap }

"Type of preference."
shared alias Preference => String | Boolean | Integer | Float;

String moduleNode(Module mod) {
    return "/"+mod.qualifiedName.replace(".", "/");
}

"Returns a map of user preferences for the specified module."
shared MutableMap<String, Preference> userPreferences(Module mod) {
    if ("jvm".equals(runtime.name)) {
        return JVMPreferencesMap(moduleNode(mod), false);
    } else {
        return EphemeralPreferencesMap(moduleNode(mod), false);
    } 
}

"Returns a map of system preferences for the specified module."
shared MutableMap<String, Preference> systemPreferences(Module mod) {
    if ("jvm".equals(runtime.name)) {
        return JVMPreferencesMap(moduleNode(mod), true);
    } else {
        return EphemeralPreferencesMap(moduleNode(mod), true);
    }    
}
