/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
// FIXME: make this faster with a size check
class StoreIterator<Element>(Array<Cell<Element>?> store) 
        satisfies Iterator<Element> {
    variable Integer index = 0;
    variable value bucket = store[index];
    
    shared actual Element|Finished next() {
        // do we need a new bucket?
        if (!bucket exists) {
            // find the next non-empty bucket
            while (++index < store.size) {
                bucket = store[index];
                if (bucket exists) {
                    break;
                }
            }
        }
        // do we have a bucket?
        if (exists bucket = bucket) {
            value car = bucket.element;
            // advance to the next cell
            this.bucket = bucket.rest;
            return car;
        }
        return finished;
    }
}

// FIXME: make this faster with a size check
class CachingStoreIterator<Element>(Array<CachingCell<Element>?> store) 
        satisfies Iterator<Element> {
    variable Integer index = 0;
    variable value bucket = store[index];
    
    shared actual Element|Finished next() {
        // do we need a new bucket?
        if (!bucket exists) {
            // find the next non-empty bucket
            while (++index < store.size) {
                bucket = store[index];
                if (bucket exists) {
                    break;
                }
            }
        }
        // do we have a bucket?
        if (exists bucket = bucket) {
            value car = bucket.element;
            // advance to the next cell
            this.bucket = bucket.rest;
            return car;
        }
        return finished;
    }
}