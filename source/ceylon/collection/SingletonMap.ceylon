"A [[Map]] with exactly one [[entry]]."
see (`class SingletonSet`,
     `class Singleton`)
shared serializable class SingletonMap<Key, Item>(shared Key->Item entry)
        satisfies Map<Key, Item>
        given Key satisfies Object {
    
    defines(Object key) => entry.key==key;
    
    shared actual Item? get(Object key) {
        if (entry.key==key) {
            return entry.item;
        }
        else {
            return null;
        }
    }
    
    contains(Object entry) => this.entry == entry;
    
    iterator() => Singleton(entry).iterator();
    
    equals(Object that)
            => (super of Map<Key, Item>).equals(that);
    
    hash => (super of Map<Key, Item>).hash;
    
    each(void step(Key->Item element)) => step(entry);
    
    shared actual SingletonMap<Key,Item> clone() => this;
    
}