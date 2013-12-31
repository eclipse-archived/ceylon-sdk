import ceylon.collection {
    Cell,
    MutableSet,
    LinkedList,
    entryStore,
    HashSet,
    MutableMap
}

"A [[MutableMap]] implemented as a hash map stored in an 
 [[Array]] of singly linked lists of [[Entry]]s. Each entry 
 is assigned an index of the array according to the hash 
 code of its key. The hash code of a key is defined by 
 [[Object.hash]].
 
 The management of the backing array is controlled by the
 given [[hashtable]]."

by("Stéphane Épardaud")
shared class HashMap<Key, Item>
        (hashtable = Hashtable(), entries = {})
        satisfies MutableMap<Key, Item>
        given Key satisfies Object 
        given Item satisfies Object {
    
    "The initial entries in the map."
    {<Key->Item>*} entries;
    
    "Performance-related settings for the backing array."
    Hashtable hashtable;
        
    variable value store = entryStore<Key,Item>(hashtable.initialCapacity);
    variable Integer _size = 0;
    
    // Write
    
    Integer storeIndex(Object key, Array<Cell<Key->Item>?> store)
            => (key.hash % store.size).magnitude;
    
    Boolean addToStore(Array<Cell<Key->Item>?> store, Key->Item entry){
        Integer index = storeIndex(entry.key, store);
        variable value bucket = store[index];
        while(exists cell = bucket){
            if(cell.car.key == entry.key){
                // modify an existing entry
                cell.car = entry;
                return false;
            }
            bucket = cell.cdr;
        }
        // add a new entry
        store.set(index, Cell(entry, store[index]));
        return true;
    }

    void checkRehash(){
        if(_size > (store.size.float * hashtable.loadFactor).integer){
            // must rehash
            value newStore = entryStore<Key,Item>((_size * hashtable.growthFactor).integer);
            variable Integer index = 0;
            // walk every bucket
            while(index < store.size){
                variable value bucket = store[index];
                while(exists cell = bucket){
                    addToStore(newStore, cell.car);
                    bucket = cell.cdr;
                }
                index++;
            }
            store = newStore;
        }
    }
    
    // Add initial values
    for(entry in entries){   
        if(addToStore(store, entry)){
            _size++;
        }
    }
    checkRehash();
    
    // End of initialiser section
    
    shared actual Item? put(Key key, Item item){
        Integer index = storeIndex(key, store);
        value entry = key->item;
        variable value bucket = store[index];
        while(exists cell = bucket){
            if(cell.car.key == key){
                Item oldValue = cell.car.item;
                // modify an existing entry
                cell.car = entry;
                return oldValue;
            }
            bucket = cell.cdr;
        }
        // add a new entry
        store.set(index, Cell(entry, store[index]));
        _size++;
        checkRehash();
        return null;
    }
    
    "Adds a collection of key/value mappings to this map, 
     may be used to change existing mappings"
    shared actual void putAll({<Key->Item>*} entries){
        for(entry in entries){
            if(addToStore(store, entry)){
                _size++;
            }
        }
        checkRehash();
    }
    
    
    "Removes a key/value mapping if it exists"
    shared actual Item? remove(Key key){
        Integer index = storeIndex(key, store);
        variable value bucket = store[index];
        variable value prev = null of Cell<Key->Item>?;
        while(exists Cell<Key->Item> cell = bucket){
            if(cell.car.key == key){
                // found it
                if(exists last = prev){
                    last.cdr = cell.cdr;
                }else{
                    store.set(index, cell.cdr);
                }
                _size--;
                return cell.car.item;
            }
            prev = cell;
            bucket = cell.cdr;
        }
        return null;
    }
    
    "Removes every key/value mapping"
    shared actual void clear(){
        variable Integer index = 0;
        // walk every bucket
        while(index < store.size){
            store.set(index++, null);
        }
        _size = 0;
    }
    
    // Read
    
    size => _size;
    
    shared actual Item? get(Object key) {
        if(empty){
            return null;
        }
        Integer index = storeIndex(key, store);
        variable value bucket = store[index];
        while(exists cell = bucket){
            if(cell.car.key == key){
                return cell.car.item;
            }
            bucket = cell.cdr;
        }
        return null;
    }
    
    shared actual Collection<Item> values {
        value ret = LinkedList<Item>();
        variable Integer index = 0;
        // walk every bucket
        while(index < store.size){
            variable value bucket = store[index];
            while(exists cell = bucket){
                ret.add(cell.car.item);
                bucket = cell.cdr;
            }
            index++;
        }
        return ret;
    }
    
    shared actual Set<Key> keys {
        value ret = HashSet<Key>();
        variable Integer index = 0;
        // walk every bucket
        while(index < store.size){
            variable value bucket = store[index];
            while(exists cell = bucket){
                ret.add(cell.car.key);
                bucket = cell.cdr;
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
    }
    
    iterator() => StoreIterator(store);
    
    shared actual Integer count(Boolean selecting(Key->Item element)) {
        variable Integer index = 0;
        variable Integer count = 0;
        // walk every bucket
        while(index < store.size){
            variable value bucket = store[index];
            while(exists cell = bucket){
                if(selecting(cell.car)){
                    count++;
                }
                bucket = cell.cdr;
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
                hash = hash * 31 + cell.car.hash;
                bucket = cell.cdr;
            }
            index++;
        }
        return hash;
    }
    
    shared actual Boolean equals(Object that) {
        if(is Map<Object,Object> that,
            size == that.size){
            variable Integer index = 0;
            // walk every bucket
            while(index < store.size){
                variable value bucket = store[index];
                while(exists cell = bucket){
                    if(exists item = that.get(cell.car.key)){
                        if(item != cell.car.item){
                            return false;
                        }
                    }else{
                        return false;
                    }
                    bucket = cell.cdr;
                }
                index++;
            }
            return true;
        }
        return false;
    }
    
    shared actual MutableMap<Key,Item> clone {
        value clone = HashMap<Key,Item>();
        clone._size = _size;
        clone.store = entryStore<Key,Item>(store.size);
        variable Integer index = 0;
        // walk every bucket
        while(index < store.size){
            if(exists bucket = store[index]){
                clone.store.set(index, bucket.clone); 
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
                if(cell.car.item == element){
                    return true;
                }
                bucket = cell.cdr;
            }
            index++;
        }
        return false;
    }
    
}
