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
    AbstractCollection
}

"A Java [[java.util::Collection]] that wraps a Ceylon
 [[Collection]]. This collection is unmodifiable, throwing 
 [[java.lang::UnsupportedOperationException]] from mutator 
 methods."
shared class JavaCollection<E>(Collection<E?> collection)
        extends AbstractCollection<E>() {
    
    iterator() => JavaIterator(collection.iterator());
    
    size() => collection.size;
    
    shared actual Boolean equals(Object that) {
        //TODO: this does not obey the contract of Collection
        if (is JavaCollection<out Anything> that) {
            return collection==that.collection;
        }
        else {
            return false;
        }
    }
    
    shared actual Integer hash => collection.hash;
    
}

