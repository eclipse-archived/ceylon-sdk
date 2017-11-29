/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
"Returns if two ranges has intersection."
shared Boolean intersect<Value>( Value start, Value end, Value otherStart, Value otherEnd ) given Value satisfies Comparable<Value> {
    return start <= otherEnd && end >= otherStart;
}

"Returns the inclusive overlap between two ordinal ranges.
 
 The range of the overlap will be returned in the natural order of the values regardless of their original order in input tuples.
 
 Examples:
 
     assert(overlap([1, 3], [2, 4]) == [2, 3]);
     assert(overlap([4, 2], [1, 3]) == [2, 3]);
     assert(is Empty o = overlap([1, 2], [3, 4]));
 "
shared [Value, Value]|Empty overlap<Value>([Value, Value] first, [Value, Value] second)
       given Value satisfies Enumerable<Value>&Comparable<Value> {
    value ordered = sort(concatenate(first, second)).measure(1, 2); // take the middle two

    if (span(*first).containsEvery(ordered) && span(*second).containsEvery(ordered)) {
        assert(exists start = ordered.first);
        assert(exists end = ordered.last);

        return [start, end];
    }

    return empty;
}

"Returns a tuple representing an exclusive gap between two disjoint ranges of ordinal values.
 
 Values in the tuple are returned always in their natural order regardless of their original ordering in the input tuples. 
 If input ranges are overlapping, this function will return an empty value.
 
 Examples:

     assert(gap([1, 2], [5, 6]) == [3, 4]);
     assert(gap([6, 5], [1, 2]) == [3, 4]);
     assert(is Empty g = gap([1, 3], [2, 4]));
 "
shared [Value, Value]|Empty gap<Value>([Value, Value] first, [Value, Value] second)
       given Value satisfies Comparable<Value> & Enumerable<Value> {

    value ordered = sort(concatenate(first, second)).measure(1, 2); // take the middle two
    if (span(*first).containsEvery(ordered) && span(*second).containsEvery(ordered)) {
        return empty;
    }
    
    assert(exists start = ordered.first);
    assert(exists end = ordered.last);

    return [start, end];
}
