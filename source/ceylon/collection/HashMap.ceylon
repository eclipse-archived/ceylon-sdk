import ceylon.collection {
    Cell,
    entryStore,
    MutableMap
}

"A [[MutableMap]] implemented as a hash map stored in an 
 [[Array]] of singly linked lists of [[Entry]]s. Each entry 
 is assigned an index of the array according to the hash 
 code of its key. The hash code of a key is defined by 
 [[Object.hash]].
 
 The [[stability]] of a `HashMap` controls its iteration
 order:
 
 - A [[linked]] map has a stable and meaningful order of 
   iteration. The entries of the map form a linked list, 
   where new entries are added to the end of the linked 
   list. Iteration of the map follows this linked list, from 
   least recently added elements to most recently added 
   elements.
 - An [[unlinked]] set has an unstable iteration order that 
   may change when the set is modified. The order itself is 
   not meaningful to a client.
 
 The management of the backing array is controlled by the
 given [[hashtable]]."

by ("Stéphane Épardaud")
shared class HashMap<Key, Item>
        (stability=linked, hashtable = Hashtable(), entries = {})
        satisfies MutableMap<Key, Item>
        given Key satisfies Object 
        given Item satisfies Object {
    
    "Determines whether this is a linked hash set with a
     stable iteration order."
    Stability stability;
    
    "The initial entries in the map."
    {<Key->Item>*} entries;
    
    "Performance-related settings for the backing array."
    Hashtable hashtable;
    
    variable value store = entryStore<Key,Item>
                (hashtable.initialCapacity);
    variable Integer length = 0;
    
    variable LinkedCell<Key->Item>? head = null;
    variable LinkedCell<Key->Item>? tip = null;
    
    // Write
    
    Integer storeIndex(Object key, Array<Cell<Key->Item>?> store)
            => (key.hash % store.size).magnitude;
    
    Cell<Key->Item> createCell(Key->Item entry, Cell<Key->Item>? rest) {
        if (stability==linked) {
            value cell = LinkedCell(entry, rest, tip);
            if (exists last = tip) {
                last.next = cell;
            }
            tip = cell;
            if (!head exists) {
                head = cell;
            }
            return cell;
        }
        else {
            return Cell(entry, rest);
        }
    }
    
    void deleteCell(Cell<Key->Item> cell) {
        if (stability==linked) {
            assert (is LinkedCell<Key->Item> cell);
            if (exists last = cell.previous) {
                last.next = cell.next;
            }
            else {
                head = cell.next;
            }
            if (exists next = cell.next) {
                next.previous = cell.previous;
            }
            else {
                tip = cell.previous;
            }
        }
    }
    
    Boolean addToStore(Array<Cell<Key->Item>?> store, Key->Item entry) {
        Integer index = storeIndex(entry.key, store);
        variable value bucket = store[index];
        while (exists cell = bucket) {
            if (cell.element.key == entry.key) {
                // modify an existing entry
                cell.element = entry;
                return false;
            }
            bucket = cell.rest;
        }
        // add a new entry
        store.set(index, createCell(entry, store[index]));
        return true;
    }
    
    void checkRehash() {
        if (hashtable.rehash(length, store.size)) {
            // must rehash
            value newStore = entryStore<Key,Item>
                    (hashtable.capacity(length));
            variable Integer index = 0;
            // walk every bucket
            while (index < store.size) {
                variable value bucket = store[index];
                while (exists cell = bucket) {
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
    for (entry in entries){   
        if (addToStore(store, entry)) {
            length++;
        }
    }
    checkRehash();
    
    // End of initialiser section
    
    shared actual Item? put(Key key, Item item) {
        Integer index = storeIndex(key, store);
        value entry = key->item;
        variable value bucket = store[index];
        while(exists cell = bucket){
            if(cell.element.key == key){
                Item oldItem = cell.element.item;
                // modify an existing entry
                cell.element = entry;
                return oldItem;
            }
            bucket = cell.rest;
        }
        // add a new entry
        store.set(index, createCell(entry, store[index]));
        length++;
        checkRehash();
        return null;
    }
    
    shared actual void putAll({<Key->Item>*} entries) {
        for(entry in entries){
            if(addToStore(store, entry)){
                length++;
            }
        }
        checkRehash();
    }
    
    shared actual Item? remove(Key key) {
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
                deleteCell(cell);
                length--;
                return rest.element.item;
            }
            else {
                bucket = rest;
            }
        }
        return null;
    }
    
    shared actual void clear(){
        variable Integer index = 0;
        // walk every bucket
        while(index < store.size){
            store.set(index++, null);
        }
        length = 0;
        head = null;
        tip = null;
    }
    
    // Read
    
    size => length;
    
    shared actual Item? get(Object key) {
        if(empty){
            return null;
        }
        Integer index = storeIndex(key, store);
        variable value bucket = store[index];
        while(exists cell = bucket){
            if(cell.element.key == key){
                return cell.element.item;
            }
            bucket = cell.rest;
        }
        return null;
    }
    
    /*shared actual Collection<Item> values {
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
    
    shared actual Set<Key> keys {
        value ret = HashSet<Key>();
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
                if(exists keys = ret[cell.element.item]){
                    keys.add(cell.element.key);
                }else{
                    value k = HashSet<Key>();
                    ret.put(cell.element.item, k);
                    k.add(cell.element.key);
                }
                bucket = cell.rest;
            }
            index++;
        }
        return ret;
    }*/
    
    iterator() => stability==linked 
            then LinkedCellIterator(head)
            else StoreIterator(store);
    
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
        variable Integer hash = 0;
        // walk every bucket
        while (index < store.size){
            variable value bucket = store[index];
            while (exists cell = bucket){
                hash += cell.element.hash;
                bucket = cell.rest;
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
    
    shared actual MutableMap<Key,Item> clone() {
        value clone = HashMap<Key,Item>();
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
