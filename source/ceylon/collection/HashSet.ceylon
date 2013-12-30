import ceylon.collection {
    Cell,
    MutableSet,
    makeCellElementArray
}

"A [[MutableSet]] implemented as a hash set stored in an 
 [[Array]] of singly linked lists. Each element is assigned 
 an index of the array according to its hash code. The hash 
 code of an element is defined by [[Object.hash]].
 
 The size of the backing `Array` is called the _capacity_
 of the `HashSet`. The capacity of a new instance is 
 specified by the given [[initialCapacity]]. The capacity is 
 increased, and the elements _rehashed_, when the ratio of 
 [[size]] to capacity exceeds the given [[loadFactor]]. The 
 new capacity is the product of the current capacity and the 
 given [[growthFactor]]."
by("Stéphane Épardaud")
shared class HashSet<Element>
        (initialCapacity=16, loadFactor=0.75, growthFactor=2.0, 
                elements = {})
        satisfies MutableSet<Element>
        given Element satisfies Object {
    
    "The initial elements of the set."
    {Element*} elements;
    
    "The initial capacity of the backing array."
    Integer initialCapacity;
    
    "The ratio between the number of elements and the 
     capacity which triggers a rebuild of the hash set."
    Float loadFactor;
    
    "The factor used to determine the new size of the
     backing array when a new backing array is allocated."
    Float growthFactor;
    
    "initial capacity cannot be negative"
    assert (initialCapacity>=0);
    
    "load factor must be positive"
    assert (loadFactor>0.0);
    
    "growth factor must be at least 1.0"
    assert (growthFactor>=1.0);
    
    variable Array<Cell<Element>?> store = makeCellElementArray<Element>(initialCapacity);
    variable Integer _size = 0;
    
    // Write
    
    Integer storeIndex(Object elem, Array<Cell<Element>?> store){
        Integer i = elem.hash % store.size;
        return i.negative then i.negativeValue else i;
    }
    
    Boolean addToStore(Array<Cell<Element>?> store, Element element){
        Integer index = storeIndex(element, store);
        variable Cell<Element>? bucket = store[index];
        while(exists Cell<Element> cell = bucket){
            if(cell.car == element){
                // modify an existing entry
                cell.car = element;
                return false;
            }
            bucket = cell.cdr;
        }
        // add a new entry
        store.set(index, Cell<Element>(element, store[index]));
        return true;
    }
    
    void checkRehash(){
        if(_size > (store.size.float * loadFactor).integer){
            // must rehash
            Array<Cell<Element>?> newStore = makeCellElementArray<Element>((_size * growthFactor).integer);
            variable Integer index = 0;
            // walk every bucket
            while(index < store.size){
                variable Cell<Element>? bucket = store[index];
                while(exists Cell<Element> cell = bucket){
                    addToStore(newStore, cell.car);
                    bucket = cell.cdr;
                }
                index++;
            }
            store = newStore;
        }
    }
    
    // Add initial values
    for(val in elements){
        if(addToStore(store, val)){
            _size++;
        }        
    }
    checkRehash();
    
    // End of initialiser section
    
    shared actual Boolean add(Element element){
        if(addToStore(store, element)){
            _size++;
            checkRehash();
            return true;
        }
        return false;
    }
    
    shared actual Boolean addAll({Element*} elements){
        variable Boolean ret = false;
        for(Element elem in elements){
            ret ||= add(elem);
        }
        checkRehash();
        return ret;
    }
    
    shared actual Boolean remove(Element element){
        Integer index = storeIndex(element, store);
        variable Cell<Element>? bucket = store[index];
        variable Cell<Element>? prev = null;
        while(exists Cell<Element> cell = bucket){
            if(cell.car == element){
                // found it
                if(exists Cell<Element> last = prev){
                    last.cdr = cell.cdr;
                }else{
                    store.set(index, cell.cdr);
                }
                _size--;
                return true;
            }
            prev = cell;
            bucket = cell.cdr;
        }
        return false;
    }
    
    "Removes every element"
    shared actual void clear(){
        variable Integer index = 0;
        // walk every bucket
        while(index < store.size){
            store.set(index++, null);
        }
        _size = 0;
    }
    
    // Read
    
    size => _size;
    
    shared actual Iterator<Element> iterator() {
        // FIXME: make this faster with a size check
        object iter satisfies Iterator<Element> {
            variable Integer index = 0;
            variable Cell<Element>? bucket = store[index];
            
            shared actual Element|Finished next() {
                // do we need a new bucket?
                if(!bucket exists){
                    // find the next non-empty bucket
                    while(++index < store.size){
                        bucket = store[index];
                        if(bucket exists){
                            break;
                        }
                    }
                }
                // do we have a bucket?
                if(exists Cell<Element> bucket = bucket){
                    value car = bucket.car;
                    // advance to the next cell
                    this.bucket = bucket.cdr;
                    return car;
                }
                return finished;
            }
        }
        return iter;
    }
    
    shared actual Integer count(Boolean selecting(Element element)) {
        variable Integer c = 0;
        variable Integer index = 0;
        // walk every bucket
        while(index < store.size){
            variable Cell<Element>? bucket = store[index];
            while(exists Cell<Element> cell = bucket){
                if(selecting(cell.car)){
                    c++;
                }
                bucket = cell.cdr;
            }
            index++;
        }
        return c;
    }
    
    shared actual String string {
        variable Integer index = 0;
        StringBuilder ret = StringBuilder();
        ret.append("(");
        variable Boolean first = true;
        // walk every bucket
        while(index < store.size){
            variable Cell<Element>? bucket = store[index];
            while(exists Cell<Element> cell = bucket){
                if(!first){
                    ret.append(", ");
                }else{
                    first = false;
                }
                ret.append(cell.car.string);
                bucket = cell.cdr;
            }
            index++;
        }
        ret.append(")");
        return ret.string;
    }
    
    shared actual Integer hash {
        variable Integer index = 0;
        variable Integer hash = 17;
        // walk every bucket
        while(index < store.size){
            variable Cell<Element>? bucket = store[index];
            while(exists Cell<Element> cell = bucket){
                hash = hash * 31 + cell.car.hash;
                bucket = cell.cdr;
            }
            index++;
        }
        return hash;
    }
    
    shared actual Boolean equals(Object that) {
        if(is Set<Object> that,
            size == that.size){
            variable Integer index = 0;
            // walk every bucket
            while(index < store.size){
                variable Cell<Element>? bucket = store[index];
                while(exists Cell<Element> cell = bucket){
                    if(!that.contains(cell.car)){
                        return false;
                    }
                    bucket = cell.cdr;
                }
                index++;
            }
            return true;
        }
        return false;
    }
    
    shared actual HashSet<Element> clone {
        HashSet<Element> clone = HashSet<Element>();
        clone._size = _size;
        clone.store = makeCellElementArray<Element>(store.size);
        variable Integer index = 0;
        // walk every bucket
        while(index < store.size){
            if(exists Cell<Element> bucket = store[index]){
                clone.store.set(index, bucket.clone); 
            }
            index++;
        }
        return clone;
    }
    
    shared actual Boolean contains(Object element) {
        variable Integer index = 0;
        // walk every bucket
        while(index < store.size){
            variable Cell<Element>? bucket = store[index];
            while(exists Cell<Element> cell = bucket){
                if(cell.car == element){
                    return true;
                }
                bucket = cell.cdr;
            }
            index++;
        }
        return false;
    }
    
    shared actual HashSet<Element> complement<Other>(Set<Other> set) 
    given Other satisfies Object {
        HashSet<Element> ret = HashSet<Element>();
        for(Element elem in this){
            if(!set.contains(elem)){
                ret.add(elem);
            }
        }
        return ret;
    }
    
    shared actual HashSet<Element|Other> exclusiveUnion<Other>(Set<Other> set) 
    given Other satisfies Object {
        HashSet<Element|Other> ret = HashSet<Element|Other>();
        for(Element elem in this){
            if(!set.contains(elem)){
                ret.add(elem);
            }
        }
        for(Other elem in set){
            if(!contains(elem)){
                ret.add(elem);
            }
        }
        return ret;
    }
    
    shared actual HashSet<Element&Other> intersection<Other>(Set<Other> set) 
    given Other satisfies Object {
        HashSet<Element&Other> ret = HashSet<Element&Other>();
        for(Element elem in this){
            if(set.contains(elem), is Other elem){
                ret.add(elem);
            }
        }
        return ret;
    }
    
    shared actual HashSet<Element|Other> union<Other>(Set<Other> set) 
    given Other satisfies Object {
        HashSet<Element|Other> ret = HashSet<Element|Other>();
        ret.addAll(this);
        ret.addAll(set);
        return ret;
    }
    
}
