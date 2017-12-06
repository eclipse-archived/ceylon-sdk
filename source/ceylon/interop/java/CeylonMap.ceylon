/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
import java.util {
    JMap=Map,
    HashMap
}

"A Ceylon [[Map]] that wraps a [[java.util::Map]].

 If the given [[map]] contains null elements, an optional
 [[Item]] type must be explicitly specified, for example:

     CeylonMap<String,Object?>(javaStringObjectMap)

 If a non-optional `Item` type is specified, an
 [[AssertionError]] will occur whenever a null item is
 encountered while iterating the map."
shared class CeylonMap<out Key, out Item>(map)
        satisfies Map<Key, Item> 
        given Key satisfies Object {

    JMap<out Key, out Item> map;
    
    get(Object key) => map.get(key);
    
    defines(Object key) => map.containsKey(key);
    
    size => map.size();

    keys => CeylonSet(map.keySet());

    items => CeylonCollection(map.values());

    function ceylonEntry(JMap.Entry<out Key, out Item> entry) {
        "Java map entry with null key"
        assert (exists key = entry.key);
        if (exists item = entry.\ivalue) {
            return key -> item;
        }
        else {
            "Java map entry with null item"
            assert (is Item null);
            return key -> null;
        }
    }

    iterator()
            => CeylonIterable(map.entrySet())
                .map(ceylonEntry)
                .iterator();

    shared actual default Map<Key, Item> clone()
            => CeylonMap(HashMap(map));
    
    equals(Object that) 
            => (super of Map<Key,Item>).equals(that);
    
    hash => (super of Map<Key,Item>).hash;
    
}