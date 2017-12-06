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
    MutableList
}

import java.lang {
    JString=String,
    Types {
        nativeString
    }
}

"A [[MutableList]] with elements of type `ceylon.language::String`
 that wraps a `MutableList` with elements of type `java.lang::String`.

 This class can be used to wrap a `java.util::List` if the
 Java list is first wrapped with [[CeylonMutableList]]:

        CeylonStringMutableList(CeylonMutableList(javaList))

 If the given list is not a [[MutableList]], use [[CeylonStringList]]."
shared class CeylonStringMutableList(MutableList<JString> list)
        extends CeylonStringList(list)
        satisfies MutableList<String> {

    add(String element) => list.add(nativeString(element));

    delete(Integer index) => list.delete(index)?.string;

    insert(Integer index, String element)
            => list.insert(index, nativeString(element));

    set(Integer index, String element)
            => list.set(index, nativeString(element));

    shared actual CeylonStringMutableList clone()
            => CeylonStringMutableList(list.clone());

}