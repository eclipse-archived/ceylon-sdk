import ceylon.collection {
    MutableMap
}

import java.util {
    JMap=Map,
    HashMap
}

"A Ceylon [[MutableMap]] that wraps a [[java.util::Map]]."
shared class CeylonMutableMap<Key, Item>(JMap<Key, Item> map) 
        satisfies MutableMap<Key, Item> 
        given Key satisfies Object 
        given Item satisfies Object {
    
    get(Object key) => map.get(key);
    
    defines(Object key) => map.containsKey(key);
    
    iterator() 
            => CeylonIterable(map.entrySet())
                .map((entry) => entry.key->entry.\ivalue)
                .iterator();
    
    put(Key key, Item item) => map.put(key, item);
    
    remove(Key key) => map.remove(key);
    
    /*removeEntry(Key key, Item item) => map.remove(key, item);
    
    replaceEntry(Key key, Item item, Item newItem) 
            => map.replace(key, item, newItem);*/
    
    clear() => map.clear();
    
    clone() => CeylonMutableMap(HashMap(map));
    
    equals(Object that) 
            => (super of Map<Key,Item>).equals(that);
    
    hash => (super of Map<Key,Item>).hash;
    
}