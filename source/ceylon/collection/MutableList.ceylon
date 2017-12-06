/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
"A [[List]] supporting addition, insertion, removal, and
 replacement of its elements."
see (`class LinkedList`, `class ArrayList`)
by("Stéphane Épardaud")
shared interface MutableList<Element=Anything>
        satisfies List<Element>
                & ListMutator<Element> {

    "Remove the element at the specified [[index]],
     returning the removed element, if any, or `null` if
     there was no such element."
    shared actual formal Element? delete(Integer index);

    "Remove the element with index `0` from this list,
     returning the removed element, or `null` if there was
     no such element."
    shared actual default Element? deleteFirst() => delete(0);

    "Remove the element with index `size-1` from this list,
     returning the removed element, or `null` if there was
     no such element."
    shared actual default Element? deleteLast() => delete(size-1);

    "A new list with the same elements as this list."
    shared actual formal MutableList<Element> clone();
    
    shared actual default void swap(Integer i, Integer j) {
        "index may not be negative or greater than the
         last index in the list"
        assert (0<=i<size, 0<=j<size);
        if (i!=j) {
            assert (is Element x = getFromFirst(i),
                    is Element y = getFromFirst(j));
            set(i, y);
            set(j, x);
        }
    }
    
    shared actual default void move(Integer i, Integer j) {
        "index may not be negative or greater than the
         last index in the list"
        assert (0<=i<size, 0<=j<size);
        if (i!=j) {
            assert (is Element x = delete(i));
            insert(j, x);
        }
    }
    
    "Remove every element that satisfies the given 
     [[predicate function|selecting]] from this list, 
     returning the number of elements that were removed."
    shared default Integer removeWhere(
        "The predicate function the indexed elements must 
         satisfy."
        Boolean selecting(Element&Object element)) {
        variable value index = 0;
        variable value count = 0;
        while (index<size) {
            if (exists elem = getFromFirst(index),
                selecting(elem)) {
                delete(index);
                count++;
            }
            else {
                index++;
            }
        }
        return count;
    }
    
    shared actual default Integer prune() {
        variable value index = 0;
        variable value removed = 0;
        while (index<size) {
            if (!getFromFirst(index) exists) {
                removed++;
                delete(index);
            }
            else {
                index++;
            }
        }
        return removed;
    }
    
    shared actual default Integer remove(Element&Object element) 
            => removeWhere(element.equals);
    
    "Remove the first element that satisfies the given 
     [[predicate function|selecting]] from this list, 
     returning the removed element, or `null` if no such 
     element was found in this list."
    shared default Element? findAndRemoveFirst(
        "The predicate function the indexed elements must 
         satisfy."
        Boolean selecting(Element&Object element)) {
        if (exists index = firstIndexWhere(selecting)) {
            return delete(index);
        }
        else {
            return null;
        }
    }
    
    shared actual default Boolean removeFirst(Element&Object element) 
            => findAndRemoveFirst(element.equals) exists;
    
    "Remove the last element that satisfies the given 
     [[predicate function|selecting]] from this list, 
     returning the removed element, or `null` if no such 
     element was found in this list."
    shared default Element? findAndRemoveLast(
        "The predicate function the indexed elements must 
         satisfy."
        Boolean selecting(Element&Object element)) {
        if (exists index = lastIndexWhere(selecting)) {
            return delete(index);
        }
        else {
            return null;
        }
    }
    
    shared actual default Boolean removeLast(Element&Object element) 
            => findAndRemoveLast(element.equals) exists;
    
    "Replace every element in this list that satisfies the 
     given [[predicate function|selecting]] with the given 
     [[replacement]]."
    shared default Integer replaceWhere(
        "The predicate function the indexed elements must 
         satisfy."
        Boolean selecting(Element&Object element),
        "The replacement value"
        Element replacement) {
        variable value index = 0;
        variable value count = 0;
        while (index<size) {
            if (exists elem = getFromFirst(index),
                selecting(elem)) {
                set(index, replacement);
                count++;
            }
            index++;
        }
        return count;
    }
    
    shared actual default void infill(Element replacement) {
        variable value index = 0;
        while (index<size) {
            if (!getFromFirst(index) exists) {
                set(index, replacement);
            }
            index++;
        }
    }
    
    shared actual default Integer replace(
        Element&Object element, 
        Element replacement) 
            => replaceWhere(element.equals, replacement);
    
    "Replace the first element of this list that satisfies 
     the given [[predicate function|selecting]] with
     the given [[replacement]], returning the replaced 
     element, or `null` if no such element was found in this 
     list."
    shared default Element? findAndReplaceFirst(
        "The predicate function the indexed elements must 
         satisfy."
        Boolean selecting(Element&Object element),
        "The replacement value"
        Element replacement) {
        if (exists index = firstIndexWhere(selecting)) {
            value element = getFromFirst(index);
            set(index, replacement);
            return element;
        }
        else {
            return null;
        }
    }
    
    shared actual default Boolean replaceFirst(
        Element&Object element, 
        Element replacement) 
            => findAndReplaceFirst(element.equals, replacement) 
                exists;
    
    "Replace the last element of this list that satisfies 
     the given [[predicate function|selecting]] with
     the given [[replacement]], returning the replaced 
     element, or `null` if no such element was found in this 
     list."
    shared default Element? findAndReplaceLast(
        "The predicate function the indexed elements must 
         satisfy."
        Boolean selecting(Element&Object element),
        "The replacement value"
        Element replacement) {
        if (exists index = lastIndexWhere(selecting)) {
            value element = getFromFirst(index);
            set(index, replacement);
            return element;
        }
        else {
            return null;
        }
    }
    
    shared actual default Boolean replaceLast(
        Element&Object element, 
        Element replacement) 
            => findAndReplaceLast(element.equals, replacement) 
                exists;
    
}

