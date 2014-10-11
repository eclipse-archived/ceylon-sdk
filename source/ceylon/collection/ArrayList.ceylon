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
    assert (initialCapacity >= 0);

    "initial capacity too large"
    assert (initialCapacity <= runtime.maxArraySize);

    "growth factor must be at least 1.0"
    assert (growthFactor >= 1.0);

    function store(Integer capacity)
            => arrayOfSize<Element|Allocation>(capacity, allocation);

    variable Array<Element|Allocation> array = Array<Element|Allocation>(elements);

    variable Integer length = array.size;

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
                        then maxArraySize 
                        else grownCapacity;
            value grown = store(newCapacity);
            array.copyTo(grown);
            array = grown;
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
        assert (capacity >= size);
        "capacity too large"
        assert (capacity <= runtime.maxArraySize);
        value resized = store(capacity);
        array.copyTo(resized, 0, 0, length);
        array = resized;
    }

    shared actual Element? getFromFirst(Integer index) {
        if (0 <= index < length) {
            assert(!is Allocation elem = array.getFromFirst(index));
            return elem;
        }
        else {
            return null;
        }
    }
    
    shared actual Boolean contains(Object element) {
        for (index in 0:size) {
            if (exists elem = array.getFromFirst(index)) {
                if (elem==element) {
                    return true;
                }
            }
        }
        else {
            return false;
        }
    }
    
    shared actual Iterator<Element> iterator() {
        object iterator satisfies Iterator<Element> {
            variable Integer index = 0;
            value arrayIterator = array.iterator();
            shared actual Finished|Element next() {
                if (index++<length) {
                    assert(!is Allocation next = arrayIterator.next());
                    return next;
                }
                else {
                    return finished;
                }
            }
        }
        return iterator;
    }

    shared actual void insert(Integer index, Element element) {
        "index may not be negative or greater than the
         length of the list"
        assert (0 <= index <= length);
        grow(1);
        if (index < length) {
            array.copyTo(array, index, index+1, length-index);
        }
        length++;
        array.set(index, element);
    }

    shared actual Element? delete(Integer index) {
        if (0 <= index < length) {
            assert(!is Allocation result = array[index]);
            array.copyTo(array, index+1, index, length-index-1);
            length--;
            array.set(length, allocation);
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
                array.set(j++, allocation);
            }
        }
        length=j;
        while (j<i) {
            array.set(j++, allocation);
        }
    }

    shared actual void removeAll({<Element&Object>*} elements) {
        variable value i=0;
        variable value j=0;
        while (i<length) {
            if (exists elem = array[i++]) {
                if (!elem in elements) {
                    array.set(j++,elem);
                }
            }
            else {
                array.set(j++, allocation);
            }
        }
        length=j;
        while (j<i) {
            array.set(j++, allocation);
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
            array.set(j++, allocation);
        }
    }

    shared actual void replace(Element&Object element,
            Element replacement) {
        variable value i=0;
        while (i<length) {
            if (exists elem = array[i], elem==element) {
                array.set(i, replacement);
            }
            i++;
        }
    }

    shared actual Boolean replaceFirst(Element&Object element,
            Element replacement) {
        if (exists index = firstOccurrence(element)) {
            set(index, replacement);
            return true;
        }
        else {
            return false;
        }
    }

    shared actual Boolean replaceLast(Element&Object element,
    Element replacement) {
        if (exists index = lastOccurrence(element)) {
            set(index, replacement);
            return true;
        }
        else {
            return false;
        }
    }

    shared actual void infill(Element replacement) {
        variable value i = 0;
        while (i < length) {
            if (!array[i] exists) {
                array.set(i, replacement);
            }
            i++;
        }
    }

    shared actual Element? first {
        if (length > 0) {
             assert(!is Allocation elem = array[0]);
             return elem;
        }
        else {
            return null;
        }
    }
    
    shared actual void set(Integer index, Element element) {
        "index may not be negative or greater than the
         last index in the list"
        assert (0<=index<length);
        array.set(index,element);
    }

    shared actual List<Element> span(Integer from, Integer to) {
        value measure = spanToMeasure(from, to, length);
        value start = measure[0];
        value len = measure[1];
        value reversed = measure[2];
        value result = ArrayList { 
            initialCapacity = len; 
            growthFactor = growthFactor; 
            elements = skip(start).take(len); 
        };
        return reversed then result.reversed else result;
    }

    shared actual void deleteSpan(Integer from, Integer to) {
        value measure = spanToMeasure(from, to, length);
        value start = measure[0];
        value len = measure[1];
        if (start < length && len > 0) {
            value fstTrailing = start + len;
            array.copyTo(array, fstTrailing, start,
                length - fstTrailing);
            variable value i = length-len;
            while (i < length) {
                array.set(i++, allocation);
            }
            length -= len;
        }
    }

    measure(Integer from, Integer length) 
            => span(*measureToSpan(from, length));
    
    deleteMeasure(Integer from, Integer length) 
            => deleteSpan(*measureToSpan(from, length));
    
    shared actual void truncate(Integer size) {
        assert (size >= 0);
        if (size < length) {
            variable value i = size;
            while (i < length) {
                array.set(i++, allocation);
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

    lastIndex => length >= 1 then length - 1;

    equals(Object that) 
            => (super of List<Element>).equals(that);

    hash => (super of List<Element>).hash;

    clone() => ArrayList(size, growthFactor, this);

    push(Element element) => add(element);

    pop() => deleteLast();

    top => last;

    offer(Element element) => add(element);

    accept() => deleteFirst();

    back => last;

    front => first;
    
    "Sorts the elements in this list according to the 
     order induced by the given 
     [[comparison function|comparing]]. This operation modifies
     the list."
    shared void sortInPlace(
        "A comparison function that compares pairs of
         non-null elements of the array."
        Comparison comparing(Element x, Element y)) {
        array.sortInPlace((Element|Allocation x, Element|Allocation y) {
            if(!is Allocation x, !is Allocation y){
                return comparing(x, y);
            }
            else {
                if (!x is Allocation && y is Allocation) {
                    return smaller;
                }
                else if (!y is Allocation && x is Allocation) {
                    return larger;
                }
                else {
                    return equal;
                }
            }
        });
    }
    
}

"Represents the type of an allocated element"
abstract class Allocation() of allocation {}
"The singleton that represents the `allocation` value."
object allocation extends Allocation() {
    shared actual String string = "allocation";
}
