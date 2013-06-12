"Mutable map"
by("Stéphane Épardaud")
shared interface MutableMap<Key, Item>
    satisfies Map<Key, Item>
        given Key satisfies Object 
        given Item satisfies Object {
    
    "Adds a key/value mapping to this map, may be used to modify an existing mapping.
         
         Returns the previous value pointed to by `key`, or null."
    shared formal Item? put(Key key, Item item);
    
    "Adds the key/value mappings to this map, may be used to change existing mappings."
    shared formal void putAll({<Key->Item>*} entries);
    
    "Removes a key/value mapping if it exists.
         
         Returns the previous value pointed to by `key`, or null."
    shared formal Item? remove(Key key);
    
    "Removes every key/value mapping."
    shared formal void clear();
}