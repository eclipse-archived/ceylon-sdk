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
    JCollection=Collection,
    ArrayList
}

"A Ceylon [[Collection]] that wraps a [[java.util::Collection]]."
shared
class CeylonCollection<out Element>
        (JCollection<out Element> collection)
        satisfies Collection<Element> {

    shared actual default
    Integer size
        =>  collection.size();

    shared actual default
    Boolean contains(Object element)
        =>  collection.contains(element);

    shared actual default
    Collection<Element> clone()
        =>  CeylonCollection(ArrayList(collection));

    shared actual default
    Iterator<Element> iterator()
        =>  CeylonIterator(collection.iterator());

}
