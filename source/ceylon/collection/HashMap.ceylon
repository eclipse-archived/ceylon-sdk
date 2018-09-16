/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
import ceylon.collection { Stability { ... } }

"A [[MutableMap]] implemented as a hash map stored in an 
 [[Array]] of singly linked lists of 
 [[ceylon.language::Entry]]s. Each entry is assigned an 
 index in the array according to the hash code of its key. 
 The hash code of a key is defined by [[Object.hash]].
 
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
 
 The stability is `linked` by default.
 
 The management of the backing array is controlled by the
 given [[hashtable]]."

by ("Stéphane Épardaud")
shared serializable class HashMap<Key, Item>
        satisfies MutableMap<Key, Item>
        given Key satisfies Object {
    
    "Determines whether this is a linked hash map with a
     stable iteration order."
    Stability stability;
    
    "The initial entries in the map."
    {<Key->Item>*} entries;
    
    "Performance-related settings for the backing array."
    Hashtable hashtable;
    
    Boolean accurateInitialCapacity;
    
    "Array of linked lists where we store the elements.
     
     Each element is stored in a linked list from this array
     at the index of the hash code of the element, modulo 
     the array size."
    variable Array<CachingCell<Key->Item>?> store;

    "Number of elements in this map."
    variable Integer length;
    
    "Head of the traversal linked list if in `linked` mode. 
     Storage is done in [[store]], but traversal is done 
     using an alternative linked list maintained to have a 
     stable iteration order. Note that the cells used are 
     the same as in the [[store]], except for storage we use 
     [[CachingCell.rest]] for traversal, while for the stable 
     iteration we use the 
     [[LinkedCell.next]]/[[LinkedCell.previous]] attributes 
     of the same cell."
    variable LinkedCell<Key->Item>? head = null;
    
    "Tip of the traversal linked list if in `linked` mode."
    variable LinkedCell<Key->Item>? tip = null;
    
    "Create a new `HashMap` with the given initial entries."
    shared new (
        "Determines whether this is a linked hash map with a
         stable iteration order, defaulting to [[linked]]
         (stable)."
        Stability stability = linked, 
        "Performance-related settings for the backing array."
        Hashtable hashtable = Hashtable(), 
        "The initial entries in the map, defaulting to no
         initial entries."
        {<Key->Item>*} entries = {}) {
        
        this.stability = stability;
        this.hashtable = hashtable;
        this.entries = entries;
        
        length = 0;
        
        // For Collections, we can efficiently obtain an 
        // accurate initial capacity. For a generic iterable,
        // just use the given initialCapacity.
        accurateInitialCapacity 
                = entries is Collection<Anything>;
        value initialCapacity 
                = accurateInitialCapacity 
                then hashtable.initialCapacityForSize(entries.size) 
                else hashtable.initialCapacityForUnknownSize();
        
        store = cachingEntryStore<Key,Item>(initialCapacity);
    }
    
    "Create a new `HashMap` with the same initial entries as 
     the given [[hashMap]]."
    shared new copy(
        "The `HashMap` to copy."
        HashMap<Key,Item> hashMap,
        "Determines whether this is a linked hash map with a
         stable iteration order, defaulting to the stability
         of the copied `HashMap`."
        Stability stability = hashMap.stability,
        "Performance-related settings for the backing array."
        Hashtable hashtable = Hashtable()) {
        
        this.stability = stability;
        this.hashtable = hashtable;
        
        accurateInitialCapacity = true;
        store = cachingEntryStore<Key,Item>(hashMap.store.size);
        
        if (stability == unlinked) {
            entries = {};
            length = hashMap.length;
            variable Integer index = 0;
            // walk every bucket
            while (index < hashMap.store.size) {
                if (exists bucket
                    = hashMap.store[index]) {
                    store[index] = bucket.clone();
                }
                index++;
            }
        } 
        else {
            //TODO!!!!
            length = 0;
            entries = hashMap;
        }
    }
    
    // Write
    
    function hashCode(Object key) 
            => let (h = key.hash)
                h.xor(h.rightLogicalShift(16));
    
    Integer storeIndex(Integer keyHash, 
            Array<CachingCell<Key->Item>?> store)
            => keyHash.and(store.size-1);
    
    CachingCell<Key->Item> createCell(Key->Item entry,
            Integer keyHash,
            CachingCell<Key->Item>? rest) {
        if (stability==linked) {
            value cell 
                    = LinkedCell(entry, keyHash, rest, tip);
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
            return CachingCell(entry, keyHash, rest);
        }
    }
    
    void deleteCell(CachingCell<Key->Item> cell) {
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
    
    Boolean addToStore(Array<CachingCell<Key->Item>?> store, 
            Key->Item entry) {
        value keyHash = hashCode(entry.key);
        Integer index = storeIndex(keyHash, store);
        value headBucket = store[index];
        variable value bucket = headBucket;
        while (exists cell = bucket) {
            if (cell.keyHash == keyHash
                && cell.element.key == entry.key) {
                // modify an existing entry
                cell.element = entry;
                return false;
            }
            bucket = cell.rest;
        }
        // add a new entry
        store[index]
            = createCell(entry, keyHash, headBucket);
        return true;
    }
    
    void checkRehash() {
        if (hashtable.rehash(length, store.size)) {
            // must rehash
            value newStore 
                    = cachingEntryStore<Key,Item>
                        (hashtable.capacity(length));
            variable Integer index = 0;
            // walk every bucket
            while (index < store.size) {
                variable value bucket = store[index];
                while (exists cell = bucket) {
                    bucket = cell.rest;
                    Integer newIndex = 
                            storeIndex(cell.keyHash, 
                                       newStore);
                    value newBucket 
                            = newStore[newIndex];
                    cell.rest = newBucket;
                    newStore[newIndex] = cell;
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
    // After collecting all the initial
    // values, rebuild the hashtable if
    // necessary
    if (!accurateInitialCapacity) {
        checkRehash();
    }
    
    // End of initialiser section
    
    shared actual Item? put(Key key, Item item) {
        value keyHash = hashCode(key);
        Integer index = storeIndex(keyHash, store);
        value entry = key->item;
        value headBucket = store[index];
        variable value bucket = headBucket;
        while (exists cell = bucket) {
            if (cell.keyHash == keyHash
                    && cell.element.key == key) {
                Item oldItem = cell.element.item;
                // modify an existing entry
                cell.element = entry;
                return oldItem;
            }
            bucket = cell.rest;
        }
        // add a new entry
        store[index]
            = createCell(entry, keyHash, headBucket);
        length++;
        checkRehash();
        return null;
    }
    
    shared actual Boolean replaceEntry(Key key, 
            Item&Object item, Item newItem) {
        value keyHash = hashCode(key);
        Integer index = storeIndex(keyHash, store);
        variable value bucket = store[index];
        while (exists cell = bucket) {         
            if (cell.keyHash == keyHash
                    && cell.element.key == key) {
                if (exists oldItem = cell.element.item, 
                    oldItem==item) {
                    // modify an existing entry
                    cell.element = key->newItem;
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
        for (entry in entries) {
            if (addToStore(store, entry)) {
                length++;
            }
        }
        checkRehash();
    }
    
    shared actual Item? remove(Key key) {
        value keyHash = hashCode(key);
        Integer index = storeIndex(keyHash, store);
        if (exists head 
                = store[index],
            head.keyHash == keyHash,
            head.element.key == key) {
            store[index] = head.rest;
            deleteCell(head);
            length--;
            return head.element.item;
        }
        variable value bucket = store[index];
        while (exists cell = bucket) {
            value rest = cell.rest;
            if (exists rest,
                rest.element.key == key) {
                cell.rest = rest.rest;
                deleteCell(rest);
                length--;
                return rest.element.item;
            }
            else {
                bucket = rest;
            }
        }
        return null;
    }
    
    shared actual Boolean removeEntry(Key key, 
            Item&Object item) {
        value keyHash = hashCode(key);
        Integer index = storeIndex(keyHash, store);
        while (exists head 
                = store[index],
            head.keyHash == keyHash,
            head.element.key == key) {
            if (exists it = head.element.item, 
                it==item) {
                store[index] = head.rest;
                deleteCell(head);
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
                rest.element.key == key) {
                if (exists it = rest.element.item, 
                    it==item) {
                    cell.rest = rest.rest;
                    deleteCell(rest);
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
            store[index++] = null;
        }
        length = 0;
        head = null;
        tip = null;
    }
    
    // Read
    
    size => length;
    
    empty => length==0;
    
    shared actual Item? get(Object key) {
        if (empty) {
            return null;
        }
        value keyHash = hashCode(key);
        Integer index = storeIndex(keyHash, store);
        variable value bucket = store[index];
        while (exists cell = bucket) {
            if (cell.keyHash == keyHash && 
                cell.element.key == key) {
                return cell.element.item;
            }
            bucket = cell.rest;
        }
        return null;
    }
    
    shared actual Item|Default getOrDefault<Default>
            (Object key, Default default) {
        if (empty) {
            return default;
        }
        value keyHash = hashCode(key);
        Integer index = storeIndex(keyHash, store);
        variable value bucket = store[index];
        while (exists cell = bucket) {
            if (cell.keyHash == keyHash && 
                cell.element.key == key) {
                return cell.element.item;
            }
            bucket = cell.rest;
        }
        return default;
    }
    
    shared actual <Key->Item>? first 
            => if (stability==linked) 
                then head?.element 
                else store.coalesced.first?.element;
    
    shared actual <Key->Item>? last {
        if (stability == linked) {
            return tip?.element;
        }
        else {
            variable value bucket = store.reversed.coalesced.first;
            while (exists cell = bucket?.rest) {
                bucket = cell;
            }
            return bucket?.element;
        }
    }
    
    /*shared actual Collection<Item> values {
        value ret = LinkedList<Item>();
        variable Integer index = 0;
        // walk every bucket
        while (index < store.size) {
            variable value bucket = store[index);
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
            variable value bucket = store[index);
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
            variable value bucket = store[index);
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
            then LinkedCellIterator(head)
            else CachingStoreIterator(store);
    
    shared actual Integer count
            (Boolean selecting(Key->Item element)) {
        variable Integer index = 0;
        variable Integer count = 0;
        // walk every bucket
        while (index < store.size) {
            variable value bucket = store[index];
            while (exists cell = bucket) {
                if (selecting(cell.element)) {
                    count++;
                }
                bucket = cell.rest;
            }
            index++;
        }
        return count;
    }
    
    shared actual void each(void step(Key->Item element)) {
        if (stability == linked) {
            variable value cell = head;
            while (exists currentCell = cell) {
                step(currentCell.element);
                cell = currentCell.next;
            }
        }
        else {
            store.each((bucket) {
                variable value iter = bucket;
                while (exists cell = iter) {
                    step(cell.element);
                    iter = cell.rest;
                }
            });
        }
    }
    
    shared actual Integer hash {
        variable value index = 0;
        variable value hash = 0;
        // walk every bucket
        while (index < store.size) {
            variable value bucket = store[index];
            while (exists cell = bucket) {
                hash += cell.element.hash;
                bucket = cell.rest;
            }
            index++;
        }
        return hash;
    }
    
    shared actual Boolean equals(Object that) {
        if (is HashMap<Anything,Anything> that,
            this===that) {
            return true;
        }
        else if (is Map<> that, that.size==length) {
            variable value index = 0;
            // walk every bucket
            while (index < store.size) {
                variable value bucket = store[index];
                while (exists cell = bucket) {
                    value thatItem = that[cell.element.key];
                    if (exists thisItem 
                            = cell.element.item) {
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
        else {
            return false;
        }
    }
    
    shared actual HashMap<Key,Item> clone() => copy(this);
    
    shared actual Boolean defines(Object key) {
        if (empty) {
            return false;
        }
        else {
            value keyHash = hashCode(key);
            Integer index = storeIndex(keyHash, store);
            variable value bucket= store[index];
            while (exists cell = bucket) {
                if (cell.keyHash == keyHash
                        && cell.element.key == key) {
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
            value keyHash = hashCode(key);
            Integer index = storeIndex(keyHash, store);
            variable value bucket = store[index];
            while (exists cell = bucket) {
                if (cell.keyHash == keyHash
                        && cell.element.key == key) {
                    if (exists item = cell.element.item) {
                        if (exists elementItem 
                                = entry.item) {
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
