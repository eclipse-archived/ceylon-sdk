"An identity map implemented as a hash map stored in an 
 [[Array]] of singly linked lists of [[Entry]]s. The hash 
 code of a key is defined by [[identityHash]]. Note that an 
 `IdentitySet` is not a [[Map]], since it does not obey the 
 semantics of a `Map`. In particular, it may contain 
 multiple keys which are equal, as determined by the `==` 
 operator."
by ("Gavin King")
shared class IdentityMap<Key, Item>
        (hashtable=Hashtable(), entries = {})
        satisfies {<Key->Item>*} & 
                  Collection<Key->Item> &
                  Correspondence<Key,Item>
        given Key satisfies Identifiable 
        given Item satisfies Object {
    
    "The initial entries in the map."
    {<Key->Item>*} entries;
    
    "Performance-related settings for the backing array."
    Hashtable hashtable;
        
    variable value store = entryStore<Key,Item>
                (hashtable.initialCapacity);
    variable Integer length = 0;
    
    // Write
    
    Integer storeIndex(Identifiable key, Array<Cell<Key->Item>?> store)
            => (identityHash(key) % store.size).magnitude;
    
    Boolean addToStore(Array<Cell<Key->Item>?> store, Key->Item entry) {
        Integer index = storeIndex(entry.key, store);
        variable value bucket = store[index];
        while (exists cell = bucket) {
            if (cell.element.key === entry.key) {
                // modify an existing entry
                cell.element = entry;
                return false;
            }
            bucket = cell.rest;
        }
        // add a new entry
        store.set(index, Cell(entry, store[index]));
        return true;
    }
    
    void checkRehash() {
        if (hashtable.rehash(length, store.size)) {
            // must rehash
            value newStore = entryStore<Key,Item>
                    (hashtable.capacity(length));
            variable Integer index = 0;
            // walk every bucket
            while (index < store.size){
                variable value bucket = store[index];
                while (exists cell = bucket){
                    bucket = cell.rest;
                    Integer newIndex = storeIndex(cell.element.key, newStore);
                    variable value newBucket = newStore[newIndex];
                    while (exists newCell = newBucket?.rest) {
                        newBucket = newCell;
                    }
                    cell.rest = newBucket;
                    newStore.set(newIndex, cell);
                }
                index++;
            }
            store = newStore;
        }
    }
    
    // Add initial values
    for (entry in entries) {   
        if (addToStore(store, entry)) {
            length++;
        }
    }
    checkRehash();
    
    // End of initialiser section
    
    shared Item? put(Key key, Item item){
        Integer index = storeIndex(key, store);
        variable value bucket = store[index];
        while(exists cell = bucket){
            if(cell.element.key === key){
                Item oldItem = cell.element.item;
                // modify an existing entry
                cell.element = key->item;
                return oldItem;
            }
            bucket = cell.rest;
        }
        // add a new entry
        store.set(index, Cell(key->item, store[index]));
        length++;
        checkRehash();
        return null;
    }
    
    "Adds a collection of key/value mappings to this map, 
     may be used to change existing mappings"
    shared void putAll({<Key->Item>*} entries){
        for(entry in entries){
            if(addToStore(store, entry)){
                length++;
            }
        }
        checkRehash();
    }
    
    
    "Removes a key/value mapping if it exists"
    shared Item? remove(Key key) {
        Integer index = storeIndex(key, store);
        while (exists head = store[index], 
            head.element.key == key) {
            store.set(index,head.rest);
            length--;
            return head.element.item;
        }
        variable value bucket = store[index];
        while (exists cell = bucket) {
            value rest = cell.rest;
            if (exists rest,
                rest.element.key == key) {
                cell.rest = rest.rest;
                length--;
                return rest.element.item;
            }
            else {
                bucket = rest;
            }
        }
        return null;
    }

    
    "Removes every key/value mapping"
    shared void clear(){
        variable Integer index = 0;
        // walk every bucket
        while(index < store.size){
            store.set(index++, null);
        }
        length = 0;
    }
    
    // Read
    
    size => length;
    
    shared actual Item? get(Key key) {
        if(empty){
            return null;
        }
        Integer index = storeIndex(key, store);
        variable value bucket = store[index];
        while(exists cell = bucket){
            if(cell.element.key === key){
                return cell.element.item;
            }
            bucket = cell.rest;
        }
        return null;
    }
    
    /*shared Collection<Item> values {
        value ret = LinkedList<Item>();
        variable Integer index = 0;
        // walk every bucket
        while(index < store.size){
            variable value bucket = store[index];
            while(exists cell = bucket){
                ret.add(cell.element.item);
                bucket = cell.rest;
            }
            index++;
        }
        return ret;
    }
    
    shared actual IdentitySet<Key> keys {
        value ret = IdentitySet<Key>();
        variable Integer index = 0;
        // walk every bucket
        while(index < store.size){
            variable value bucket = store[index];
            while(exists cell = bucket){
                ret.add(cell.element.key);
                bucket = cell.rest;
            }
            index++;
        }
        return ret;
    }
    
    shared actual Map<Item,Set<Key>> inverse {
        value ret = HashMap<Item,MutableSet<Key>>();
        variable Integer index = 0;
        // walk every bucket
        while(index < store.size){
            variable value bucket = store[index];
            while(exists cell = bucket){
                if(exists keys = ret[cell.car.item]){
                    keys.add(cell.car.key);
                }else{
                    value k = HashSet<Key>();
                    ret.put(cell.car.item, k);
                    k.add(cell.car.key);
                }
                bucket = cell.cdr;
            }
            index++;
        }
        return ret;
    }*/
    
    iterator() => StoreIterator(store);
    
    shared actual Integer count(Boolean selecting(Key->Item element)) {
        variable Integer index = 0;
        variable Integer count = 0;
        // walk every bucket
        while(index < store.size){
            variable value bucket = store[index];
            while(exists cell = bucket){
                if(selecting(cell.element)){
                    count++;
                }
                bucket = cell.rest;
            }
            index++;
        }
        return count;
    }
    
    shared actual Integer hash {
        variable Integer index = 0;
        variable Integer hash = 17;
        // walk every bucket
        while(index < store.size){
            variable value bucket = store[index];
            while(exists cell = bucket){
                hash = hash * 31 + identityHash(cell.element.key);
                hash = hash * 31 + cell.element.item.hash;
                bucket = cell.rest;
            }
            index++;
        }
        return hash;
    }
    
    shared actual Boolean equals(Object that) {
        if(is IdentityMap<Object,Object> that,
            size == that.size){
            variable Integer index = 0;
            // walk every bucket
            while(index < store.size){
                variable value bucket = store[index];
                while(exists cell = bucket){
                    if(exists item = that.get(cell.element.key)){
                        if(item != cell.element.item){
                            return false;
                        }
                    }else{
                        return false;
                    }
                    bucket = cell.rest;
                }
                index++;
            }
            return true;
        }
        return false;
    }
    
    shared actual IdentityMap<Key,Item> clone() {
        value clone = IdentityMap<Key,Item>();
        clone.length = length;
        clone.store = entryStore<Key,Item>(store.size);
        variable Integer index = 0;
        // walk every bucket
        while(index < store.size){
            if(exists bucket = store[index]){
                clone.store.set(index, bucket.clone()); 
            }
            index++;
        }
        return clone;
    }
    
    shared actual Boolean contains(Object element) {
        variable Integer index = 0;
        // walk every bucket
        while(index < store.size){
            variable value bucket = store[index];
            while(exists cell = bucket){
                if(cell.element.item == element){
                    return true;
                }
                bucket = cell.rest;
            }
            index++;
        }
        return false;
    }
    
}
