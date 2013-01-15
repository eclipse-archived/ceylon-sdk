doc "Mutable map"
by "Stéphane Épardaud"
shared interface MutableMap<Key, Item>
    satisfies Map<Key, Item>
        given Key satisfies Object 
        given Item satisfies Object {
    
    doc "Adds a key/value mapping to this map, may be used to modify an existing mapping"
    shared formal void put(Key key, Item item);
    
    doc "Adds the key/value mappings to this map, may be used to change existing mappings"
    shared formal void putAll(<Key->Item>* entries);
    
    doc "Removes a key/value mapping if it exists"
    shared formal void remove(Key key);
    
    doc "Removes every key/value mapping"
    shared formal void clear();
}