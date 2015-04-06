"A [[MutableMap]] whose keys are the elements of the given
 sequence of [[legal keys|possibleKeys]], and whose items 
 are held in an [[Array]]. If there are a small number of
 legal keys, and if determination of key equality is 
 efficient, for example, if the [[Key]] class uses 
 [[identity equality|Identifiable.equals]], then this
 implementation might be more efficient than a [[HashMap]].
 
 Any attempt to [[add an entry|put]] to this [[ArrayMap]] 
 with a key that is not a [[legal key|possibleKeys]] results 
 in an [[AssertionError]]."
shared class ArrayMap<Key,Item>
        (possibleKeys, entries) 
        satisfies MutableMap<Key, Item> 
        given Key satisfies Object 
        given Item satisfies Object {
    
    "The legal keys of this map. It is recommended, but not
     required, that this sequence not contain duplicates.
     Any attempt to add an item to this [[ArrayMap]] for
     a key that is not an element of this sequence results 
     in an [[AssertionError]]."
    shared Key[] possibleKeys;
    
    "The initial entries of the [[ArrayMap]]."
    {<Key->Item>*} entries;
    
    Array<Item?> items 
            = arrayOfSize<Item?>(possibleKeys.size, null);
    
    //TODO: If the keys happen to be Comparable, we could
    //      sort them, and use bisection to search for 
    //      the key.
    function keyIndex(Object key) {
        variable value index = 0;
        for (candidateKey in possibleKeys) {
            if (candidateKey==key) {
                return index;
            }
            else {
                index++;
            }
        }
        else {
            throw AssertionError("illegal key: " + 
                    key.string);
        }
    }
    
    for (key->item in entries) {
        items.set(keyIndex(key), item);
    }
    
    clone() => ArrayMap(possibleKeys, this);
    
    size => items.count((item) => item exists);
    
    get(Object key) => items[keyIndex(key)];
    
    defines(Object key) => get(key) exists;
    
    iterator() => { for (index in 0:possibleKeys.size) 
                    if (exists item = items[index], 
                        exists key = possibleKeys[index]) 
                    key->item }
            .iterator();
    
    equals(Object that) 
            => (super of Map<Key, Item>).equals(that);
    
    hash => (super of Map<Key, Item>).hash;
    
    shared actual void clear() {
        for (index in 0:possibleKeys.size) {
            items.set(index, null);
        }
    }
    
    shared actual Item? put(Key key, Item item) {
        value index = keyIndex(key);
        value previous = items.get(index);
        items.set(index, item);
        return previous;
    }
    
    shared actual Item? remove(Key key) {
        value index = keyIndex(key);
        value previous = items.get(index);
        items.set(index, null);
        return previous;
    }
    
}