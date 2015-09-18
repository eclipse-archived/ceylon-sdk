import java.util {
    JMap=Map,
    HashMap
}

"A Ceylon [[Map]] that wraps a [[java.util::Map]]."
shared class CeylonMap<out Key, out Item>(JMap<out Key, out Item> map)
        satisfies Map<Key, Item> 
        given Key satisfies Object 
        given Item satisfies Object {
    
    get(Object key) => map.get(key);
    
    defines(Object key) => map.containsKey(key);
    
    size => map.size();

    keys => CeylonSet(map.keySet());

    items => CeylonCollection(map.values());

    iterator() 
            => CeylonIterable(map.entrySet())
                .map((entry) => entry.key->entry.\ivalue)
                .iterator();

    shared actual default Map<Key, Item> clone()
            => CeylonMap(HashMap(map));
    
    equals(Object that) 
            => (super of Map<Key,Item>).equals(that);
    
    hash => (super of Map<Key,Item>).hash;
    
}