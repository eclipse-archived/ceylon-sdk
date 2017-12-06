/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
"An identity map implemented as a hash map stored in an 
 [[Array]] of singly linked lists of [[Entry]]s. The hash 
 code of a key is defined by [[identityHash]]. Note that an 
 `IdentityMap` is not a [[Map]], since it does not obey the
 semantics of a `Map`. In particular, it may contain 
 multiple keys which are equal, as determined by the `==` 
 operator."
by ("Gavin King")
shared serializable class IdentityMap<Key, Item>
        (hashtable=Hashtable(), entries = {})
        satisfies {<Key->Item>*} & 
                  Collection<Key->Item> &
                  Correspondence<Key,Item>
        given Key satisfies Identifiable {
    
    "The initial entries in the map."
    {<Key->Item>*} entries;
    
    "Performance-related settings for the backing array."
    Hashtable hashtable;
        
    variable value store 
                = entryStore<Key,Item>
                    (hashtable.initialCapacity);
    variable Integer length = 0;
    
    // Write
    
    Integer storeIndex(Identifiable key, Array<Cell<Key->Item>?> store)
            => (identityHash(key) % store.size).magnitude;
    
    Boolean addToStore(Array<Cell<Key->Item>?> store, Key->Item entry) {
        Integer index = storeIndex(entry.key, store);
        value headBucket = store[index];
        variable value bucket = headBucket;
        while (exists cell = bucket) {
            if (cell.element.key === entry.key) {
                // modify an existing entry
                cell.element = entry;
                return false;
            }
            bucket = cell.rest;
        }
        // add a new entry
        store[index] = Cell(entry, headBucket);
        return true;
    }
    
    void checkRehash() {
        if (hashtable.rehash(length, store.size)) {
            // must rehash
            value newStore 
                    = entryStore<Key,Item>
                        (hashtable.capacity(length));
            variable Integer index = 0;
            // walk every bucket
            while (index < store.size) {
                variable value bucket = store[index];
                while (exists cell = bucket) {
                    bucket = cell.rest;
                    Integer newIndex 
                            = storeIndex(cell.element.key, 
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
    checkRehash();
    
    // End of initialiser section
    
    shared Item? put(Key key, Item item) {
        Integer index = storeIndex(key, store);
        value entry = key->item;
        value headBucket = store[index];
        variable value bucket = headBucket;
        while (exists cell = bucket) {
            if (cell.element.key === key) {
                Item oldItem = cell.element.item;
                // modify an existing entry
                cell.element = entry;
                return oldItem;
            }
            bucket = cell.rest;
        }
        // add a new entry
        store[index] = Cell(entry, headBucket);
        length++;
        checkRehash();
        return null;
    }
    
    "Adds a collection of key/value mappings to this map, 
     may be used to change existing mappings"
    shared void putAll({<Key->Item>*} entries) {
        for (entry in entries) {
            if (addToStore(store, entry)) {
                length++;
            }
        }
        checkRehash();
    }
    
    shared Boolean replaceEntry(Key key, 
        Item&Object item, Item newItem) {
        Integer index = storeIndex(key, store);
        variable value bucket = store[index];
        while (exists cell = bucket) {
            if (cell.element.key === key) {
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
        
    "Removes a key/value mapping if it exists"
    shared Item? remove(Key key) {
        Integer index = storeIndex(key, store);
        if (exists head = store[index],
            head.element.key === key) {
            store[index] = head.rest;
            length--;
            return head.element.item;
        }
        variable value bucket = store[index];
        while (exists cell = bucket) {
            value rest = cell.rest;
            if (exists rest,
                rest.element.key === key) {
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
    
    "Remove the entries associated with the given keys, 
     if any, from this map"
    shared void removeAll({Key*} keys) {
        for (key in keys) {
            remove(key);
        }
    }
    
    shared Boolean removeEntry(Key key, Item&Object item) {
        Integer index = storeIndex(key, store);
        while (exists head = store[index],
            head.element.key === key) {
            if (exists it = head.element.item,
                it==item) {
                store[index] = head.rest;
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
                rest.element.key === key) {
                if (exists it = rest.element.item,
                    it==item) {
                    cell.rest = rest.rest;
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
    
    "Removes every key/value mapping"
    shared void clear() {
        variable Integer index = 0;
        // walk every bucket
        while (index < store.size) {
            store[index++] = null;
        }
        length = 0;
    }
    
    // Read
    
    size => length;
    
    shared actual Item? get(Key key) {
        if (empty) {
            return null;
        }
        Integer index = storeIndex(key, store);
        variable value bucket = store[index];
        while (exists cell = bucket) {
            if (cell.element.key === key) {
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
    
    shared actual IdentitySet<Key> keys {
        value ret = IdentitySet<Key>();
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
                if (exists keys = ret[cell.car.item]) {
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
        store.each((bucket) {
            variable value iter = bucket;
            while (exists cell = iter) {
                step(cell.element);
                iter = cell.rest;
            }
        });
    }
    
    shared actual Integer hash {
        variable Integer index = 0;
        variable Integer hash = 17;
        // walk every bucket
        while (index < store.size) {
            variable value bucket = store[index];
            while (exists cell = bucket) {
                hash = (hash * 31 + identityHash(cell.element.key))*31;
                if (exists item = cell.element.item) {
                    hash += item.hash;
                }
                bucket = cell.rest;
            }
            index++;
        }
        return hash;
    }
    
    shared actual Boolean equals(Object that) {
        if (is IdentityMap<Object,Object> that) {
            if (this===that) {
                return true;
            }
            if (size == that.size) {
                variable Integer index = 0;
                // walk every bucket
                while (index < store.size) {
                    variable value bucket = store[index];
                    while (exists cell = bucket) {
                        value thatItem = that.get(cell.element.key);
                        if (exists thisItem = cell.element.item) {
                            if (exists thatItem) {
                                if (thatItem != thisItem) {
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
        }
        return false;
    }
    
    shared actual IdentityMap<Key,Item> clone() {
        value clone = IdentityMap<Key,Item>();
        clone.length = length;
        clone.store = entryStore<Key,Item>(store.size);
        variable Integer index = 0;
        // walk every bucket
        while (index < store.size) {
            if (exists bucket = store[index]) {
                clone.store[index] = bucket.clone();
            }
            index++;
        }
        return clone;
    }
    
    shared actual Boolean defines(Key key) {
        variable Integer index = 0;
        // walk every bucket
        while (index < store.size) {
            variable value bucket = store[index];
            while (exists cell = bucket) {
                if (cell.element.key === key) {
                    return true;
                }
                bucket = cell.rest;
            }
            index++;
        }
        return false;
    }
    
    shared actual Boolean contains(Object element) {
        variable Integer index = 0;
        // walk every bucket
        while (index < store.size) {
            variable value bucket = store[index];
            while (exists cell = bucket) {
                if (exists it = cell.element.item, 
                        it == element) {
                    return true;
                }
                bucket = cell.rest;
            }
            index++;
        }
        return false;
    }
    
}
