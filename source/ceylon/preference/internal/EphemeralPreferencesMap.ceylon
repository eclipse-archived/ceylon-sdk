import ceylon.collection { MutableMap, HashMap }
import ceylon.preference { Preference }

shared class EphemeralPreferencesMap (String node, Boolean system) 
        extends AbstractPreferencesMap(node, system)  {
    
    shared actual object scopedPrefs satisfies BackingStore<String, String> {
        HashMap<String, HashMap<String, String>> mapOfMaps = 
            HashMap<String, HashMap<String, String>>();
        
        HashMap<String, String> scopedRoot {
            String mapKey = system then "system" else "user" + node;
            if (exists map = mapOfMaps.get(mapKey)) {
                return map;
            } else {
                value newMap = HashMap<String, String>();
                mapOfMaps.put(mapKey, newMap);
                return newMap;
            }
        }

        shared actual void clear() {
            scopedRoot.clear();
        }
        
        shared actual String? get(String key) {
            return scopedRoot.get(key);
        }
        
        shared actual void put(String key, String item) {
            scopedRoot.put(key, item);
        }
        
        shared actual void remove(String key) {
            scopedRoot.remove(key);
        }
        
        shared actual Iterator<String> keys {
            return scopedRoot.keys.iterator();
        }

        shared actual void flush() {} // not flushable store
        shared actual void sync() {} // always synced        
    }
 
    shared actual Boolean equals(Object that) {
        if (is EphemeralPreferencesMap that,
        scopedPrefs.equals(that.scopedPrefs)) {
            return true;
        } else {
            return false;
        }
    }
    
    shared actual Integer hash => identityHash(this);
    
    shared actual MutableMap<String, Preference> clone() {
        return EphemeralPreferencesMap(node, system);
    }
}