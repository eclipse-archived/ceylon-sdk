/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
"A [[Map]] supporting addition of new entries and removal of
 existing entries."
see (`class HashMap`)
by("Stéphane Épardaud")
shared interface MutableMap<Key=Object, Item=Anything>
        satisfies Map<Key, Item>
                & MapMutator<Key, Item>
        given Key satisfies Object {
    
    "Add an entry to this map, overwriting any existing 
     entry for the given [[key]], and returning the previous 
     item associated with the given `key`, if any, or
     `null` if no existing entry was overwritten.

     Note that, while `map.put(key, item)` is often written
     as `map[key] = item`, the two expressions are not
     equivalent, since `put()` returns the item _previously_
     associated with `key`, whereas an assignment expression
     always evaluates to the newly assigned value."
    shared formal actual Item? put(Key key, Item item);
    
    "Remove the entry associated with the given [[key]], if 
     any, from this map, returning the item no longer
     associated with the given `key`, if any, or `null` if
     there was no entry associated with the given `key`."
    shared formal actual Item? remove(Key key);
    
    shared actual formal MutableMap<Key, Item> clone();
    
}

"Protocol for mutation of a [[MutableMap]]."
see (`interface MutableMap`)
shared interface MapMutator<in Key=Object, in Item=Anything>
        satisfies Map<Object, Anything>
                & KeyedCorrespondenceMutator<Key, Item>
        given Key satisfies Object {
    
    "Add an entry to this map, overwriting any existing 
     entry for the given [[key]], and returning the previous 
     item associated with the given `key`, if any, or
     `null` if no existing entry was overwritten.

     Note that, while `map.put(key, item)` is often written
     as `map[key] = item`, the two expressions are not
     equivalent, since `put()` returns the item _previously_
     associated with `key`, whereas an assignment expression
     always evaluates to the newly assigned value."
    shared actual formal Anything put(Key key, Item item);
    
    "Add the given [[entries]] to this map, overwriting any 
     existing entries with the same keys."
    shared default void putAll({<Key->Item>*} entries) {
        for (key->item in entries) {
            put(key, item);
        }
    }
    
    "Remove the entry associated with the given [[key]], if 
     any, from this map, returning the value no longer 
     associated with the given `key`, if any, or `null` if
     there was no entry associated with the given `key`."
    shared formal Anything remove(Key key);
    
    "Remove the entry associated with the given [[key]], if 
     any, only if its item is equal to the given [[item]]. 
     Return [[true]] if an entry was removed, or [[false]] 
     otherwise."
    shared default Boolean removeEntry(Key key,
        "The item currently associated with the given [[key]]" 
        Item&Object item) {
        if (exists it=get(key), it==item) {
            remove(key);
            return true;
        }
        else {
            return false;
        }
    }
    
    "Modify the entry associated with the given [[key]], if 
     any, setting its item to the given [[newItem]], only if 
     the its item is currently equal to the given [[item]]. 
     Return [[true]] if the item was replaced,or [[false]] 
     otherwise."
    shared default Boolean replaceEntry(Key key, 
        "The item currently associated with the given [[key]]"
        Item&Object item,
        "The new item to associate with the given [[key]]" 
        Item newItem) {
        if (exists it=get(key), it==item) {
            put(key,item);
            return true;
        }
        else {
            return false;
        }
    }
    
    "Remove the entries associated with the given [[keys]], 
     if any, from this map."
    shared default void removeAll({Key*} keys) {
        for (key in keys) {
            remove(key);
        }
    }
    
    "Remove every entry from this map, leaving an empty map
     with no entries."
    shared formal void clear();
    
    shared formal actual MapMutator<Key,Item> clone();
    
}
