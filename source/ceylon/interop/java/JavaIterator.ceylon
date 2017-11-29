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
    UnsupportedOperationException
}
import java.util {
    JIterator=Iterator
}

"A Java [[java.util::Iterator]] that wraps a Ceylon
 [[Iterator]]. This iterator is unmodifiable, throwing
 [[UnsupportedOperationException]] from [[remove]]."
shared class JavaIterator<T>(Iterator<T?> iterator)
        satisfies JIterator<T> {
    
    variable Boolean first = true;
    variable T?|Finished item = finished;
    
    shared actual Boolean hasNext() {
        if (first) {
            item = iterator.next();
            first = false;
        }
        return !item is Finished;
    }
    
    shared actual T? next() {
        if (first) {
            item = iterator.next();
            first = false;
        }
        value olditem = item;
        item = iterator.next();
        return
            if (!is Finished olditem)
            then olditem
            else null;
    }
    
    shared actual void remove() { 
        throw UnsupportedOperationException("remove()"); 
    }
    
}


