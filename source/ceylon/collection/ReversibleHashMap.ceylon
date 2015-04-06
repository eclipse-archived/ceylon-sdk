"A [[Map]] which may be [[reversed|reverse]], backed by two
 [[HashMap]]s. The reversible mapping from [[Key]]s to 
 [[Item]]s is a _bijection_ (a one-to-one mapping).
 
 In order to maintain the bijection when the 
 `ReversibleHashMap` is mutated, the [[put]] operation not 
 only overwrites any existing mapping for the given key, but
 also removes any existing entry with the given item. Note
 that this behavior, in principle, violates the general
 contract of [[MutableMap.put]]."
//TODO: generalize this implementation to also allow
//      ReversibleTreeMaps!
shared class ReversibleHashMap<Key, Item>
        (stability = linked, hashtable = Hashtable(),
         entries = {}) 
        satisfies MutableMap<Key, Item> 
        given Key satisfies Object
        given Item satisfies Object {
    
    "Performance-related settings for the backing arrays."
    Hashtable hashtable;
    
    "Determines whether this is a linked hash map with a
     stable iteration order."
    Stability stability;
    
    "The initial entries in the map."
    {<Key->Item>*} entries;
    
    variable MutableMap<Key, Item> map 
            = HashMap<Key, Item>
                    (stability, hashtable, entries);
    variable MutableMap<Item, Key> reverseMap 
            = HashMap<Item, Key>
                    (stability, hashtable);
    for (key->item in entries) {
        reverseMap.put(item, key);
    }
    
    "The reverse mapping from [[Item]]s to [[Key]]s. This
     operation is lazy, returning a view of this reversible
     map."
    shared ReversibleHashMap<Item,Key> reverse {
        value reverse = ReversibleHashMap<Item,Key>
                (stability, hashtable);
        reverse.reverseMap = map;
        reverse.map = reverseMap;
        return reverse;
    }
    
    size => map.size;
    
    defines(Object key) => map.defines(key);
    
    contains(Object entry) => map.contains(entry);
    
    get(Object key) => map.get(key);
    
    iterator() => map.iterator();
    
    keys => map.keys;
    
    items => reverseMap.keys;
    
    "Add an entry to this map, overwriting any existing 
     entry for the given [[key]], removing any existing 
     entry with the given [[item]], and returning the 
     previous value associated with the given `key`, if any, 
     or `null` if no existing entry was overwritten."
    shared actual Item? put(Key key, Item item) {
        Item? oldItem = map.put(key, item);
        Key? oldKey = reverseMap.put(item, key);
        if (exists oldItem, oldItem!=item) {
            reverseMap.remove(item);
        }
        if (exists oldKey, oldKey!=key) {
            map.remove(key);
        }
        return oldItem;
    }
    
    shared actual Item? remove(Key key) {
        Item? oldItem = map.remove(key);
        if (exists oldItem) {
            reverseMap.remove(oldItem);
        }
        return oldItem;
    }
    
    shared actual void clear() {
        map.clear();
        reverseMap.clear();
    }
    
    shared actual ReversibleHashMap<Key,Item> clone() {
        value result = 
                ReversibleHashMap<Key,Item>
                        (stability, hashtable);
        result.map = map.clone();
        result.reverseMap = reverseMap.clone();
        return result;
    }
    
    each(void step(Key->Item element)) => map.each(step);
    
    equals(Object that) => map.equals(that);
    
    hash => map.hash;
    
}