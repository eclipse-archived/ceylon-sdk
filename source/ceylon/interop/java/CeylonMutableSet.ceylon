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
    MutableSet
}

import java.util {
    JSet=Set,
    HashSet
}

"A Ceylon [[MutableSet]] that wraps a [[java.util::Set]]."
shared class CeylonMutableSet<Element>(set)
        extends CeylonSet<Element>(set)
        satisfies MutableSet<Element> 
        given Element satisfies Object {

    JSet<Element> set;

    add(Element element) => set.add(element);
    
    remove(Element element) => set.remove(element);
    
    clear() => set.clear();
    
    clone() => CeylonMutableSet(HashSet(set));
    
}