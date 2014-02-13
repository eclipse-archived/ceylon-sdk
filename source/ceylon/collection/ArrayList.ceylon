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
shared class ArrayList<Element>
        (initialCapacity = 0, growthFactor=1.5, 
                elements = {}) 
        satisfies MutableList<Element> &
                  Stack<Element> & Queue<Element> {
    
    "The initial size of the backing array."
    Integer initialCapacity;
    
    "The factor used to determine the new size of the
     backing array when a new backing array is allocated."
    Float growthFactor;
    
    "The initial elements of the list."
    {Element*} elements;
    
    "initial capacity cannot be negative"
    assert (initialCapacity>=0);
    
    "initial capacity too large"
    assert (initialCapacity<=runtime.maxArraySize);
    
    "growth factor must be at least 1.0"
    assert (growthFactor>=1.0);
    
    function store(Integer capacity)
            => arrayOfSize<Element?>(capacity, null);
    
    variable Array<Element?> array;
    variable Integer length;
    
    if (is List<Element> elements) {
        length = elements.size;
        array = store(length>initialCapacity then length else initialCapacity);
    }
    else {
        length = 0;
        array = store(initialCapacity);
    }
    
    void grow(Integer increment) {
        value neededCapacity = length+increment;
        value maxArraySize = runtime.maxArraySize;
        if (neededCapacity>maxArraySize) {
            throw OverflowException(); //TODO: give it a message!
        }
        if (neededCapacity>array.size) {
            value grownCapacity = (neededCapacity*growthFactor).integer;
            value newCapacity = grownCapacity<neededCapacity||grownCapacity>maxArraySize 
                    then maxArraySize else grownCapacity;
            value grown = store(newCapacity);
            array.copyTo(grown);
            array = grown;
        }
    }
    
    if (is List<Element> elements) {
        if (is ArrayList<Element> elements) {
            elements.array.copyTo(array, 0, 0, length);
        }
        else {
            /*variable value i=0;
             while (i<length) {
             array.set(i, elements[i]);
             i++;
             }*/
            for (element in elements) {
                array.set(length++, element);
            }
        }
    }
    else {
        for (element in elements) {
            grow(1);
            array.set(length++, element);
        }
    }
    
    shared actual void add(Element element) {
        grow(1);
        array.set(length++, element);
    }
    
    shared actual void addAll({Element*} elements) {
        grow(elements.size);
        for (element in elements) {
            array.set(length++, element);
        }
    }
    
    shared actual void clear() {
        length = 0;
        array = store(initialCapacity);
    }
    
    "The size of the backing array, which must be at least 
     as large as the [[size]] of the list."
    shared Integer capacity => array.size;
    assign capacity {
        "capacity must be at least as large as list size"
        assert (capacity>=size);
        "capacity too large"
        assert (capacity<=runtime.maxArraySize);
        value resized = store(capacity);
        array.copyTo(resized, 0, 0, length);
        array = resized;
    }
    
    shared actual Element? get(Integer index) {
        if (0<=index<length) {
            return array[index];
        }
        else {
            return null;
        }
    }
    
    shared actual void insert(Integer index, Element element) {
        "index may not be negative or greater than the
         length of the list"
        assert (0<=index<=length);
        grow(1);
        if (index<length) {
            array.copyTo(array, index, index+1, length-index);
        }
        length++;
        array.set(index, element);
    }
    
    shared actual Element? delete(Integer index) {
        if (0<=index<length) {
            Element? result = array[index];
            array.copyTo(array, index+1, index, length-index-1);
            length--;
            array.set(length, null);
            return result;
        }
        else {
            return null;
        }
    }
    
    shared actual void remove(Element&Object element) {
        variable value i=0;
        variable value j=0;
        while (i<length) {
            if (exists elem = array[i++]) {
                if (elem!=element) {
                    array.set(j++,elem);
                }
            }
            else {
                array.set(j++, null);
            }
        }
        length=j;
        while (j<i) {
            array.set(j++, null);
        }
    }
    
    shared actual void removeAll({<Element&Object>*} elements) {
        variable value i=0;
        variable value j=0;
        while (i<length) {
            if (exists elem = array[i++]) {
                if (elem in elements) {
                    array.set(j++,elem);
                }
            }
            else {
                array.set(j++, null);
            }
        }
        length=j;
        while (j<i) {
            array.set(j++, null);
        }
    }
    
    shared actual Boolean removeFirst(Element&Object element) {
        if (exists index = firstOccurrence(element)) {
            delete(index);
            return true;
        }
        else {
            return false;
        }
    }
    
    shared actual Boolean removeLast(Element&Object element) {
        if (exists index = lastOccurrence(element)) {
            delete(index);
            return true;
        }
        else {
            return false;
        }
    }
    
    shared actual void prune() {
        variable value i=0;
        variable value j=0;
        while (i<length) {
            if (exists element = array[i++]) {
                array.set(j++,element);
            }
        }
        length=j;
        while (j<i) {
            array.set(j++, null);
        }
    }
    
    shared actual void replace(Element&Object element, 
            Element replacement) {
        variable value i=0;
        while (i<length) {
            if (exists elem = array[i], elem==element) {
                array.set(i, replacement);
            }
        }
    }
    
    shared actual Boolean replaceFirst(Element&Object element, 
            Element replacement) {
        if (exists index = firstOccurrence(element)) {
            set(index, element);
            return true;
        }
        else {
            return false;
        }
    }
    
    shared actual Boolean replaceLast(Element&Object element, 
    Element replacement) {
        if (exists index = lastOccurrence(element)) {
            set(index, element);
            return true;
        }
        else {
            return false;
        }
    }
    
    shared actual void infill(Element replacement) {
        variable value i=0;
        while (i<length) {
            if (!array[i] exists) {
                array.set(i, replacement);
            }
        }
    }
    
    shared actual Element? first {
        if (length>0) {
             return array[length];
        }
        else {
            return null;
        }
    }
    
    shared actual List<Element> rest
            => ArrayList(initialCapacity-1, growthFactor, skipping(1));
    
    shared actual Iterator<Element> iterator() {
        if (length>0) {
            //wow, ugly:
            if (is Element null) {
                return { for (i in 0:length) array[i] else null }.iterator();
            }
            else {
                value error {
                    throw AssertionException("underlying array may not contain null");
                }
                return { for (i in 0:length) array[i] else error }.iterator();
            }
        }
        else {
            return emptyIterator;
        }
    }
    
    shared actual List<Element> reversed {
        if (length>0) {
            {Element+} iterable;
            //wow, ugly:
            if (is Element null) {
                iterable = { for (i in length-1..0) array[i] else null };
            }
            else {
                value error {
                    throw AssertionException("underlying array may not contain null");
                }
                iterable = { for (i in length-1..0) array[i] else error };
            }
            return ArrayList(initialCapacity, growthFactor, iterable);
        }
        else {
            return ArrayList();
        }
    }
    
    shared actual void set(Integer index, Element element) {
        "index may not be negative or greater than the
         last index in the list"
        assert (0<=index<length);
        array.set(index,element);
    }
    
    shared actual List<Element> segment(Integer from, Integer length) {
        value fst = from<0 then 0 else from;
        value len = from<0 then length+from else length;
        return fst<this.length && len>0
            then ArrayList(len, growthFactor, skipping(fst).taking(len))
            else ArrayList();
    }
    
    shared actual List<Element> span(Integer from, Integer to) {
        value start = from>to then to else from;
        value end = from>to then from else to;
        value fst = start<0 then 0 else start;
        value len = (end<0 then 0) else (start<0 then end+1) else end-start+1;
        return fst<this.length && len>0 
            then ArrayList(len, growthFactor, skipping(fst).taking(len))
            else ArrayList();
    }
    
    shared actual void deleteSegment(Integer from, Integer length) {
        value fst = from<0 then 0 else from;
        value l = from<0 then length+from else length;
        value len = l+fst>this.length then this.length-fst else l;
        if (fst<this.length && len>0) {
            array.copyTo(array, fst+len, fst, this.length-len-fst);
            variable value i = this.length-len;
            while (i<this.length) {
                array.set(i++, null);
            }
            this.length-=len;
        }
    }
    
    shared actual void deleteSpan(Integer from, Integer to) {
        value start = from>to then to else from;
        value end = from>to then from else to;
        value fst = start<0 then 0 else start;
        value l = (end<0 then 0) else (start<0 then end+1) else end-start+1;
        value len = l+fst>this.length then this.length-fst else l;
        if (fst<this.length && len>0) {
            array.copyTo(array, fst+len, fst, this.length-len-fst);
            variable value i = this.length-len;
            while (i<this.length) {
                array.set(i++, null);
            }
            this.length-=len;
        }
    }
    
    shared actual void truncate(Integer size) {
        assert (size>=0);
        if (size<length) {
            variable value i = size;
            while (i<length) {
                array.set(i++, null);
            }
            length=size;
        }
    }
    
    spanFrom(Integer from) => from>=length 
            then ArrayList() 
            else span(from,length-1);
    
    spanTo(Integer to) => to<0 then ArrayList() else span(0,to);
    
    lastIndex => length>1 then length-1;
    
    size => length;
    
    equals(Object that) => (super of List<Element>).equals(that);
    
    hash => (super of List<Element>).hash;
    
    clone() => ArrayList(size, growthFactor, this);
    
    push(Element element) => add(element);
    
    pop() => deleteLast();
    
    top => last;
    
    offer(Element element) => add(element);
    
    accept() => deleteFirst();
    
    back => last;
    
    front => first;
    
}