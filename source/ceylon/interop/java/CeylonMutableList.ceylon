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
    MutableList
}

import java.util {
    JList=List,
    ArrayList,
    Collections {
        singleton
    }
}

"A Ceylon [[MutableList]] that wraps a [[java.util::List]].

 If the given [[list]] contains null elements, an optional
 [[Element]] type must be explicitly specified, for example:

     CeylonMutableList<String?>(javaStringList)

 If a non-optional `Element` type is specified, an
 [[AssertionError]] will occur whenever a null value is
 encountered while iterating the list."
shared class CeylonMutableList<Element>(list)
        extends CeylonList<Element>(list)
        satisfies MutableList<Element> 
        given Element satisfies Object {

    JList<Element> list;

    add(Element element) => list.add(element);
    
    set(Integer index, Element element) 
            => list[index] = element;
    
    insert(Integer index, Element element) 
            => list.add(index, element);
    
    shared actual Integer remove(Element element) {
        value size = list.size();
        list.removeAll(singleton(element));
        return size-list.size();
    }
    
    delete(Integer index) => list.remove(index);
    
    clear() => list.clear();
    
    shared actual Boolean removeFirst(Element element) 
            => list.remove(element);
    
    shared actual Boolean removeLast(Element element) {
        for (i in (0:size).reversed) {
            if (exists e = list[i],
                e==element) {
                list.remove(i);
                return true;
            }
        }
        return false;
    }
    
    shared actual Element? findAndRemoveFirst(
        Boolean selecting(Element element)) {
        value it = list.iterator();
        while (it.hasNext()) {
            value item = it.next();
            if (selecting(item)) {
                it.remove();
                return item;
            }
        }
        return null;
    }
    
    shared actual Element? findAndRemoveLast(
        Boolean selecting(Element element)) {
        value it = list.listIterator(list.size());
        while (it.hasPrevious()) {
            value item = it.previous();
            if (selecting(item)) {
                it.remove();
                return item;
            }
        }
        return null;
    }
    
    shared actual Integer removeWhere(
        Boolean selecting(Element element)) {
        variable Integer count = 0;
        value it = list.iterator();
        while (it.hasNext()) {
            if (selecting(it.next())) {
                it.remove();
                count++;
            }
        }
        return count;
    }
    
    shared actual void deleteMeasure(Integer from, Integer length) {
        value iterator = list.iterator();
        variable value i = 0;
        value measure = from:length;
        while (iterator.hasNext()) {
            iterator.next();
            if (i in measure) {
                iterator.remove();
            }
            i++;
        }
    }
    
    shared actual void deleteSpan(Integer from, Integer to) {
        value iterator = list.iterator();
        variable value i = 0;
        value span = from..to;
        while (iterator.hasNext()) {
            iterator.next();
            if (i in span) {
                iterator.remove();
            }
            i++;
        }
    }
    
    shared actual Integer prune() {
        value iterator = list.iterator();
        variable value removed = 0;
        while (iterator.hasNext()) {
            if (!iterator.next() exists) {
                removed++;
                iterator.remove();
            }
        }
        return removed;
    }
    
    shared actual Integer replace(Element element, 
        Element replacement) {
        variable value count = 0;
        for (i in 0:size) {
            if (exists e = list[i],
                e==element) {
                list[i] = replacement;
                count++;
            }
        }
        return count;
    }
    
    shared actual void infill(Element replacement) {
        for (i in 0:size) {
            if (!list[i] exists) {
                list[i] = replacement;
            }
        }
    }
    
    shared actual Boolean replaceFirst(Element element, 
        Element replacement) {
        for (i in 0:size) {
            if (exists e = list[i],
                e==element) {
                list[i] = replacement;
                return true;
            }
        }
        return false;
    }
    
    shared actual Boolean replaceLast(Element element, 
        Element replacement) {
        for (i in (0:size).reversed) {
            if (exists e = list[i],
                e==element) {
                list[i] = replacement;
                return true;
            }
        }
        return false;
    }
    
    shared actual Element? findAndReplaceFirst(
        Boolean selecting(Element element), 
        Element replacement) {
        for (i in 0:size) {
            if (exists element = list[i],
                selecting(element)) {
                list[i] = replacement;
                return element;
            }
        }
        return null;
    }
    
    shared actual Element? findAndReplaceLast(
        Boolean selecting(Element element), 
        Element replacement) {
        for (i in (0:size).reversed) {
            if (exists element = list[i],
                selecting(element)) {
                list[i] = replacement;
                return element;
            }
        }
        return null;
    }
    
    shared actual Integer replaceWhere(
        Boolean selecting(Element element), 
        Element replacement) {
        variable value count = 0;
        for (i in 0:size) {
            if (exists element = list[i],
                selecting(element)) {
                list[i] = replacement;
                count++;
            }
        }
        return count;
    }
    
    shared actual void truncate(Integer size) {
        value iterator = list.iterator();
        variable value i = 0;
        while (iterator.hasNext()) {
            iterator.next();
            if (i>=size) {
                iterator.remove();
            }
            i++;
        }
    }
    
    clone() => CeylonMutableList(ArrayList(list));

}