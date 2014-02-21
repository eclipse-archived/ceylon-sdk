"A [[Map]] supporting addition of new entries and removal of
 existing entries."
see (`class HashMap`)
by("Stéphane Épardaud")
shared interface MutableMap<Key, Item>
        satisfies Map<Key, Item> &
                  MapMutator<Key, Item>
        given Key satisfies Object 
        given Item satisfies Object {
    
    "Add an entry to this map, overwriting any existing 
     entry for the given [[key]], and returning the previous 
     value associated with the given `key`, if any, or 
     `null` if no existing entry was overwritten."
    shared formal actual Item? put(Key key, Item item);
    
    "Remove the entry associated with the given [[key]], if 
     any, from this map, returning the value no longer 
     associated with the given `key`, if any, or `null` if
     there was no entry associated with the given `key`."
    shared formal actual Item? remove(Key key);
    
    shared actual formal MutableMap<Key, Item> clone();
    
}

"Protocol for mutation of a [[MutableMap]]."
see (`interface MutableMap`)
shared interface MapMutator<in Key, in Item>
        satisfies Map<Object, Object>
        given Key satisfies Object
        given Item satisfies Object {
    
    "Add an entry to this map, overwriting any existing 
     entry for the given [[key]], and returning the previous 
     value associated with the given `key`, if any, or 
     `null` if no existing entry was overwritten."
    shared formal Object? put(Key key, Item item);
    
    "Add the given [[entries]] to this map, overwriting any 
     existing entries with the same keys."
    shared default void putAll({<Key->Item>*} entries) {
        for (key->item in entries) {
            put(key, item);
        }
    }
    
    "Remove the entry associated with the given [[key]], if 
     any, from this map, returning the value no longer 
     associated with the given `key`, if any, or `null` if
     there was no entry associated with the given `key`."
    shared formal Object? remove(Key key);
    
    "Remove the entries associated with the given [[keys]], 
     if any, from this map."
    shared default void removeAll({Key*} keys) {
        for (key in keys) {
            remove(key);
        }
    }
    
    "Remove every entry from this map, leaving an empty map
     with no entries."
    shared formal void clear();
    
}