"Protocol for mutation of a [[MutableList]]."
see (`interface MutableList`)
shared interface ListMutator<in Element=Anything>
        satisfies List<Anything>
                & IndexedCorrespondenceMutator<Element> {

    "Add the given [[element]] to the end of this list,
     incrementing the [[length|List.size]] of the list."
    shared formal void add(Element element);

    "Add the given [[elements]] to the end of this list,
     increasing the [[length|List.size]] of the list."
    shared default void addAll({Element*} elements) {
        for (element in elements) {
            add(element);
        }
    }

    "Replace the existing element at the specified [[index]]
     with the given [[element]]."
    throws (`class AssertionError`,
            "if the given index is out of bounds, that
             is, if `index<0` or if `index>lastIndex`")
    shared actual formal void set(Integer index, Element element);

    "Insert the given [[element]] at the specified [[index]],
     incrementing the [[length|List.size]] of the list."
    throws (`class AssertionError`,
            "if the given index is out of bounds, that
             is, if `index<0` or if `index>lastIndex+1`")
    shared formal void insert(Integer index, Element element);
    
    "Insert the given [[elements]] at the specified 
     [[index]], growing the [[length|List.size]] of the 
     list by the number of given elements."
    throws (`class AssertionError`,
        "if the given index is out of bounds, that
         is, if `index<0` or if `index>lastIndex+1`")
    shared default void insertAll(Integer index, 
            {Element*} elements) {
        variable value i = index;
        for (element in elements) {
            insert(i++, element);
        }
    }

    "Remove the element at the specified [[index]],
     returning the removed element, if any, or `null` if
     there was no such element."
    shared formal Anything delete(Integer index);

    "Remove all occurrences of the given [[value|element]]
     from this list, returning the number of elements 
     removed.

     To remove just one occurrence of the given value, use
     [[removeFirst]] or [[removeLast]]."
    shared formal Integer remove(
            "The non-null value to remove"
            Element&Object element);

    "Remove all occurrences of every one of the given
     [[values|elements]] from this list, returning the
     number of elements removed."
    shared default Integer removeAll(
            "The non-null values to remove"
            {Element&Object*} elements) {
        variable value result = 0;
        for (element in elements) {
            result+=remove(element);
        }
        return result;
    }

    "Remove the first occurrence of the given
     [[value|element]] from this list, if any, returning
     `true` if the value occurs in the list, or `false`
     otherwise."
    shared formal Boolean removeFirst(
            "The non-null value to remove"
            Element&Object element);

    "Remove the last occurrence of the given
     [[value|element]] from this list, if any, returning
     `true` if the value occurs in the list, or `false`
     otherwise."
    shared formal Boolean removeLast(
            "The non-null value to remove"
            Element&Object element);
    
    "Remove all null elements from this list, leaving a list
     with no null elements, returning the number of elements
     removed."
    shared formal Integer prune();

    "Replace all occurrences of the given [[value|element]]
     in this list with the given [[replacement
     value|replacement]].

     To replace just one occurrence of the given value, use
     [[replaceFirst]] or [[replaceLast]]."
    shared formal Integer replace(
            "The non-null value to replace"
            Element&Object element,
            "The replacement value"
            Element replacement);

    "Replace the first occurrence of the given
     [[value|element]] in this list, if any, with the given
     [[replacement value|replacement]], returning `true` if
     the value occurs in the list, or `false` otherwise."
    shared formal Boolean replaceFirst(
            "The non-null value to replace"
            Element&Object element,
            "The replacement value"
            Element replacement);

    "Replace the last occurrence of the given
     [[value|element]] in this list, if any, with the given
     [[replacement value|replacement]], returning `true` if
     the value occurs in the list, or `false` otherwise."
    shared formal Boolean replaceLast(
            "The non-null value to replace"
            Element&Object element,
            "The replacement value"
            Element replacement);

    "Replace all null values in this list with the given
     [[replacement value|replacement]]."
    shared formal void infill(
            "The replacement value"
            Element replacement);
    
    "Given two indices within this list, swap the positions 
     of the elements at these indices. If the two given 
     indices are identical, no change is made to the list."
    throws (`class AssertionError`,
        "if either of the given indices is out of bounds") 
    shared formal void swap(
            "The index of the first element."
            Integer i, 
            "The index of the second element."
            Integer j);
    
    "Efficiently move the element of this list at the given 
     [[source index|i]] to the given [[destination index|j]],
     shifting every element falling between the two given 
     indices by one position to accommodate the change of
     position. If the source index is larger than the 
     destination index, elements are shifted toward the end
     of the list. If the source index is smaller than the
     destination index, elements are shifted toward the 
     start of the list. If the given indices are identical,
     no change is made to the list."
    throws (`class AssertionError`,
        "if either of the given indices is out of bounds") 
    shared formal void move(
            "The source index of the element to move."
            Integer i, 
            "The destination index to which the element is
             moved."
            Integer j);
    
    "Remove every element from this list, leaving an empty
     list with no elements."
    shared default void clear() => deleteMeasure(0, size);

    "Remove the element with index `0` from this list,
     returning the removed element, or `null` if there was
     no such element."
    shared default Anything deleteFirst() => delete(0);

    "Remove the element with index `size-1` from this list,
     returning the removed element, or `null` if there was
     no such element."
    shared default Anything deleteLast() => delete(size-1);

    "Remove every element with an index in the spanned range
     `from..to`."
    shared default void deleteSpan(Integer from, Integer to)
        =>  deleteMeasure {
                from = smallest(from, to);
                length = (to - from).magnitude + 1;
            };

    "Remove every element with an index in the measured
     range `from:length`. If `length<=0`, no elements are
     removed."
    shared default void deleteMeasure(
            variable Integer from, variable Integer length) {
        if (from < 0) {
            length += from;
            from = 0;
        }
        length = smallest(length, size - from);
        while (length-- > 0) {
            delete(from);
        }
    }

    "Truncate this list to the given [[size]] by removing
     elements from the end of the list, if necessary, 
     leaving a list with at most the given size."
    throws (`class AssertionError`, "if `size<0`")
    shared default void truncate(Integer size) {
        assert (size >= 0);
        deleteMeasure(size, this.size-size);
    }
    
    shared formal actual ListMutator<Element> clone();
    
}

"Converts the indexes of a measure to those of an equivalent 
 span."
[Integer, Integer] measureToSpan(Integer from, Integer length)
        => length <= 0 then [-1, -1] else [from, from+length-1];

"Converts the indexes of a span to those of an equivalent 
 measure which may be reversed (the span might have 
 `from > to` to express that the elements of the segment 
 should be reversed). The returned tuple is of this form:
 
     [start, length, reversed]"
[Integer, Integer, Boolean] spanToMeasure
        (Integer from, Integer to, Integer size) {
    if (size == 0 || from < 0 && to < 0) {
        return [0, 0, false];
    }
    value reversed = from > to;
    value start = largest(0, reversed then to else from);
    value end = smallest(size-1, reversed then from else to);
    return [start, 1 + end - start, reversed];
}

Integer largest(Integer x, Integer y) => x>y then x else y;
Integer smallest(Integer x, Integer y) => x<y then x else y;
