"A wrapper class that exposes any [[Map]] as unmodifiable, 
 hiding the underlying `Map` implementation from clients, 
 and preventing attempts to narrow to [[MutableMap]]."
by ("Gavin King")
class UnmodifiableMap<out Key,out Item>(Map<Key,Item> map)
        satisfies Map<Key,Item>
        given Key satisfies Object {

    get(Object key) => map.get(key);
    defines(Object key) => map.defines(key);
    
    iterator() => map.iterator();
    
    size => map.size;
    
    keys => map.keys;
    items = map.items;
    
    equals(Object that) => map.equals(that);    
    hash => map.hash;
    
    clone() => UnmodifiableMap(map.clone());
    
    each(void step(Key->Item element)) => map.each(step);
    
}

"Wrap the given [[Map]], preventing attempts to narrow the
 returned `Map` to [[MutableMap]]."
shared Map<Key,Item> unmodifiableMap<Key,Item>(Map<Key,Item> map)
        given Key satisfies Object
        => UnmodifiableMap(map);
