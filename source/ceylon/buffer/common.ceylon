/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
void resizeBuffer<Value>(newSize, growLimit, current, intoNew) {
    Integer newSize;
    Boolean growLimit;
    Buffer<Value> current;
    Anything() intoNew;
    
    if (newSize == current.capacity) {
        return;
    }
    assert (newSize >= 0);
    // save our position and limit
    value position = smallest(current.position, newSize);
    Integer limit;
    if (newSize < current.capacity) {
        // shrink the limit
        limit = smallest(current.limit, newSize);
    } else if (growLimit && current.limit==current.capacity) {
        // grow the limit if it was the max and we want that
        limit = newSize;
    } else {
        // keep it if it was less than max
        limit = current.limit;
    }
    // copy everything unless we shrink
    value copyUntil = smallest(current.capacity, newSize);
    // prepare our limits for copying
    current.position = 0;
    current.limit = copyUntil;
    // copy and change buffer implementation
    intoNew();
    // now restore positions
    current.limit = limit;
    current.position = position;
}
