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
            => arrayOfSize<Element?>(capacity, null);

    variable Integer length = elements.size;
    variable Array<Element?> array = store(length > initialCapacity then length else initialCapacity);

    if (is ArrayList<Element> elements) {
       elements.array.copyTo(this.array, 0, 0, length);
    } else {
        for (i -> element in entries(elements)) {
            array.set(i, element);
        }
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

    shared actual Element? get(Integer index) {
        if (0 <= index < length) {
            return array[index];
        }
        else {
            return null;
        }
    }

    shared actual void insert(Integer index, Element element) {
        "index may not be negative or greater than the
         length of the list"
        assert (0 <= index <= length);
        grow(1);
        if (index < length) {
            array.copyTo(array, index, index + 1, length - index);
        }
        length++;
        array.set(index, element);
    }

    shared actual Element? delete(Integer index) {
        if (0 <= index < length) {
            Element? result = array[index];
            array.copyTo(array, index + 1, index, length - index - 1);
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
                if (!elem in elements) {
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
             return array[0];
        }
        else {
            return null;
        }
    }

    rest => ArrayList(length - 1, growthFactor, skip(1));

    shared actual Iterator<Element> iterator() {
        if (length > 0) {
            return { for (i in 0..(length - 1)) if (is Element elem = array[i]) elem }.iterator();
        } else {
            return emptyIterator;
        }
    }

    shared actual List<Element> reversed {
        if (length > 0) {
            value iterable = [ for (i in (length - 1)..0) if (is Element elem = array[i]) elem ];
            return ArrayList(initialCapacity, growthFactor, iterable);
        } else {
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
        if (length <= 0) {
            return ArrayList();
        }
        value first = max { 0, from };
        value len = max { 0, from < 0 then length + from else length };
        return first < this.length && len > 0
            then ArrayList(len, growthFactor, skip(first).take(len))
            else ArrayList();
    }

    span(Integer from, Integer to) => segment(*spanToSegment(from, to));

    shared actual void deleteSegment(Integer from, Integer length) {
        internalDelSegment(from, length);
    }

    void internalDelSegment(Integer from, Integer len) {
        value wantedLast = from + len - 1;
        if (len <= 0 || wantedLast < 0) {
            return;
        }
        value fst = max { 0, from };
        value lst = min { wantedLast, length - 1 };
        if (lst < fst) {
            return;
        }
        value removedCount = 1 + lst - fst;
        value fstTrailing = fst + removedCount;
        value originalLength = length;
        array.copyTo(array, fstTrailing, fst, length - fstTrailing);
        for (i in (length - removedCount)..(originalLength - 1)) {
            array.set(i, null);
        }
        length -= removedCount;
    }

    deleteSpan(Integer from, Integer to) => internalDelSegment(*spanToSegment(from, to));

    shared actual void truncate(Integer size) {
        assert (size >= 0);
        if (size < length) {
            variable value i = size;
            while (i < length) {
                array.set(i++, null);
            }
            length = size;
        }
    }

    spanFrom(Integer from) => from >= length
            then ArrayList()
            else span(from, length-1);

    spanTo(Integer to) => to < 0 then ArrayList() else span(0, to);

    lastIndex => length >= 1 then length - 1;

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
