"A wrapper class that exposes any [[Map]] as
 an immutable map, hiding the underlying `Map`
 implementation from clients, and preventing 
 attempts to cast to [[ImmutableMap]]."
by ("Gavin King")
class ImmutableMap<out Key,out Item>(Map<Key,Item> map)
        satisfies Map<Key,Item>
        given Key satisfies Object
        given Item satisfies Object {

    get(Object key) => map.get(key);
    defines(Object key) => map.defines(key);
    
    iterator() => map.iterator();
    
    size => map.size;
    
    keys => map.keys;
    values = map.values;
    
    equals(Object that) => map.equals(that);    
    hash => map.hash;
    
    clone => ImmutableMap(map.clone);
    
}