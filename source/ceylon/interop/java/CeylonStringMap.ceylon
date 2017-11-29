/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
import java.lang {
    JString=String,
    Types {
        nativeString
    }
}

"A [[Map]] with keys of type `String` that wraps a `Map`
 with keys of type `java.lang::String`.

 This class can be used to wrap a `java.util::Map` if the
 Java map is first wrapped with [[CeylonMap]]:

     CeylonStringMap(CeylonMap(javaMap))

 If the given map is a [[ceylon.collection::MutableMap]],
 use [[CeylonStringMutableMap]]."
shared class CeylonStringMap<out Item>(Map<JString, Item> map)
        satisfies Map<String, Item> {

    shared actual default CeylonStringMap<Item> clone()
        => CeylonStringMap(map.clone());

    defines(Object key)
        // don't forward non-Strings; otherwise, what to do
        // when the arg is java.lang.String?
        => if (is String key)
           then map.defines(nativeString(key))
           else false;

    get(Object key)
        // don't forward non-Strings; otherwise, what to do
        // when the arg is java.lang.String?
        => if (is String key)
           then map[nativeString(key)]
           else null;

    iterator()
        => { for (key->item in map)
                key.string->item
           }.iterator();

    empty => map.empty;
            
    size => map.size;

    equals(Object that)
        => (super of Map<String, Item>).equals(that);

    hash => (super of Map<String, Item>).hash;
}
