"An identity map implemented as a hash map stored in an [[Array]]
 of singly linked lists of [[Entry]]s. The hash code of a key is 
 defined by [[identityHash]]. Note that an `IdentitySet` is not a 
 [[Map]], since it does not obey the semantics of a `Map`."
by ("Gavin King")
shared class IdentityMap<Key, Item>({<Key->Item>*} initialValues = {})
    satisfies Category & {<Key->Item>*} & Correspondence<Key,Item> & 
              Cloneable<IdentityMap<Key,Item>>
        given Key satisfies Identifiable 
        given Item satisfies Object {
    
    variable Array<Cell<Key->Item>?> store = makeCellEntryArray<Key,Item>(16);
    variable Integer _size = 0;
    Float loadFactor = 0.75;
    
    // Write
    
    Integer storeIndex(Identifiable key, Array<Cell<Key->Item>?> store){
        Integer i = identityHash(key) % store.size;
        return i.negative then i.negativeValue else i;
    }
    
    Boolean addToStore(Array<Cell<Key->Item>?> store, Key key, Item item){
        Integer index = storeIndex(key, store);
        variable Cell<Key->Item>? bucket = store[index];
        while(exists Cell<Key->Item> cell = bucket){
            if(cell.car.key === key){
                // modify an existing entry
                cell.car = key->item;
                return false;
            }
            bucket = cell.cdr;
        }
        // add a new entry
        store.set(index, Cell<Key->Item>(key->item, store[index]));
        return true;
    }

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
    
    // Add initial values
    for(key->item in initialValues){   
        if(addToStore(store, key, item)){
            _size++;
        }
    }
    checkRehash();
    
    // End of initialiser section
    
    shared Item? put(Key key, Item item){
        Integer index = storeIndex(key, store);
        variable Cell<Key->Item>? bucket = store[index];
        while(exists Cell<Key->Item> cell = bucket){
            if(cell.car.key === key){
                Item oldValue = cell.car.item;
                // modify an existing entry
                cell.car = key->item;
                return oldValue;
            }
            bucket = cell.cdr;
        }
        // add a new entry
        store.set(index, Cell<Key->Item>(key->item, store[index]));
        _size++;
        checkRehash();
        return null;
    }
    
    "Adds a collection of key/value mappings to this map, may be used to change existing mappings"
    shared void putAll({<Key->Item>*} entries){
        for(entry in entries){
            if(addToStore(store, entry.key, entry.item)){
                _size++;
            }
        }
        checkRehash();
    }
    
    
    "Removes a key/value mapping if it exists"
    shared Item? remove(Key key){
        Integer index = storeIndex(key, store);
        variable Cell<Key->Item>? bucket = store[index];
        variable Cell<Key->Item>? prev = null;
        while(exists Cell<Key->Item> cell = bucket){
            if(cell.car.key === key){
                // found it
                if(exists Cell<Key->Item> last = prev){
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
    shared void clear(){
        variable Integer index = 0;
        // walk every bucket
        while(index < store.size){
            store.set(index++, null);
        }
        _size = 0;
    }
    
    // Read
    
    shared actual Integer size {
        return _size;
    }
    
    shared actual Item? get(Key key) {
        if(empty){
            return null;
        }
        Integer index = storeIndex(key, store);
        variable Cell<Key->Item>? bucket = store[index];
        while(exists Cell<Key->Item> cell = bucket){
            if(cell.car.key === key){
                return cell.car.item;
            }
            bucket = cell.cdr;
        }
        return null;
    }
    
    shared Collection<Item> values {
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
    
    shared actual IdentitySet<Key> keys {
        IdentitySet<Key> ret = IdentitySet<Key>();
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
    
    /*shared actual Map<Item,Set<Key>> inverse {
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
    }*/
    
    shared actual Iterator<Key->Item> iterator() {
        // FIXME: make this faster with a size check
        object iter satisfies Iterator<Key->Item> {
            variable Integer index = 0;
            variable Cell<Key->Item>? bucket = store[index];
            
            shared actual <Key->Item>|Finished next() {
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
                hash = hash * 31 + identityHash(cell.car.key);
                hash = hash * 31 + cell.car.item.hash;
                bucket = cell.cdr;
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
                variable Cell<Key->Item>? bucket = store[index];
                while(exists Cell<Key->Item> cell = bucket){
                    Object? item = that.get(cell.car.key);
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
        return false;
    }
    
    shared actual IdentityMap<Key,Item> clone {
        IdentityMap<Key,Item> clone = IdentityMap<Key,Item>();
        clone._size = _size;
        clone.store = makeCellEntryArray<Key,Item>(store.size);
        variable Integer index = 0;
        // walk every bucket
        while(index < store.size){
            if(exists Cell<Key->Item> bucket = store[index]){
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
    
}
