import ceylon.collection { MutableMap }
import ceylon.preference { Preference }

shared interface BackingStore<Key, Item> 
        given Key satisfies String
        given Item satisfies String {
    
    shared formal Item? get(Key key);
    shared formal void put(Key key, Item item);
    shared formal void clear();
    shared formal void remove(Key key);
    shared formal void flush();
    shared formal Iterator<Key> keys;
}

shared abstract class AbstractPreferencesMap (String node, Boolean system) 
        satisfies MutableMap<String, Preference>  {
    
    shared formal BackingStore<String, String> scopedPrefs;
    
    shared actual Preference? get(Object key) {
        if (is String key) {
            return internalGet(key.trimLeading('/'.equals));
        }
        return null;
    }
    
    Preference? internalGet(String key) {
        if (exists v = scopedPrefs.get(key)) { // first to trap Integer
            if (v.every("-01234567890".contains)) {
                return parseInteger(v);
            }            
            if (v.every("-01234567890.".contains)) {
                return parseFloat(v);
            }
            if (v in {"true", "false"}) {
                return parseBoolean(v);
            } else {
                if (v.startsWith("\"") && v.endsWith("\"")) {
                    return v[1..v.size-2];
                } else {
                    return v; // something inserted by another entity
                }
            }
        }
        return null;
    }
    
    shared actual Iterator<String->Preference> iterator() {
        object iter satisfies Iterator<String->Preference> {
            value keys = scopedPrefs.keys;
            shared actual <String->Preference>|Finished next() {
                if (! is Finished k = keys.next(),
                    exists v = get(k)) {
                    return k->v;
                } else {
                    return finished;
                }
            }    
        }
        return iter;
    }
    
    shared actual void clear() {
        scopedPrefs.clear();
    }
 
    void internalPut (String key, Preference v) {
         switch (v)
         case (is Boolean) { // cases are separate for clarity
             scopedPrefs.put(key, v.string); // store as String without quotes
         }
         case (is String) {
             scopedPrefs.put(key, "\"" + v + "\""); // quoted
         }
         case (is Integer) {
             scopedPrefs.put(key, v.string); // digits with no .
         }
         case (is Float) {
             scopedPrefs.put(key, v.string);
         }
         scopedPrefs.flush();  
    }
 
    shared actual Preference? put(String key, Preference item) {
        Preference? existing = get(key);
        internalPut(key, item);
        return existing;
    }
    
    shared actual void putAll({<String->Preference>*} entries) {
        for (entry in entries) {
            internalPut(entry.key, entry.item);
        }
    }
    
    shared actual Preference? remove(String key) {
        Preference? existing = get(key);
        scopedPrefs.remove(key);
        return existing;
    }  
}