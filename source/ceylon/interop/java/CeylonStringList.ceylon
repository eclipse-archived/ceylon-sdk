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

"A [[List]] with keys of type `String` that wraps a `List`
 with keys of type `java.lang::String`.

 This class can be used to wrap a `java.util::List` if the
 Java map is first wrapped with [[CeylonList]]:

     CeylonStringList(CeylonList(javaList))

 If the given list is a [[ceylon.collection::MutableList]],
 use [[CeylonStringMutableList]]."
shared class CeylonStringList(List<JString> list)
        satisfies List<String> {

    getFromFirst(Integer index)
            => if (exists string = list[index])
            then string.string
            else null;

    contains(Object element)
            => if (is String element)
            then nativeString(element) in list
            else false;

    lastIndex => list.lastIndex;

    size => list.size;

    shared actual default CeylonStringList clone()
            => CeylonStringList(list.clone());

    hash => (super of List<String>).hash;

    equals(Object that) => (super of List<String>).equals(that);


}