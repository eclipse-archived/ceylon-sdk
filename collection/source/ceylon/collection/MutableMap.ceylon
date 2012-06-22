doc "Mutable map"
by "Stéphane Épardaud"
shared interface MutableMap<Key, Item>
    satisfies Map<Key, Item>
        given Key satisfies Object 
        given Item satisfies Object {
    
    doc "Adds a key/value mapping to this map, may be used to modify an existing mapping"
    shared formal void put(Key key, Item item);
    
    doc "Adds a collection of key/value mappings to this map, may be used to change existing mappings"
    shared formal void putAll(Collection<Key->Item> map);
    
    doc "Removes a key/value mapping if it exists"
    shared formal void remove(Key key);
    
    doc "Removes every key/value mapping"
    shared formal void clear();
}