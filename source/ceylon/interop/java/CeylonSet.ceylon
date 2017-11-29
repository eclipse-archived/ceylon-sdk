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
    JSet=Set,
    HashSet
}

"A Ceylon [[Set]] that wraps a [[java.util::Set]]."
shared class CeylonSet<out Element>(set)
        extends CeylonCollection<Element>(set)
        satisfies Set<Element> 
        given Element satisfies Object {

    JSet<out Element> set;
    
    iterator() => CeylonIterator(set.iterator());
    
    contains(Object element) => set.contains(element);

    size => set.size();

    shared actual Set<Element> 
            complement<Other>(Set<Other> set)
            given Other satisfies Object {
        value complement = HashSet<Element>();
        for (e in this) {
            if (!e in set) {
                complement.add(e);
            }
        }
        return CeylonSet(complement);
    }
    
    shared actual Set<Element|Other> 
            exclusiveUnion<Other>(Set<Other> set)
            given Other satisfies Object {
        value exclusiveUnion = HashSet<Element|Other>();
        for (e in this) {
            if (!e in set) {
                exclusiveUnion.add(e);
            }
        }
        for (e in set) {
            if (!this.set.contains(e)) {
                exclusiveUnion.add(e);
            }
        }
        return CeylonSet(exclusiveUnion);
    }
    
    shared actual Set<Element&Other> 
            intersection<Other>(Set<Other> set)
            given Other satisfies Object {
        value intersection = HashSet<Element&Other>();
        for (e in this) {
            if (is Other e, e in set) {
                intersection.add(e);
            }
        }
        return CeylonSet(intersection);
    }
    
    shared actual Set<Element|Other> 
            union<Other>(Set<Other> set)
            given Other satisfies Object {
        value union = HashSet<Element|Other>();
        for (e in this) {
            union.add(e);
        }
        for (e in set) {
            union.add(e);
        }
        return CeylonSet(union);
    }
    
    shared actual default Set<Element> clone()
            => CeylonSet(HashSet(set));
    
    equals(Object that) 
            => (super of Set<Element>).equals(that);
    
    hash => (super of Set<Element>).hash;
    
}