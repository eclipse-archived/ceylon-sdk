/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
"Produces a [[Map]] grouping the given [[elements]] into 
 sequences under the group keys provided by the given 
 [[grouping function|grouping]]."
shared Map<Group,[Element+]> group<Group, Element>
        ({Element*} elements, grouping)
        given Group satisfies Object {
    
    "A function that returns the group key under which to 
     group the specified element."
    Group grouping(Element element);
    
    /*
     We've no idea how long the iterable is, nor how 
     selective the grouping function is, so it's really 
     hard to accurately estimate the size of the HashMap.
    */
    value map = HashMap<Group,ArrayList<Element>>();
    for (element in elements) {
        Group group = grouping(element);
        if (exists list = map[group]) {
            list.add(element);
        }
        else {
            value list = ArrayList<Element>();
            list.add(element);
            map[group] = list;
        }
    }
    [Element+] mapping(Group group, ArrayList<Element> list) { 
        assert(is [Element+] result = list.sequence());
        return result;
    }
    return map.mapItems(mapping);
}
