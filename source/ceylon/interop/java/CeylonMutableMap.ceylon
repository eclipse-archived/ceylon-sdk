import ceylon.collection {
    MutableMap
}

import java.util {
    JMap=Map,
    HashMap
}

"A Ceylon [[MutableMap]] that wraps a [[java.util::Map]].

 If the given [[map]] contains null elements, an optional
 [[Item]] type must be explicitly specified, for example:

     CeylonMap<String,Object?>(javaStringObjectMap)

 If a non-optional `Item` type is specified, an
 [[AssertionError]] will occur whenever a null item is
 encountered while iterating the map."
shared class CeylonMutableMap<Key, Item>(map)
        extends CeylonMap<Key, Item>(map)
        satisfies MutableMap<Key, Item> 
        given Key satisfies Object 
        given Item satisfies Object {

    JMap<Key, Item> map;
    
    put(Key key, Item item) => map.put(key, item);
    
    remove(Key key) => map.remove(key);
    
    /*removeEntry(Key key, Item item) => map.remove(key, item);
    
    replaceEntry(Key key, Item item, Item newItem) 
            => map.replace(key, item, newItem);*/
    
    clear() => map.clear();
    
    clone() => CeylonMutableMap(HashMap(map));
    
}
