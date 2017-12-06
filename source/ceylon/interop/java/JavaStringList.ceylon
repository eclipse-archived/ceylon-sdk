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

"A [[List]] with keys of type `java.lang::String` that wraps
 a `List` with keys of type `String`.

     JavaList(JavaStringList(ceylonList))"
shared class JavaStringList(List<String> list)
        satisfies List<JString> {

    getFromFirst(Integer index)
            => if (exists string = list[index])
            then nativeString(string)
            else null;

    contains(Object element)
            => if (is JString element)
            then element.string in list
            else false;

    lastIndex => list.lastIndex;

    size => list.size;

    shared actual default JavaStringList clone()
            => JavaStringList(list.clone());

    hash => (super of List<JString>).hash;

    equals(Object that) => (super of List<JString>).equals(that);


}