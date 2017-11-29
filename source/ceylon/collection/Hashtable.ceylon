/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
"Performance-related settings for a hashtable based 
 collection like [[HashMap]] or [[HashSet]].
 
 The size of the backing [[Array]] is called the _capacity_
 of the hashtable.
 
 - The capacity of a new instance is specified by the given 
   [[initialCapacity]].
 - The capacity is increased, and the elements _rehashed_, 
   when the ratio of collection size to capacity exceeds the 
   given [[loadFactor]].
 - The new capacity is the product of the current capacity 
   and the given [[growthFactor]]."
shared serializable class Hashtable(
    initialCapacity=16, 
    loadFactor=0.75, 
    growthFactor=2.0
) {
    
    "The initial capacity of the backing array."
    shared Integer initialCapacity;
    
    "The ratio between the number of elements and the 
     capacity which triggers a rebuild of the hash set."
    shared Float loadFactor;
    
    "The factor used to determine the new size of the
     backing array when a new backing array is allocated."
    shared Float growthFactor;
    
    "initial capacity cannot be negative"
    assert (initialCapacity>=0);
    
    "initial capacity too large"
    assert (initialCapacity<=runtime.maxArraySize);
    
    "load factor must be positive"
    assert (loadFactor>0.0);
    
    "growth factor must be at least 1.0"
    assert (growthFactor>=1.0);
    
    shared Boolean rehash(Integer length, Integer capacity)
            => length > (capacity * loadFactor).integer &&
                    this.capacity(length)>capacity;
    
    shared Integer capacity(Integer length) 
            => powerOf2((length * growthFactor).integer);
    
    shared Integer initialCapacityForSize(Integer size) 
            => powerOf2(largest(initialCapacity, 
                        (size/loadFactor+1).integer));
    
    shared Integer initialCapacityForUnknownSize()
            => powerOf2(initialCapacity);
    
    Integer powerOf2(Integer capacity) {
        variable value n = capacity-1;
        n=n.rightLogicalShift(1).or(n);
        n=n.rightLogicalShift(2).or(n);
        n=n.rightLogicalShift(4).or(n);
        n=n.rightLogicalShift(8).or(n);
        n=n.rightLogicalShift(16).or(n);
        if (n < 0) { 
            return 1; 
        } 
        else if (n >= maximumCapacity) { 
            return maximumCapacity;
        }
        else {
            return n + 1;
        }
    }
    
}

Integer maximumCapacity = 1.leftLogicalShift(30);

