/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
"Produces a [[Map]] mapping elements to frequencies, where 
 each entry maps a distinct member of the given iterable
 [[elements]] to the number of times it occurs among the 
 given `elements`."
shared Map<Element,Integer> frequencies<Element>
        ({Element*} elements)
        given Element satisfies Object {
    /*
     We've no idea how long the iterable is, nor how 
     selective the grouping function is, so it's really 
     hard to accurately estimate the size of the HashMap.
    */
    value map = HashMap<Element,Counter>();
    for (element in elements) {
        if (exists counter = map[element]) {
            counter.count++;
        }
        else {
            map[element] = Counter(1);
        }
    }
    return map.mapItems((e, c) => c.count);
}

class Counter(count) {
    shared variable Integer count;
}
