import ceylon.collection {
    MutableMap
}

import java.util {
    JMap=Map,
    HashMap
}

"A Ceylon [[Map]] that wraps a [[java.util::Map]]."
shared class CeylonMap<Key, Item>(JMap<Key, Item> map) 
        satisfies MutableMap<Key, Item> 
        given Key satisfies Object 
        given Item satisfies Object {
    
    get(Object key) => map.get(key);
    
    iterator() 
            => CeylonIterable(map.entrySet())
                .map((entry) => entry.key->entry.\ivalue)
                .iterator();
    
    put(Key key, Item item) => map.put(key, item);
    
    remove(Key key) => map.remove(key);
    
    clear() => map.clear();
    
    clone() => CeylonMap(HashMap(map));
    
    equals(Object that) 
            => (super of Map<Key,Item>).equals(that);
    
    hash => (super of Map<Key,Item>).hash;
    
}