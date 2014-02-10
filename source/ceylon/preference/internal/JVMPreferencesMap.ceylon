import java.util.prefs { Preferences {userRoot, systemRoot}}
import ceylon.collection { MutableMap }
import ceylon.preference { Preference }
import ceylon.preference.internal { AbstractPreferencesMap, BackingStore }

shared class JVMPreferencesMap (String node, Boolean system) 
        extends AbstractPreferencesMap(node, system)  {
    
    shared actual object scopedPrefs satisfies BackingStore<String, String> {
        Preferences scopedRoot {
            if (system) {
                return systemRoot().node(node);
            } else {
                return userRoot().node(node);
            }
        }

        shared actual void clear() {
            scopedRoot.clear();
        }
        
        shared actual String? get(String key) {
            return scopedRoot.get(key, null);
        }
        
        shared actual void put(String key, String item) {
            scopedRoot.put(key, item);
        }
        
        shared actual void remove(String key) {
            scopedRoot.remove(key);
        }
        
        shared actual Iterator<String> keys {
            object iter satisfies Iterator<String> {
                value internalKeys = scopedRoot.keys().array.iterator();
                shared actual String|Finished next() {
                    if (exists k = internalKeys.next(),
                        ! is Finished k) {
                        return k.string;
                    } else {
                        return finished;
                    }
                }
            }
            return iter;
        }

        shared actual void flush() {
            scopedRoot.flush();
        }
        
        shared actual void sync() {
            scopedRoot.flush();
        }           
    }
 
    shared actual Boolean equals(Object that) {
        if (is JVMPreferencesMap that,
        scopedPrefs.equals(that.scopedPrefs)) {
            return true;
        } else {
            return false;
        }
    }
    
    shared actual Integer hash => identityHash(this);
    
    shared actual MutableMap<String, Preference> clone() {
        return JVMPreferencesMap(node, system);
    }
}