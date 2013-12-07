
shared class ArrayList<Element>(initialCapacity = 0, elements = {}) 
        satisfies MutableList<Element> {
    Integer initialCapacity;
    {Element*} elements;
    
    "initial capacity cannot be negative"
    assert(initialCapacity>=0);
    
    variable Array<Element?> array = arrayOfSize<Element?>(initialCapacity, null);
    variable Integer length=0;
    
    void grow(Integer increment) {
        if (length+increment>array.size) {
            //TODO: watch out for overflow!!
            value grown = arrayOfSize<Element?>((length+increment)*2, null);
            array.copyTo(grown);
            array=grown;
        }
    }
    
    //grow(elements.size-initialCapacity);
    for (element in elements) {
        grow(1);
        array.set(length++, element);
    }

    shared actual void add(Element val) {
        grow(1);
        array.set(length++, val);
    }
    
    shared actual void addAll({Element*} values) {
        grow(values.size);
        for (val in values) {
            array.set(length++, val);
        }
    }
    
    shared actual void clear() {
        length = 0;
        array = arrayOfSize<Element?>(initialCapacity, null);
    }
    
    shared actual Element? get(Integer index) {
        if (0<=index<length) {
            return array[index];
        }
        else {
            return null;
        }
    }
    
    shared actual void insert(Integer index, Element val) {
        grow(1);
        array.copyTo(array, index, index+1, length-index);
        length++;
        array.set(index, val);
    }
    
    shared actual Element? remove(Integer index) {
        array.copyTo(array, index+1, index, length-index);
        length--;
        Element? result = array[length];
        array.set(length, null);
        return result;
    }
    
    shared actual void removeElement(Element val) {
        variable value i=0;
        variable value j=0;
        while (i<length) {
            value element = array[i++];
            if (!eq(val,element)) {
                array.set(j++,element);
            }
        }
        length=j;
        while (j<i) {
            array.set(j++, null);
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
            => ArrayList(initialCapacity-1, skipping(1));
    
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
            return ArrayList(initialCapacity, iterable);
        }
        else {
            return ArrayList();
        }
    }
    
    shared actual List<Element> segment(Integer from, Integer length) {
        value fst = from<0 then 0 else from;
        value len = from<0 then length+from else length;
        return fst<this.length && len>0
            then ArrayList(len, skipping(fst).taking(len))
            else ArrayList();
    }
    
    shared actual void set(Integer index, Element val) {
        "index may not be negative or greater than length of list"
        assert (0<index<=length);
        if (index==length) {
            add(val);
        }
        else {
            array.set(index,val);
        }
    }
    
    shared actual List<Element> span(Integer from, Integer to) {
        if (from>to) {
            //TODO: would be better to mutate the new array in place
            return this[to..from].reversed;
        }
        else {
            value fst = from<0 then 0 else from;
            value len = (to<0 then 0) else (from<0 then to+1) else to-from+1;
            return fst<this.length && len>=1 
            then ArrayList(len, skipping(fst).taking(len))
            else ArrayList();
        }
    }
    
    spanFrom(Integer from) => from>=length then ArrayList() else span(from,length-1);
    
    spanTo(Integer to) => to<0 then ArrayList() else span(0,to);
    
    lastIndex => length>1 then length-1;
    
    size => length;
    
    equals(Object that) => (super of List<Element>).equals(that);
    
    hash => (super of List<Element>).hash;
    
    clone => ArrayList(size, this);
    
}