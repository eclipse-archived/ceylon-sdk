/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
import ceylon.collection {
    MutableMap
}

import java.lang {
    JString=String,
    Types {
        nativeString
    }
}

"A [[MutableMap]] with keys of type `ceylon.language::String`
 that wraps a `MutableMap` with keys of type `java.lang::String`.

 This class can be used to wrap a `java.util::Map` if the
 Java map is first wrapped with [[CeylonMutableMap]]:

        CeylonStringMutableMap(CeylonMutableMap(javaMap))

 If the given list is not a [[MutableMap]], use [[CeylonStringMap]]."
shared class CeylonStringMutableMap<Item>
    (MutableMap<JString, Item> map)
        extends CeylonStringMap<Item>(map)
        satisfies MutableMap<String, Item> {

    clear() =>  map.clear();

    shared actual CeylonStringMutableMap<Item> clone()
        => CeylonStringMutableMap(map.clone());

    put(String key, Item item)
        => map.put(nativeString(key), item);

    remove(String key)
        => map.remove(nativeString(key));
}
