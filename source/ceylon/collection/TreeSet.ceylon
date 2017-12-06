/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
"A [[MutableSet]] implemented using a red/black tree.
 Elements of the set are maintained in a sorted order, from
 smallest to largest, as determined by the given
 [[comparator function|compare]]."
see (`function naturalOrderTreeSet`)
by ("Gavin King")
shared serializable class TreeSet<Element>
        satisfies MutableSet<Element>
                  & SortedSet<Element>
                  & Ranged<Element,Element,TreeSet<Element>>
        given Element satisfies Object {
    
    "A comparator function used to sort the elements."
    Comparison compare(Element x, Element y);
    
    TreeMap<Element,Element> map;
    
    "Create a new `TreeSet` with the given 
     [[comparator function|compare]] and [[elements]]."
    shared new (
        "A comparator function used to sort the elements."
        Comparison compare(Element x, Element y), 
        "The initial elements of the set."
        {Element*} elements = {}) {
        this.compare = compare;
        map = TreeMap {
            compare = compare;
            entries = elements.map((elem) => elem->elem);
        };
    }
    
    "Create a new `TreeMap` with the same comparator 
     function and elements as the given [[treeSet]]."
    shared new copy(TreeSet<Element> treeSet) {
        compare = treeSet.compare;
        map = treeSet.map.clone();
    }
    
    contains(Object element) => map.defines(element);
    
    add(Element element) => !map.put(element, element) exists;
    
    remove(Element element) => map.remove(element) exists;
    
    clear() => map.clear();
    
    iterator() => map.keys.iterator();
    
    first => map.first?.key;
    last => map.last?.key;
    
    higherElements(Element element)
            => map.higherEntries(element)
                .map(Entry.key);
    
    lowerElements(Element element)
            => map.lowerEntries(element)
                .map(Entry.key);
    
    ascendingElements(Element from, Element to) 
            => higherElements(from)
                .takeWhile((element)
                    => compare(element,to)!=larger);
    
    descendingElements(Element from, Element to) 
            => lowerElements(from)
                .takeWhile((element)
                    => compare(element,to)!=smaller);
    
    measure(Element from, Integer length)
            => TreeSet(compare, 
                    higherElements(from)
                            .take(length));
    
    span(Element from, Element to) 
            => let (reverse = compare(from,to)==larger)
    TreeSet {
        compare(Element x, Element y) 
                => reverse then compare(y,x) 
                           else compare(x,y); 
        elements = reverse then descendingElements(from,to)
                           else ascendingElements(from,to);
    };
    
    spanFrom(Element from)
            => TreeSet(compare, higherElements(from));
    
    spanTo(Element to)
            => TreeSet(compare, 
                takeWhile((element)
                    => compare(element,to)!=larger));
    
    shared actual TreeSet<Element> clone() => copy(this);
    
    shared actual HashSet<Element> complement<Other>
            (Set<Other> set)
            given Other satisfies Object {
        value result = HashSet<Element>();
        for (element in this) {
            if (!(element in set)) {
                result.add(element);
            }
        }
        return result;
    }
    
    shared actual HashSet<Element|Other> exclusiveUnion<Other>
            (Set<Other> set)
            given Other satisfies Object {
        value result = HashSet<Element|Other>();
        for (element in this) {
            if (!(element in set)) {
                result.add(element);
            }
        }
        for (element in set) {
            if (!(element in this)) {
                result.add(element);
            }
        }
        return result;
    }
    
    shared actual HashSet<Element&Other> intersection<Other>
            (Set<Other> set)
            given Other satisfies Object {
        value result = HashSet<Element&Other>();
        for (element in this) {
            if (element in set, is Other element) {
                result.add(element);
            }
        }
        return result;
    }
    
    shared actual HashSet<Element|Other> union<Other>
            (Set<Other> set)
            given Other satisfies Object {
        value result = HashSet<Element|Other>();
        result.addAll(this);
        result.addAll(set);
        return result;
    }
    
    equals(Object that)
            => (super of Set<Element>).equals(that);
    
    hash => (super of Set<Element>).hash;

}

"Create a [[TreeSet]] with [[comparable|Comparable]] keys,
 sorted by the natural ordering of the keys."
shared TreeSet<Element> naturalOrderTreeSet<Element>
        ({<Element>*} entries)
        given Element satisfies Comparable<Element>
        => TreeSet((Element x, Element y) => x<=>y, entries);
