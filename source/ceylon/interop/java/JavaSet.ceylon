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
    SetMutator
}

import java.lang {
    UnsupportedOperationException,
    IllegalArgumentException
}
import java.util {
    AbstractSet,
    Collection
}
import java.io {
    Serializable
}

"A Java [[java.util::Set]] that wraps a Ceylon [[Set]]. This 
 set is unmodifiable, throwing 
 [[java.lang::UnsupportedOperationException]] from mutator 
 methods."
shared class JavaSet<E>(Set<E> set)
        extends AbstractSet<E>()
        satisfies Serializable 
        given E satisfies Object {
    
    iterator() => JavaIterator<E>(set.iterator());
    
    size() => set.size;
    
    shared actual Boolean add(E? e) {
        if (is SetMutator<E> set) {
            if (exists e) {
                return set.add(e);
            }
            else {
                throw IllegalArgumentException("set may not have null elements");
            }
        }
        else {
            throw UnsupportedOperationException("not a mutable set");
        }
    }
    
    shared actual Boolean remove(Object? e) {
        if (is SetMutator<E> set) {
            if (is E e) {
                return set.remove(e);
            }
            else {
                return false;
            }
        }
        else {
            throw UnsupportedOperationException("not a mutable set");
        }
    }
    
    shared actual Boolean removeAll(Collection<out Object> collection) {
        if (is SetMutator<E> set) {
            variable Boolean result = false;
            for (e in collection) {
                if (is E e, set.remove(e)) {
                    result = true;
                }
            }
            return result;
        }
        else {
            throw UnsupportedOperationException("not a mutable set");
        }
    }
    
    shared actual Boolean retainAll(Collection<out Object> collection) {
        if (is SetMutator<E> set) {
            variable Boolean result = false;
            for (e in set.clone()) { //TODO: is the clone really necessary?
                if (!e in collection) {
                    set.remove(e);
                    result = true;
                }
            }
            return result;
        }
        else {
            throw UnsupportedOperationException("not a mutable set");
        }
    }
    
    shared actual void clear() {
        if (is SetMutator<Nothing> set) {
            set.clear();
        }
        else {
            throw UnsupportedOperationException("not a mutable set");
        }
    }
    
}