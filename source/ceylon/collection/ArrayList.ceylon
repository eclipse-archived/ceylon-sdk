/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
"A [[MutableList]] implemented using a backing [[Array]].
 Also:

 - a [[Stack]], where the top of the stack is the _last_
   element of the list, and
 - a [[Queue]], where the front of the queue is the first
   element of the list and the back of the queue is the
   last element of the list.

 The size of the backing `Array` is called the _capacity_
 of the `ArrayList`. The capacity of a new instance is
 specified by the given [[initialCapacity]]. The capacity is
 increased when [[size]] exceeds the capacity. The new
 capacity is the product of the current capacity and the
 given [[growthFactor]]."
by ("Gavin King")
shared serializable class ArrayList<Element>
        satisfies MutableList<Element> &
                  SearchableList<Element> &
                  Stack<Element> & Queue<Element> {

    "The initial size of the backing array."
    Integer initialCapacity;

    "The factor used to determine the new size of the
     backing array when a new backing array is allocated."
    Float growthFactor;

    "The underlying array."
    variable Array<Element?> array;

    "The number of slots of the backing array that actually
     hold elements of this list."
    variable Integer length;

    "Create a new `ArrayList` with the given initial
     [[elements]]."
    shared new (
        "The initial size of the backing array."
        Integer initialCapacity = 0, 
        "The factor used to determine the new size of the
         backing array when a new backing array is allocated."
        Float growthFactor = 1.5, 
        "The initial elements of the list."
        {Element*} elements = {}) {
        this.initialCapacity = initialCapacity;
        this.growthFactor = growthFactor;
        array = Array<Element?>(elements);
        length = array.size;
    }
    
    "Create a new `ArrayList` with the same initial elements 
     as the given [[arrayList]]."
    shared new copy(
        "The `ArrayList` to copy."
        ArrayList<Element> arrayList,
        "The factor used to determine the new size of the
         backing array when a new backing array is allocated."
        Float growthFactor = 1.5) {
        this.initialCapacity = arrayList.size;
        this.growthFactor = growthFactor;
        array = arrayList.array.clone();
        length = arrayList.size;
    }
    
    "Create a new `ArrayList` of the given [[size]], 
     populating every index with the given [[element]]. If 
     `size<=0`, the new list will have no elements."
    shared new ofSize(
        "The size of the resulting list. If the size is 
         non-positive, an empty list will be created."
        Integer size,
        "The element value with which to populate the list. 
         All elements of the resulting list will have the 
         same value."
        Element element,
        "The factor used to determine the new size of the
         backing array when a new backing array is allocated."
        Float growthFactor = 1.5) {
        this.initialCapacity = size<0 then 0 else size;
        this.growthFactor = growthFactor;
        array = Array<Element?>.ofSize(size, element);
        length = size;
    }
    
    "initial capacity cannot be negative"
    assert (initialCapacity >= 0);

    "initial capacity too large"
    assert (initialCapacity <= runtime.maxArraySize);

    "growth factor must be at least 1.0"
    assert (growthFactor >= 1.0);

    function store(Integer capacity)
            => Array<Element?>.ofSize(capacity, null);

    size => length;

    if (length < initialCapacity) {
        value newArray = store(initialCapacity);
        array.copyTo(newArray, 0, 0, length);
        array = newArray;
    }

    void grow(Integer increment) {
        value neededCapacity = length + increment;
        value maxArraySize = runtime.maxArraySize;
        if (neededCapacity > maxArraySize) {
            throw OverflowException(); //TODO: give it a message!
        }
        if (neededCapacity > array.size) {
            value grownCapacity 
                    = (neededCapacity * growthFactor).integer;
            value newCapacity 
                    = grownCapacity < neededCapacity || 
                      grownCapacity > maxArraySize
                        then neededCapacity 
                        else grownCapacity;
            value grown = store(newCapacity);
            array.copyTo(grown);
            array = grown;
        }
    }

    shared actual 
    void add(Element element) {
        grow(1);
        array[length++] = element;
    }

    shared actual 
    void addAll({Element*} elements) {
        value sequence = elements.sequence();
        grow(sequence.size);
        for (element in sequence) {
            array[length++] = element;
        }
    }
    
    shared actual default 
    void swap(Integer i, Integer j) {
        "index may not be negative or greater than the
         last index in the list"
        assert (0<=i<length, 0<=j<length);
        array.swap(i, j);
    }
    
    shared actual default 
    void move(Integer i, Integer j) {
        "index may not be negative or greater than the
         last index in the list"
        assert (0<=i<length, 0<=j<length);
        array.move(i, j);
    }

    shared actual
    void clear() {
        length = 0;
        array = store(initialCapacity);
    }

    "The size of the backing array, which must be at least
     as large as the [[size]] of the list."
    shared Integer capacity => array.size;
    assign capacity {
        "capacity must be at least as large as list size"
        assert (capacity >= size);
        "capacity too large"
        assert (capacity <= runtime.maxArraySize);
        value resized = store(capacity);
        array.copyTo(resized, 0, 0, length);
        array = resized;
    }

    getFromFirst(Integer index) 
            => if (0 <= index < length)
            then array[index]
            else null;
    
    shared actual 
    Boolean contains(Object element) {
        for (index in 0:size) {
            if (exists elem = array[index]) {
                if (elem==element) {
                    return true;
                }
            }
        }
        else {
            return false;
        }
    }
    
    iterator() => object satisfies Iterator<Element> {
        variable value index = 0;
        shared actual Finished|Element next() {
            if (index<length) {
                if (exists next = array[index++]) {
                    return next;
                }
                else {
                    assert (is Element null);
                    return null;
                }
            }
            else {
                return finished;
            }
        }
    };
    
    shared actual 
    void insert(Integer index, Element element) {
        "index may not be negative or greater than the
         length of the list"
        assert (0 <= index <= length);
        grow(1);
        if (index < length) {
            array.copyTo(array, 
                index, index+1, length-index);
        }
        length++;
        array[index] = element;
    }
    
    shared actual 
    void insertAll(Integer index, {Element*} elements) {
        "index may not be negative or greater than the
         length of the list"
        assert (0 <= index <= length);
        value sequence = elements.sequence();
        value size = sequence.size;
        if (size>0) {
            grow(size);
            if (index < length) {
                array.copyTo(array, 
                    index, index+size, length-index);
            }
            variable value i = index;
            for (element in sequence) {
                array[i++] = element;
            }
            length+=size;
        }
    }

    shared actual 
    Element? delete(Integer index) {
        if (0 <= index < length) {
            value result = array[index];
            array.copyTo(array,
                index+1, index, length-index-1);
            length--;
            array[length] = null;
            return result;
        }
        else {
            return null;
        }
    }

    shared actual 
    Integer remove(Element&Object element) {
        variable value i=0;
        variable value j=0;
        while (i<length) {
            if (exists elem = array[i++]) {
                if (elem!=element) {
                    array[j++] = elem;
                }
            }
            else {
                array[j++] = null;
            }
        }
        length=j;
        while (j<i) {
            array[j++] = null;
        }
        return i-length;
    }

    shared actual 
    Integer removeAll({<Element&Object>*} elements) {
        Category<> set = HashSet { *elements };
        variable value i=0;
        variable value j=0;
        while (i<length) {
            if (exists elem = array[i++]) {
                if (!elem in set) {
                    array[j++] = elem;
                }
            }
            else {
                array[j++] = null;
            }
        }
        length=j;
        while (j<i) {
            array[j++] = null;
        }
        return i-length;
    }

    shared actual 
    Boolean removeFirst(Element&Object element) {
        if (exists index 
                = firstOccurrence(element)) {
            delete(index);
            return true;
        }
        else {
            return false;
        }
    }

    shared actual 
    Boolean removeLast(Element&Object element) {
        if (exists index 
                = lastOccurrence(element)) {
            delete(index);
            return true;
        }
        else {
            return false;
        }
    }
    
    
    shared actual Element? findAndRemoveFirst(
        Boolean selecting(Element&Object element)) {
        if (exists index 
                = firstIndexWhere(selecting)) {
            return delete(index);
        }
        else {
            return null;
        }
    }
    
    shared actual Element? findAndRemoveLast(
        Boolean selecting(Element&Object element)) {
        if (exists index 
                = lastIndexWhere(selecting)) {
            return delete(index);
        }
        else {
            return null;
        }
    }
    
    shared actual Integer removeWhere(
        Boolean selecting(Element&Object element)) {
        variable value i=0;
        variable value j=length;
        while (i<length) {
            if (exists elem = array[i++]) {
                if (selecting(elem)) {
                    j=i-1;
                    break;
                }
            }
        }
        while (i<length) {
            if (exists elem = array[i++]) {
                if (!selecting(elem)) {
                    array[j++] = elem;
                }
            }
            else {
                array[j++] = null;
            }
        }
        length=j;
        while (j<i) {
            array[j++] = null;
        }
        return i-length;
    }
    
    
    shared actual 
    Integer prune() {
        variable value i=0;
        variable value j=0;
        while (i<length) {
            if (exists element = array[i++]) {
                array[j++] = element;
            }
        }
        value removed = i - j;
        length=j;
        while (j<i) {
            array[j++] = null;
        }
        return removed;
    }

    shared actual 
    Integer replace(Element&Object element, 
        Element replacement) {
        variable value count = 0;
        variable value i = 0;
        while (i<length) {
            if (exists elem = array[i],
                elem==element) {
                array[i] = replacement;
                count++;
            }
            i++;
        }
        return count;
    }

    shared actual 
    Boolean replaceFirst(Element&Object element, 
        Element replacement) {
        if (exists index 
                = firstOccurrence(element)) {
            array[index] = replacement;
            return true;
        }
        else {
            return false;
        }
    }

    shared actual 
    Boolean replaceLast(Element&Object element, 
        Element replacement) {
        if (exists index 
                = lastOccurrence(element)) {
            array[index] = replacement;
            return true;
        }
        else {
            return false;
        }
    }

    shared actual Element? findAndReplaceFirst(
        Boolean selecting(Element&Object element), 
        Element replacement) {
        if (exists index 
            = firstIndexWhere(selecting)) {
            value old = getFromFirst(index);
            array[index] = replacement;
            return old;
        }
        else {
            return null;
        }
    }
    
    shared actual Element? findAndReplaceLast(
        Boolean selecting(Element&Object element), 
        Element replacement) {
        if (exists index 
            = lastIndexWhere(selecting)) {
            value old = getFromFirst(index);
            array[index] = replacement;
            return old;
        }
        else {
            return null;
        }
    }
    
    shared actual Integer replaceWhere(
        Boolean selecting(Element&Object element), 
        Element replacement) {
        variable value count = 0;
        variable value i = 0;
        while (i<length) {
            if (exists elem = array[i],
                selecting(elem)) {
                array[i] = replacement;
                count++;
            }
            i++;
        }
        return count;
    }
    
    
    shared actual 
    void infill(Element replacement) {
        variable value i = 0;
        while (i < length) {
            if (!array[i] exists) {
                array[i] = replacement;
            }
            i++;
        }
    }

    shared actual 
    void set(Integer index, Element element) {
        "index may not be negative or greater than the
         last index in the list"
        assert (0<=index<length);
        array[index] = element;
    }

    shared actual 
    List<Element> span(Integer from, Integer to) {
        let ([start, len, reversed]
                = spanToMeasure(from, to, length));
        value result = ArrayList {
            initialCapacity = len; 
            growthFactor = growthFactor; 
            elements = skip(start).take(len); 
        };
        return reversed then result.reversed else result;
    }

    shared actual 
    void deleteSpan(Integer from, Integer to) {
        let ([start, len, _]
                = spanToMeasure(from, to, length));
        if (start < length && len > 0) {
            value fstTrailing = start + len;
            array.copyTo(array, 
                fstTrailing, start, length - fstTrailing);
            variable value i = length-len;
            while (i < length) {
                array[i++] = null;
            }
            length -= len;
        }
    }

    measure(Integer from, Integer length) 
            => span(*measureToSpan(from, length));
    
    deleteMeasure(Integer from, Integer length) 
            => deleteSpan(*measureToSpan(from, length));
    
    shared actual 
    void truncate(Integer size) {
        assert (size >= 0);
        if (size < length) {
            variable value i = size;
            while (i < length) {
                array[i++] = null;
            }
            length = size;
        }
    }

    spanFrom(Integer from) 
            => from >= length
                then ArrayList()
                else span(from, length-1);

    spanTo(Integer to) 
            => to < 0 then ArrayList() else span(0, to);

    first => if (length > 0) then array[0] else null;
    
    lastIndex => length >= 1 then length - 1;

    shared actual
    Boolean equals(Object that) {
        if (is ArrayList<Anything> that) {
            if (this===that) {
                return true;
            }
            if (this.length!=that.length) {
                return false;
            }
            for (index in 0:length) {
                value thisElement
                        = this.array.getFromFirst(index);
                value thatElement
                        = that.array.getFromFirst(index);
                if (exists thisElement) {
                    if (!exists thatElement) {
                        return false;
                    }
                    else if (thisElement!=thatElement) {
                        return false;
                    }
                }
                else if (thatElement exists) {
                    return false;
                }
            }
            else {
                return true;
            }
        }
        else {
            return (super of List<>).equals(that);
        }
    }

    shared actual
    Integer hash {
        variable value hash = 1;
        for (index in 0:length) {
            hash *= 31;
            if (exists elem = array.getFromFirst(index)) {
                hash += elem.hash;
            }
        }
        return hash;
    }

    push(Element element) => add(element);

    pop() => deleteLast();

    top => last;

    offer(Element element) => add(element);

    accept() => deleteFirst();

    back => last;

    front => first;

    shared actual
    ArrayList<Element> clone() => ArrayList.copy(this);

    find(Boolean selecting(Element&Object element))
            => array.find(selecting);

    findLast(Boolean selecting(Element&Object element))
            => array.findLast(selecting);

    "Sorts the elements in this list according to the
     order induced by the given 
     [[comparison function|comparing]]. Null elements are 
     sorted to the end of the list. This operation modifies 
     the list."
    shared void sortInPlace(
        "A comparison function that compares pairs of
         non-null elements of the array."
        Comparison comparing(Element&Object x, Element&Object y))
            => array.sortInPlace((x, y)
                =>   if (exists x, exists y)
                        then comparing(x, y)
                else if (x exists, !y exists)
                        then smaller
                else if (y exists, !x exists)
                        then larger
                else equal);
    
    shared actual
    void each(void step(Element element)) {
        if (is Element null) {
            array.take(length)
                 .each((e) { 
                step(e else null); 
            });
        }
        else {
            array.take(length)
                 .each((e) { 
                assert (exists e);
                step(e);
            });
        }
    }
    
    shared actual
    Integer count(Boolean selecting(Element element)) {
        if (is Element null) {
            return array.take(length)
                    .count((e) => selecting(e else null));
        }
        else {
            return array.take(length)
                    .count((e) { 
                assert (exists e);
                return selecting(e);
            });
        }
    }
    
    shared actual
    Boolean every(Boolean selecting(Element element)) {
        if (is Element null) {
            return array.take(length)
                    .every((e) => selecting(e else null));
        }
        else {
            return array.take(length)
                    .every((e) { 
                assert (exists e);
                return selecting(e);
            });
        }
    }
    
    shared actual
    Boolean any(Boolean selecting(Element element)) {
        if (is Element null) {
            return array.take(length)
                    .any((e) => selecting(e else null));
        }
        else {
            return array.take(length)
                    .any((e) { 
                assert (exists e);
                return selecting(e);
            });
        }
    }

    shared actual
    Result|Element|Null reduce<Result>(
        Result accumulating(Result|Element partial, 
                            Element element)) {
        if (is Element null) {
            return array.take(length)
                    .reduce<Result>((partial, element)
                    => accumulating(partial else null,
                                    element else null));
        }
        else {
            return array.take(length)
                    .reduce<Result>((partial, element) {
                assert (exists partial, exists element);
                return accumulating(partial, element);
            });
        }
    }
    
    //TODO: are the following really beneficial?
    
    occursAt(Integer index, Element element)
            => if (index<length) 
            then array.occursAt(index, element) 
            else false;
    
    firstOccurrence(Element element, Integer from, Integer length) 
            => if (exists result 
                    = array.firstOccurrence {
                        element = element;
                        from = from;
                        length = smallest(from+length, size) - from;
                    })
            then result 
            else null;
    
    lastOccurrence(Element element, Integer from, Integer length) 
            => if (exists result 
                    = array.lastOccurrence {
                        element = element;
                        from = largest(from, array.size-size);
                        length = length;
                    })
            then result 
            else null;
    
    occurs(Element element, Integer from, Integer length) 
            => array.occurs {
                element = element;
                from = from;
                length = smallest(from+length, size) - from;
            };
    
    occurrences(Element element, Integer from, Integer length) 
            => array.occurrences {
                element = element;
                from = from;
                length = smallest(from+length, size) - from;
            };
    
    "Efficiently copy the elements in the measure
     `sourcePosition:length` of this list to the measure 
     `destinationPosition:length` of the given 
     [[destination]] `ArrayList` or `Array`.
     
     The given [[sourcePosition]] and [[destinationPosition]] 
     must be non-negative and, together with the given 
     [[length]], must identify meaningful ranges within the 
     two lists, satisfying:
     
     - `size >= sourcePosition+length`, and 
     - `destination.size >= destinationPosition+length`.
     
     If the given `length` is not strictly positive, no
     elements are copied."
    throws (`class AssertionError`, 
        "if the arguments do not identify meaningful ranges 
         within the two lists:
         
         - if the given [[sourcePosition]] or 
           [[destinationPosition]] is negative, 
         - if `size < sourcePosition+length`, or 
         - if `destination.size < destinationPosition+length`.")
    shared void copyTo(
        "The list into which to copy the elements."
        ArrayList<Element>|Array<Element?> destination,
        "The index of the first element in this array to 
         copy."
        Integer sourcePosition = 0,
        "The index in the given array into which to copy the 
         first element."
        Integer destinationPosition = 0,
        "The number of elements to copy."
        Integer length 
                = smallest(size - sourcePosition,
                    destination.size - destinationPosition)) {
        
        "illegal starting position in source list"
        assert (0<=sourcePosition<=size-length);
        "illegal starting position in destination list"
        assert (0<=destinationPosition<=destination.size-length);
        
        array.copyTo { 
            length = length; 
            sourcePosition = sourcePosition; 
            destinationPosition = destinationPosition; 
            destination = 
                    switch (destination)
                    case (Array<Element?>)
                        destination
                    case (ArrayList<Element>)
                        destination.array;
        }; 
    }
    
    "Reduce the capacity of the list to its current [[size]],
     by allocating a new backing array."
    shared void shrink() {
        if (array.size>length) {
            value newArray = store(length);
            array.copyTo(newArray, 0, 0, length);
            array = newArray;
        }
    }
    
}
