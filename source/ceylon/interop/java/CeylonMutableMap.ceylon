import ceylon.collection {
    MutableMap
}

import java.util {
    JMap=Map,
    HashMap
}

"A Ceylon [[MutableMap]] that wraps a [[java.util::Map]]."
shared class CeylonMutableMap<Key, Item>(JMap<Key, Item> map)
        extends CeylonMap<Key, Item>(map)
        satisfies MutableMap<Key, Item> 
        given Key satisfies Object 
        given Item satisfies Object {
    
    put(Key key, Item item) => map.put(key, item);
    
    remove(Key key) => map.remove(key);
    
    /*removeEntry(Key key, Item item) => map.remove(key, item);
    
    replaceEntry(Key key, Item item, Item newItem) 
            => map.replace(key, item, newItem);*/
    
    clear() => map.clear();
    
    clone() => CeylonMutableMap(HashMap(map));
    
}