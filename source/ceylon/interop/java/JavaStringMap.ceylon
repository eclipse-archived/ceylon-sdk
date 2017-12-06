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

"A [[Map]] with keys of type `java.lang::String` that wraps 
 a `Map` with keys of type `String`.

     JavaMap(JavaStringMap(ceylonMap))"
shared class JavaStringMap<Item>(Map<String,Item> map)
        satisfies Map<JString,Item> {

    shared actual default JavaStringMap<Item> clone() 
            => JavaStringMap(map.clone());
    
    defines(Object key)
    // don't forward non-Strings; otherwise, what to do
    // when the arg is java.lang.String?
        => if (is JString key)
        then map.defines(key.string)
        else false;
    
    get(Object key)
    // don't forward non-Strings; otherwise, what to do
    // when the arg is java.lang.String?
        => if (is JString key)
        then map[key.string]
        else null;
    
    iterator()
        => { for (key->item in map)
                nativeString(key)->item
           }.iterator();
    
    size => map.size;
    
    empty => map.empty;
    
    equals(Object that)
        => (super of Map<JString, Item>).equals(that);
    
    hash => (super of Map<JString, Item>).hash;
    
}