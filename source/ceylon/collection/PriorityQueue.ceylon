/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
"A [[Queue]] implemented using a backing [[Array]] where
 the front of the queue is the smallest element according
 to the order relation defined by [[compare]] function.
 Note that this implementation doesn't guarantee the back/last
 element to be the largest element of the queue.
 
 The size of the backing `Array` is called the _capacity_
 of the `PriorityQueue`. The capacity of a new instance is
 specified by the given [[initialCapacity]]. The capacity is
 increased when [[size]] exceeds the capacity. The new
 capacity is the product of the needed capacity and the
 given [[growthFactor]]."
by ("Loic Rouchon")
shared serializable class PriorityQueue<Element>(compare, initialCapacity = 0,
            growthFactor = 1.5, elements = {})
        satisfies Collection<Element> & Queue<Element>
        given Element satisfies Object {
    
    "The initial size of the backing array."
    Integer initialCapacity;
    
    "The factor used to determine the new size of the
     backing array when a new backing array is allocated."
    Float growthFactor;
    
    "A comparator function used to order elements."
    Comparison compare(Element x, Element y);
    
    "The initial elements of the queue."
    {Element*} elements;
    
    function store(Integer capacity) => Array<Element?>.ofSize(capacity, null);
    
    function haveKnownSize({Element*} elements) => elements is Collection<Element>|[Element*];
    
    variable Array<Element?> array;
    variable Integer length;
    
    if (haveKnownSize(elements)) {
        length = elements.size;
        array = store(length > initialCapacity then length else initialCapacity);
    } else {
        length = 0;
        array = store(initialCapacity);
    }
    
    void grow(Integer increment) {
        value neededCapacity = length + increment;
        value maxArraySize = runtime.maxArraySize;
        if (neededCapacity > maxArraySize) {
            throw OverflowException(); //TODO: give it a message!
        }
        if (neededCapacity > array.size) {
            value grownCapacity = (neededCapacity * growthFactor).integer;
            value newCapacity = grownCapacity < neededCapacity || grownCapacity > maxArraySize
                    then maxArraySize else grownCapacity;
            value grown = store(newCapacity);
            array.copyTo(grown);
            array = grown;
        }
    }
    
    void add(Element element) {
        grow(1);
        array[length] = element;
        length++;
    }
    
    "Consider i1 as index in an array whose first element index is 1
     Consider i0 as index in an array whose first element index is 0
     i1 = i0 + 1
     parent index is defined by parent1 = i1 / 2
     parent0 =  (i0 + 1) / 2 - 1"
    Integer parent(Integer index) => (index + 1) / 2 - 1;
    
    "Consider i1 as index in an array whose first element index is 1
     Consider i0 as index in an array whose first element index is 0
     i1 = i0 + 1
     left child index is defined by left1 = i1 * 2
     left0 =  i0 * 2 + 1"
    Integer leftChild(Integer index) => index * 2 + 1;
    
    "Consider i1 as index in an array whose first element index is 1
     Consider i0 as index in an array whose first element index is 0
     i1 = i0 + 1
     right child index is defined by right1 = i1 * 2 + 1
     right0 =  i0 * 2 + 2"
    Integer rightChild(Integer index) => index * 2 + 2;
    
    Element elt(Integer index) {
        assert(exists element = array[index]);
        return element;
    }
    
    Comparison compareIndexes(Integer first, Integer second)
            => compare(elt(first), elt(second));
    
    void swap(Integer first, Integer second) {
        value element = array[first];
        array[first] = array[second];
        array[second] = element;
    }
    
    void bubbleUp(Integer index) {
        if (index == 0) {
            return;
        }
        value parentIndex = parent(index);
        if (compareIndexes(index, parentIndex) == smaller) {
            swap(index, parentIndex);
            bubbleUp(parentIndex);
        }
    }
    
    Integer? minChildrenIndex(Integer index) {
        Integer leftChildIndex = leftChild(index);
        if (leftChildIndex >= length) {
            return null;
        }
        Integer rightChildIndex = rightChild(index);
        if (rightChildIndex >= length) {
            return leftChildIndex;
        }
        Comparison comparison = compareIndexes(leftChildIndex, rightChildIndex);
        if (comparison == smaller) {
            return leftChildIndex;
        }
        return rightChildIndex;
    }
    
    void bubbleDown(Integer index) {
        if (exists childIndex = minChildrenIndex(index),
                compareIndexes(childIndex, index) == smaller) {
            swap(index, childIndex);
            bubbleDown(childIndex);
        }
    }
    
    void addInitialElements() {
        if (haveKnownSize(elements)) {
            variable Integer index = 0;
            for (element in elements) {
                array[index++] = element;
            }
        } else {
            for (element in elements) {
                add(element);
            }
        }
        if (length > 0) {
            for (index in parent(length-1)..0) {
                bubbleDown(index);
            }
        }
    }
    addInitialElements();
    
    size => length;
    
    "The smallest element (regarding the order
     relation defined by [[compare]]) of the
     queue, or `null` if the queue is empty."
    shared actual Element? front => array[0];
    
    "The element currently at the end of the
     queue, or `null` if the queue is empty.
     This is not necessarily the largest element
     (regarding the order relation defined by
     [[compare]]) of the queue."
    shared actual Element? last => array[length - 1];
    
    "The element currently at the end of the
     queue, or `null` if the queue is empty.
     This is not necessarily the largest element
     (regarding the order relation defined by
     [[compare]]) of the queue."
    shared actual Element? back => last;
    
    "Add a new element to the queue."
    shared actual void offer(Element element) {
        add(element);
        bubbleUp(length - 1);
    }
    
    "Remove and return the smallest element
     ([[front]] element) from this queue"
    shared actual Element? accept() {
        value element = front;
        if (length > 0) {
            array[0] = last;
            array[--length] = null;
            bubbleDown(0);
        }
        return element;
    }
    
    "An iterator for the elements belonging to this queue.
     Elements returned by this iterator are not ordered"
    shared actual Iterator<Element> iterator() {
        if (length > 0) {
            object it satisfies Iterator<Element> {
                variable Integer index = 0;
                shared actual Element|Finished next() {
                    value element = array[index];
                    if (exists element) {
                        index++;
                        return element;
                    }
                    assert(index == length);
                    return finished;
                }
                
            }
            return it;
        }
        else {
            return emptyIterator;
        }
    }
    
    shared actual PriorityQueue<Element> clone() {
        value clone = PriorityQueue {
            compare = compare;
            initialCapacity = length;
            growthFactor = growthFactor;
        };
        clone.length = length;
        clone.array = array.clone();
        return clone;
    }
}
