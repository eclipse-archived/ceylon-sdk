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

"A [[MutableSet]] implemented as a hash set stored in an 
 [[Array]] of singly linked lists. Each element is assigned 
 an index of the array according to its hash code. The hash 
 code of an element is defined by [[Object.hash]].
 
 The [[stability]] of a `HashSet` controls its iteration
 order:
 
 - A [[linked]] set has a stable and meaningful order of 
   iteration. The elements of the set form a linked list, 
   where new elements are added to the end of the linked 
   list. Iteration of the set follows this linked list, from 
   least recently added elements to most recently added 
   elements.
 - An [[unlinked]] set has an unstable iteration order that 
   may change when the set is modified. The order itself is 
   not meaningful to a client.
 
 The stability is `linked` by default.
 
 The management of the backing array is controlled by the
 given [[hashtable]]."
by ("Stéphane Épardaud", "Gavin King")
shared serializable class HashSet<Element>
        satisfies MutableSet<Element>
        given Element satisfies Object {
    
    "Determines whether this is a linked hash set with a
     stable iteration order."
    Stability stability;
    
    "Performance-related settings for the backing array."
    Hashtable hashtable;
    
    "Array of linked lists where we store the elements.
     
     Each element is stored in a linked list from this array
     at the index of the hash code of the element, modulo 
     the array size."
    variable Array<CachingCell<Element>?> store;
    
    "The initial elements of the set."
    {Element*} elements;
    
    "Number of elements in this set."
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
    variable LinkedCell<Element>? head = null;
    
    "Tip of the traversal linked list if in `linked` mode."
    variable LinkedCell<Element>? tip = null;
    
    Boolean accurateInitialCapacity;
    
    "Create a new `HashSet` with the given initial elements."
    shared new (
        "Determines whether this is a linked hash set with a
         stable iteration order, defaulting to [[linked]]
         (stable)."
        Stability stability = linked,
        "Performance-related settings for the backing array."
        Hashtable hashtable = Hashtable(),
        "The initial elements of the set, defaulting to no
         initial elements."
        {Element*} elements = {}) {
        
        this.stability = stability;
        this.hashtable = hashtable;
        this.elements = elements;
        
        length = 0;
        
        // For Collections, we can efficiently obtain an 
        // accurate initial capacity. For a generic iterable,
        // just use the given initialCapacity.
        accurateInitialCapacity
                = elements is Collection<Anything>;
        value initialCapacity
                = accurateInitialCapacity
                then hashtable.initialCapacityForSize(elements.size)
                else hashtable.initialCapacityForUnknownSize();
        
        store = cachingElementStore<Element>(initialCapacity);
    }
    
    "Create a new `HashSet` with the same initial elements
     as the given [[hashSet]]."
    shared new copy(
        "The `HashSet` to copy."
        HashSet<Element> hashSet,
        "Determines whether this is a linked hash set with a
         stable iteration order, defaulting to the stability
         of the copied `HashSet`."
        Stability stability = hashSet.stability,
        "Performance-related settings for the backing array."
        Hashtable hashtable = Hashtable()) {
        
        this.stability = stability;
        this.hashtable = hashtable;
        
        accurateInitialCapacity = true;
        store = cachingElementStore<Element>(hashSet.store.size);
        
        if (stability == unlinked) {
            elements = {};
            length = hashSet.length;
            variable Integer index = 0;
            // walk every bucket
            while (index < hashSet.store.size) {
                if (exists bucket
                        = hashSet.store[index]) {
                    store[index] = bucket.clone();
                }
                index++;
            }
        } 
        else {
            //TODO!!!!
            length = 0;
            elements = hashSet;
        }
    }
    
    // Write
    
    function hashCode(Object key)
            => let (h = key.hash)
                h.xor(h.rightLogicalShift(16));
    
    Integer storeIndex(Integer elemHash,
        Array<CachingCell<Element>?> store)
            => elemHash.and(store.size - 1);
    //=> (elem.hash % store.size).magnitude;
    
    CachingCell<Element> createCell(Element elem,
        Integer elemHash,
        CachingCell<Element>? rest) {
        if (stability == linked) {
            value cell 
                    = LinkedCell(elem, elemHash, rest, tip);
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
            return CachingCell(elem, elemHash, rest);
        }
    }
    
    void deleteCell(CachingCell<Element> cell) {
        if (stability == linked) {
            assert (is LinkedCell<Element> cell);
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
    
    Boolean addToStore(Array<CachingCell<Element>?> store,
        Element element) {
        value elementHash = hashCode(element);
        Integer index = storeIndex(elementHash, store);
        value headBucket = store[index];
        variable value bucket = headBucket;
        while (exists cell = bucket) {            
            if (cell.keyHash == elementHash
                    && cell.element == element) {
                // modify an existing entry
                cell.element = element;
                return false;
            }
            bucket = cell.rest;
        }
        // add a new entry
        store[index]
            = createCell(element, elementHash, headBucket);
        return true;
    }
    
    void checkRehash() {
        if (hashtable.rehash(length, store.size)) {
            // must rehash
            value newStore 
                    = cachingElementStore<Element>
                        (hashtable.capacity(length));
            variable Integer index = 0;
            // walk every bucket
            while (index < store.size) {
                variable value bucket = store[index];
                while (exists cell = bucket) {
                    bucket = cell.rest;
                    Integer newIndex
                            = storeIndex(cell.keyHash,
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
    for (val in elements) {
        if (addToStore(store, val)) {
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
    
    shared actual Boolean add(Element element) {
        if (addToStore(store, element)) {
            length++;
            checkRehash();
            return true;
        }
        return false;
    }
    
    shared actual Boolean addAll({Element*} elements) {
        variable Boolean ret = false;
        for (elem in elements) {
            if (addToStore(store, elem)) {
                length++;
                ret = true;
            }
        }
        if (ret) {
            checkRehash();
        }
        return ret;
    }
    
    shared actual Boolean remove(Element element) {
        value elementHash = hashCode(element);
        Integer index = storeIndex(elementHash, store);
        if (exists head = store[index],
            head.element == element) {
            store[index] = head.rest;
            deleteCell(head);
            length--;
            return true;
        }
        variable value bucket = store[index];
        while (exists cell = bucket) {
            value rest = cell.rest;
            if (exists rest,
                rest.keyHash == elementHash,
                rest.element == element) {
                cell.rest = rest.rest;
                deleteCell(rest);
                length--;
                return true;
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
    
    iterator() => stability == linked
            then LinkedCellIterator(head)
            else CachingStoreIterator(store);
    
    shared actual Integer count
            (Boolean selecting(Element element)) {
        variable Integer count = 0;
        variable Integer index = 0;
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
    
    shared actual void each(void step(Element element)) {
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
        if (is HashSet<Anything> that,
            this===that) {
            return true;
        }
        else if (is Set<> that, that.size==length) {
            variable value index = 0;
            // walk every bucket
            while (index < store.size) {
                variable value bucket = store[index];
                while (exists cell = bucket) {
                    if (!cell.element in that) {
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
    
    shared actual HashSet<Element> clone() => copy(this);
    
    shared actual Boolean contains(Object element) {
        if (empty) {
            return false;
        }
        else {
            value elementHash = hashCode(element);
            Integer index = storeIndex(elementHash, store);
            variable value bucket = store[index];
            while (exists cell = bucket) {                
                if (cell.keyHash == elementHash
                        && cell.element == element) {
                    return true;
                }
                bucket = cell.rest;
            }
            return false;
        }
    }
    
    shared actual HashSet<Element> complement<Other>
            (Set<Other> set)
            given Other satisfies Object {
        value ret = HashSet<Element>();
        for (elem in this) {
            if (!(elem in set)) {
                ret.add(elem);
            }
        }
        return ret;
    }
    
    shared actual HashSet<Element|Other> exclusiveUnion<Other>
            (Set<Other> set)
            given Other satisfies Object {
        value ret = HashSet<Element|Other>();
        for (elem in this) {
            if (!(elem in set)) {
                ret.add(elem);
            }
        }
        for (elem in set) {
            if (!(elem in this)) {
                ret.add(elem);
            }
        }
        return ret;
    }
    
    shared actual HashSet<Element&Other> intersection<Other>
            (Set<Other> set)
            given Other satisfies Object {
        value ret = HashSet<Element&Other>();
        for (elem in this) {
            if (elem in set, is Other elem) {
                ret.add(elem);
            }
        }
        return ret;
    }
    
    shared actual HashSet<Element|Other> union<Other>
            (Set<Other> set)
            given Other satisfies Object {
        value ret = HashSet<Element|Other>();
        ret.addAll(this);
        ret.addAll(set);
        return ret;
    }
    
    shared actual Element? first 
            => if (stability == linked)
                then head?.element
                else store.coalesced.first?.element;
    
    shared actual Element? last {
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
}
