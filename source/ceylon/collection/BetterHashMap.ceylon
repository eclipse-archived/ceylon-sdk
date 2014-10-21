import ceylon.collection {
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
 - An [[unlinked]] map has an unstable iteration order that 
   may change when the map is modified. The order itself is 
   not meaningful to a client.
 
 The management of the backing array is controlled by the
 given [[hashtable]]."

by ("Stéphane Épardaud")
shared class BetterHashMap<Key, Item>
        (stability=linked, hashtable = Hashtable(), entries = {})
        satisfies MutableMap<Key, Item>
        given Key satisfies Object {
    
    "Determines whether this is a linked hash map with a
     stable iteration order."
    Stability stability;
    
    "The initial entries in the map."
    {<Key->Item>*} entries;
    
    "Performance-related settings for the backing array."
    Hashtable hashtable;
    
    // For Collections, we can efficiently obtain an 
    // accurate initial capacity. For a generic iterable,
    // just use the given initialCapacity.
    value accurateInitialCapacity 
            = entries is Collection<Anything>;
    Integer initialCapacity 
            = accurateInitialCapacity 
                    then hashtable.initialCapacityForSize(entries.size) 
                    else hashtable.initialCapacity;
    
    "Array of linked lists where we store the elements.
     
     Each element is stored in a linked list from this array
     at the index of the hash code of the element, modulo the
     array size."
    variable value store = betterEntryStore<Key,Item>(initialCapacity);

    "Number of elements in this map."
    variable Integer length = 0;
    
    "Head of the traversal linked list if in `linked` mode. 
     Storage is done in [[store]], but traversal is done 
     using an alternative linked list maintained to have a 
     stable iteration order. Note that the cells used are 
     the same as in the [[store]], except for storage we use 
     [[Cell.rest]] for traversal, while for the stable 
     iteration we use the [[LinkedCell.next]]/[[LinkedCell.previous]]
     attributes of the same cell."
    variable LinkedEntryCell<Key,Item>? head = null;
    
    "Tip of the traversal linked list if in `linked` mode."
    variable LinkedEntryCell<Key,Item>? tip = null;
    
    // Write
    
    Integer storeIndex(Object key, Array<EntryCell<Key,Item>?> store)
            => (key.hash % store.size).magnitude;
    
    EntryCell<Key,Item> createCell(Key key, Item entry, EntryCell<Key,Item>? rest) {
        if (stability==linked) {
            value cell = LinkedEntryCell(key, entry, rest, tip);
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
            return EntryCell(key, entry, rest);
        }
    }
    
    void deleteCell(EntryCell<Key,Item> cell) {
        if (stability==linked) {
            assert (is LinkedEntryCell<Key,Item> cell);
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
    
    Boolean addToStore(Array<EntryCell<Key,Item>?> store, Key key, Item entry) {
        Integer index = storeIndex(key, store);
        variable value bucket = store[index];
        while (exists cell = bucket) {
            if (cell.key == key) {
                // modify an existing entry
                cell.element = entry;
                return false;
            }
            bucket = cell.rest;
        }
        // add a new entry
        store.set(index, createCell(key, entry, store[index]));
        return true;
    }
    
    void checkRehash() {
        if (hashtable.rehash(length, store.size)) {
            // must rehash
            value newStore = betterEntryStore<Key,Item>
                    (hashtable.capacity(length));
            variable Integer index = 0;
            // walk every bucket
            while (index < store.size) {
                variable value bucket = store[index];
                while (exists cell = bucket) {
                    bucket = cell.rest;
                    Integer newIndex = storeIndex(cell.key, newStore);
                    value newBucket = newStore[newIndex];
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
        if (addToStore(store, entry.key, entry.item)) {
            length++;
        }
    }
    // After collecting all the initial
    // values, rebuild the hashtable if
    // necessary
    if (!accurateInitialCapacity) {
        checkRehash();
    }
    
    // End of initialiser section
    
    shared actual Item? put(Key key, Item item) {
        Integer index = storeIndex(key, store);
        value headBucket = store[index];
        variable value bucket = headBucket;
        while (exists cell = bucket) {
            if (cell.key == key) {
                Item oldItem = cell.element;
                // modify an existing entry
                cell.element = item;
                return oldItem;
            }
            bucket = cell.rest;
        }
        // add a new entry
        store.set(index, createCell(key, item, headBucket));
        length++;
        checkRehash();
        return null;
    }
    
    shared actual Boolean replaceEntry(Key key, 
        Item&Object item, Item newItem) {
        Integer index = storeIndex(key, store);
        variable value bucket = store[index];
        while (exists cell = bucket) {
            if (cell.key == key) {
                if (exists oldItem = cell.element, 
                    oldItem==item) {
                    // modify an existing entry
                    cell.element = newItem;
                    return true;
                }
                else {
                    return false;
                }
            }
            bucket = cell.rest;
        }
        return false;
    }

    
    shared actual void putAll({<Key->Item>*} entries) {
        for (key->entry in entries) {
            if (addToStore(store, key, entry)) {
                length++;
            }
        }
        checkRehash();
    }
    
    shared actual Item? remove(Key key) {
        Integer index = storeIndex(key, store);
        while (exists head = store[index], 
            head.key == key) {
            store.set(index,head.rest);
            deleteCell(head);
            length--;
            return head.element;
        }
        variable value bucket = store[index];
        while (exists cell = bucket) {
            value rest = cell.rest;
            if (exists rest,
                rest.key == key) {
                cell.rest = rest.rest;
                deleteCell(cell);
                length--;
                return rest.element;
            }
            else {
                bucket = rest;
            }
        }
        return null;
    }
    
    shared actual Boolean removeEntry(Key key, Item&Object item) {
        Integer index = storeIndex(key, store);
        while (exists head = store[index], 
            head.key == key) {
            if (exists it = head.element, it==item) {
                store.set(index,head.rest);
                length--;
                return true;
            }
            else {
                return false;
            }
        }
        variable value bucket = store[index];
        while (exists cell = bucket) {
            value rest = cell.rest;
            if (exists rest,
                rest.key == key) {
                if (exists it = rest.element, it==item) {
                    cell.rest = rest.rest;
                    deleteCell(cell);
                    length--;
                    return true;
                }
                else {
                    return false;
                }
            }
            else {
                bucket = rest;
            }
        }
        return false;
    }
    
    shared actual void clear() {
        variable Integer index = 0;
        // walk every bucket
        while (index < store.size) {
            store.set(index++, null);
        }
        length = 0;
        head = null;
        tip = null;
    }
    
    // Read
    
    size => length;
    
    shared actual Item? get(Object key) {
        if (empty) {
            return null;
        }
        Integer index = storeIndex(key, store);
        variable value bucket = store[index];
        while (exists cell = bucket) {
            if (cell.key == key) {
                return cell.element;
            }
            bucket = cell.rest;
        }
        return null;
    }
    
    shared actual <Key->Item>? first {
        if (stability==linked) {
            return head?.entry;
        }
        else {
            return store[0]?.entry;
        }
    }
    
    /*shared actual Collection<Item> values {
        value ret = LinkedList<Item>();
        variable Integer index = 0;
        // walk every bucket
        while (index < store.size) {
            variable value bucket = store[index];
            while (exists cell = bucket) {
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
        while (index < store.size) {
            variable value bucket = store[index];
            while (exists cell = bucket) {
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
        while (index < store.size) {
            variable value bucket = store[index];
            while (exists cell = bucket) {
                if (exists keys = ret[cell.element.item]) {
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
            then LinkedEntryCellIterator(head)
            else EntryStoreIterator(store);
    
    shared actual Integer count(Boolean selecting(Key->Item element)) {
        variable Integer index = 0;
        variable Integer count = 0;
        // walk every bucket
        while (index < store.size) {
            variable value bucket = store[index];
            while (exists cell = bucket) {
                if (selecting(cell.entry)) {
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
        while (index < store.size) {
            variable value bucket = store[index];
            while (exists cell = bucket) {
                hash += cell.entry.hash;
                bucket = cell.rest;
            }
            index++;
        }
        return hash;
    }
    
    shared actual Boolean equals(Object that) {
        if (is Map<Object,Anything> that,
            size == that.size) {
            variable Integer index = 0;
            // walk every bucket
            while (index < store.size) {
                variable value bucket = store[index];
                while (exists cell = bucket) {
                    value thatItem = that[cell.key];
                    if (exists thisItem = cell.element) {
                        if (exists thatItem) {
                            if (thatItem!=thisItem) {
                                return false;
                            }
                        }
                        else {
                            return false;
                        }
                    }
                    else if (thatItem exists) {
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
        value clone = BetterHashMap<Key,Item>(stability);
        if (stability==unlinked) {
            clone.length = length;
            clone.store = betterEntryStore<Key,Item>(store.size);
            variable Integer index = 0;
            // walk every bucket
            while (index < store.size) {
                if (exists bucket = store[index]) {
                    clone.store.set(index, bucket.clone()); 
                }
                index++;
            }
        }
        else {
            for (entry in this) {
                clone.put(entry.key, entry.item);
            }
        }
        return clone;
    }
    
    shared actual Boolean defines(Object key) {
        if (empty) {
            return false;
        }
        else {
            Integer index = storeIndex(key, store);
            variable value bucket = store[index];
            while (exists cell = bucket) {
                if (cell.key == key) {
                    return true;
                }
                bucket = cell.rest;
            }
            return false;
        }
    }
    
    shared actual Boolean contains(Object entry) {
        if (empty) {
            return false;
        }
        else if (is Object->Anything entry) {
            value key = entry.key;
            Integer index = storeIndex(key, store);
            variable value bucket = store[index];
            while (exists cell = bucket) {
                if (cell.key == key) {
                    if (exists item = cell.element) {
                        if (exists elementItem = entry.item) {
                            return item == elementItem;
                        }
                        else {
                            return false;
                        }
                    }
                    else {
                        return !entry.item exists;
                    }
                }
                bucket = cell.rest;
            }
            return false;
        }
        else {
            return false;
        }
    }
    
}
