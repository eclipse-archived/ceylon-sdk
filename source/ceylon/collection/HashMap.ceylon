doc "Map implementation that uses hashing"
by "Stéphane Épardaud"
shared class HashMap<Key, Item>()
    satisfies MutableMap<Key, Item>
        given Key satisfies Object 
        given Item satisfies Object {
    
    variable Array<Cell<Key->Item>?> store = makeCellEntryArray<Key,Item>(16);
    variable Integer _size = 0;
    Float loadFactor = 0.75;

    // Write

    void checkRehash(){
        if(_size > (store.size.float * loadFactor).integer){
            // must rehash
            Array<Cell<Key->Item>?> newStore = makeCellEntryArray<Key,Item>(_size * 2);
            variable Integer index = 0;
            // walk every bucket
            while(index < store.size){
                variable Cell<Key->Item>? bucket = store[index];
                while(exists Cell<Key->Item> cell = bucket){
                    addToStore(newStore, cell.car.key, cell.car.item);
                    bucket = cell.cdr;
                }
                index++;
            }
            store = newStore;
        }
    }
    
    Boolean addToStore(Array<Cell<Key->Item>?> store, Key key, Item item){
        Integer index = storeIndex(key, store);
        variable Cell<Key->Item>? bucket = store[index];
        while(exists Cell<Key->Item> cell = bucket){
            if(cell.car.key == key){
                // modify an existing entry
                cell.car = key->item;
                return false;
            }
            bucket = cell.cdr;
        }
        // add a new entry
        store.setItem(index, Cell<Key->Item>(key->item, store[index]));
        return true;
    }
    
    doc "Adds a key/value mapping to this map, may be used to modify an existing mapping"
    shared actual void put(Key key, Item item){
        if(addToStore(store, key, item)){
            _size++;
            checkRehash();
        }
    }
    
    doc "Adds a collection of key/value mappings to this map, may be used to change existing mappings"
    shared actual void putAll(<Key->Item>* entries){
        for(entry in entries){
            put(entry.key, entry.item);
        }
    }
    
    doc "Removes a key/value mapping if it exists"
    shared actual void remove(Key key){
        Integer index = storeIndex(key, store);
        variable Cell<Key->Item>? bucket = store[index];
        variable Cell<Key->Item>? prev = null;
        while(exists Cell<Key->Item> cell = bucket){
            if(cell.car.key == key){
                // found it
                if(exists Cell<Key->Item> last = prev){
                    last.cdr = cell.cdr;
                }else{
                    store.setItem(index, cell.cdr);
                }
                _size--;
                return;
            }
            prev = cell;
            bucket = cell.cdr;
        }
    }
    
    doc "Removes every key/value mapping"
    shared actual void clear(){
        variable Integer index = 0;
        // walk every bucket
        while(index < store.size){
            store.setItem(index++, null);
        }
        _size = 0;
    }

    // Read
    
    shared actual Integer size {
        return _size;
    }
    shared actual Boolean empty {
        return _size == 0;
    }
    
    shared actual Item? item(Object key) {
        if(empty){
            return null;
        }
        Integer index = storeIndex(key, store);
        variable Cell<Key->Item>? bucket = store[index];
        while(exists Cell<Key->Item> cell = bucket){
            if(cell.car.key == key){
                return cell.car.item;
            }
            bucket = cell.cdr;
        }
        return null;
    }
    
    Integer storeIndex(Object key, Array<Cell<Key->Item>?> store){
        Integer i = key.hash % store.size;
        return i.negative then i.negativeValue else i;
    }
    
    // FIXME
    doc "Not implemented"
    shared actual Item?[] items(Object* keys) {
        return nothing;
    }
    
    shared actual Collection<Item> values {
        MutableList<Item> ret = LinkedList<Item>();
        variable Integer index = 0;
        // walk every bucket
        while(index < store.size){
            variable Cell<Key->Item>? bucket = store[index];
            while(exists Cell<Key->Item> cell = bucket){
                ret.add(cell.car.item);
                bucket = cell.cdr;
            }
            index++;
        }
        return ret;
    }
    
    shared actual Set<Key> keys {
        MutableSet<Key> ret = HashSet<Key>();
        variable Integer index = 0;
        // walk every bucket
        while(index < store.size){
            variable Cell<Key->Item>? bucket = store[index];
            while(exists Cell<Key->Item> cell = bucket){
                ret.add(cell.car.key);
                bucket = cell.cdr;
            }
            index++;
        }
        return ret;
    }
    
    shared actual Map<Item,Set<Key>> inverse {
        MutableMap<Item,MutableSet<Key>> ret = HashMap<Item,MutableSet<Key>>();
        variable Integer index = 0;
        // walk every bucket
        while(index < store.size){
            variable Cell<Key->Item>? bucket = store[index];
            while(exists Cell<Key->Item> cell = bucket){
                MutableSet<Key>? keys = ret[cell.car.item];
                if(exists keys){
                    keys.add(cell.car.key);
                }else{
                    MutableSet<Key> k = HashSet<Key>();
                    ret.put(cell.car.item, k);
                    k.add(cell.car.key);
                }
                bucket = cell.cdr;
            }
            index++;
        }
        return ret;
    }
    
    shared actual Iterator<Entry<Key,Item>> iterator {
        // FIXME: make this faster with a size check
        object iter satisfies Iterator<Entry<Key,Item>> {
            variable Integer index = 0;
            variable Cell<Key->Item>? bucket = store[index];
            
            shared actual Entry<Key,Item>|Finished next() {
                // do we need a new bucket?
                if(!bucket exists){
                    // find the next non-empty bucket
                    while(++index < store.size){
                        bucket = store[index];
                        if(bucket exists){
                            break;
                        }
                    }
                }
                // do we have a bucket?
                if(exists Cell<Key->Item> bucket = bucket){
                    value car = bucket.car;
                    // advance to the next cell
                    this.bucket = bucket.cdr;
                    return car;
                }
                return finished;
            }
        }
        return iter;
    }
    
    shared actual Integer count(Boolean selecting(Key->Item element)) {
        variable Integer index = 0;
        variable Integer count = 0;
        // walk every bucket
        while(index < store.size){
            variable Cell<Key->Item>? bucket = store[index];
            while(exists Cell<Key->Item> cell = bucket){
                if(selecting(cell.car)){
                    count++;
                }
                bucket = cell.cdr;
            }
            index++;
        }
        return count;
    }
    
    shared actual String string {
        variable Integer index = 0;
        StringBuilder ret = StringBuilder();
        ret.append("{");
        variable Boolean first = true;
        // walk every bucket
        while(index < store.size){
            variable Cell<Key->Item>? bucket = store[index];
            while(exists Cell<Key->Item> cell = bucket){
                if(!first){
                    ret.append(", ");
                }else{
                    first = false;
                }
                ret.append(cell.car.key.string);
                ret.append("->");
                ret.append(cell.car.item.string);
                bucket = cell.cdr;
            }
            index++;
        }
        ret.append("}");
        return ret.string;
    }
    
    shared actual Integer hash {
        variable Integer index = 0;
        variable Integer hash = 17;
        // walk every bucket
        while(index < store.size){
            variable Cell<Key->Item>? bucket = store[index];
            while(exists Cell<Key->Item> cell = bucket){
                hash = hash * 31 + cell.car.hash;
                bucket = cell.cdr;
            }
            index++;
        }
        return hash;
    }
    
    doc "Not implemented yet"
    see (equalsTemp)
    shared actual Boolean equals(Object that) {
        // FIXME: can't implement this :(
        return nothing;
    }
    
    shared Boolean equalsTemp(Map<Key,Item> that){
        if(size != that.size){
            return false;
        }
        variable Integer index = 0;
        // walk every bucket
        while(index < store.size){
            variable Cell<Key->Item>? bucket = store[index];
            while(exists Cell<Key->Item> cell = bucket){
                Item? item = that.item(cell.car.key);
                if(exists item){
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
    
    shared actual Map<Key,Item> clone {
        HashMap<Key,Item> clone = HashMap<Key,Item>();
        clone._size = _size;
        clone.store = makeCellEntryArray<Key,Item>(store.size);
        variable Integer index = 0;
        // walk every bucket
        while(index < store.size){
            if(exists Cell<Key->Item> bucket = store[index]){
                clone.store.setItem(index, bucket.clone); 
            }
            index++;
        }
        return clone;
    }
    
    shared actual Boolean defines(Object key) {
        return item(key) exists;
    }
    shared actual Boolean definesAny(Object* keys) {
        for(Object key in keys){
            if(defines(key)){
                return true;
            }
        }
        return false;
    }
    shared actual Boolean definesEvery(Object* keys) {
        for(Object key in keys){
            if(!defines(key)){
                return false;
            }
        }
        return true;
    }
    
    shared actual Boolean contains(Object element) {
        variable Integer index = 0;
        // walk every bucket
        while(index < store.size){
            variable Cell<Key->Item>? bucket = store[index];
            while(exists Cell<Key->Item> cell = bucket){
                if(cell.car.item == element){
                    return true;
                }
                bucket = cell.cdr;
            }
            index++;
        }
        return false;
    }
    shared actual Boolean containsEvery(Object* elements) {
        for(Object element in elements){
            if(contains(element)){
                return true;
            }
        }
        return false;
    }
    shared actual Boolean containsAny(Object* elements) {
        for(Object element in elements){
            if(!contains(element)){
                return false;
            }
        }
        return true;
    }
}
