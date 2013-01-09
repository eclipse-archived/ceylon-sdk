doc "Set that uses a Hashing implementation."
by "Stéphane Épardaud"
shared class HashSet<Element>()
    satisfies MutableSet<Element>
        given Element satisfies Object {
    
    variable Array<Cell<Element>?> store = makeCellElementArray<Element>(16);
    variable Integer _size = 0;
    Float loadFactor = 0.75;

    // Write

    void checkRehash(){
        if(_size > (store.size.float * loadFactor).integer){
            // must rehash
            Array<Cell<Element>?> newStore = makeCellElementArray<Element>(_size * 2);
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
        store.setItem(index, Cell<Element>(element, store[index]));
        return true;
    }
            
    doc "Adds an element to this set, if not already present"
    shared actual void add(Element element){
        if(addToStore(store, element)){
            _size++;
            checkRehash();
        }
    }
    
    doc "Adds every element from the given collection to this set, unless already present"
    shared actual void addAll(Element... elements){
        for(Element elem in elements){
            add(elem);
        }
        checkRehash();
    }

    doc "Removes an element from this set, if present"
    shared actual void remove(Element element){
        Integer index = storeIndex(element, store);
        variable Cell<Element>? bucket = store[index];
        variable Cell<Element>? prev = null;
        while(exists Cell<Element> cell = bucket){
            if(cell.car == element){
                // found it
                if(exists Cell<Element> last = prev){
                    last.cdr = cell.cdr;
                }else{
                    store.setItem(index, cell.cdr);
                }
                _size--;
                return;
            }
            prev = cell;
            bucket = cell.cdr;
        }
    }
    
    doc "Removes every element"
    shared actual void clear(){
        variable Integer index = 0;
        // walk every bucket
        while(index < store.size){
            store.setItem(index++, null);
        }
        _size = 0;
    }

    Integer storeIndex(Object elem, Array<Cell<Element>?> store){
        Integer i = elem.hash % store.size;
        return i.negative then i.negativeValue else i;
    }

    // Read
    
    shared actual Integer size {
        return _size;
    }
    shared actual Boolean empty {
        return _size == 0;
    }
    
    shared actual Iterator<Element> iterator {
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
    
    doc "Not implemented yet"
    see (equalsTemp)
    shared actual Boolean equals(Object that) {
        // FIXME: can't implement this :(
        return nothing;
    }
    
    shared Boolean equalsTemp(Set<Element> that){
        if(size != that.size){
            return false;
        }
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
    
    shared actual HashSet<Element> clone {
        HashSet<Element> clone = HashSet<Element>();
        clone._size = _size;
        clone.store = makeCellElementArray<Element>(store.size);
        variable Integer index = 0;
        // walk every bucket
        while(index < store.size){
            if(exists Cell<Element> bucket = store[index]){
                clone.store.setItem(index, bucket.clone); 
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
    shared actual Boolean containsEvery(Object... elements) {
        for(Object element in elements){
            if(contains(element)){
                return true;
            }
        }
        return false;
    }
    shared actual Boolean containsAny(Object... elements) {
        for(Object element in elements){
            if(!contains(element)){
                return false;
            }
        }
        return true;
    }
    
    shared actual Set<Element> complement<Other>(Set<Other> set) 
    given Other satisfies Object {
        HashSet<Element> ret = HashSet<Element>();
        for(Element elem in this){
            if(!set.contains(elem)){
                ret.add(elem);
            }
        }
        return ret;
    }

    shared actual Set<Element|Other> exclusiveUnion<Other>(Set<Other> set) 
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
    
    shared actual Set<Element&Other> intersection<Other>(Set<Other> set) 
    given Other satisfies Object {
        HashSet<Element&Other> ret = HashSet<Element&Other>();
        for(Element elem in this){
            if(set.contains(elem)){
                // FIXME: can't implement yet
                //if(is Other elem){
                //    ret.add(elem);
                //}
            }
        }
        return ret;
    }

    shared actual Set<Element|Other> union<Other>(Set<Other> set) 
    given Other satisfies Object {
        HashSet<Element|Other> ret = HashSet<Element|Other>();
        ret.addAll(this.sequence...);
        ret.addAll(set.sequence...);
        return ret;
    }

    doc "Determines if this Set is a superset of the specified Set,
         that is, if this Set contains all of the elements in the
         specified Set."
    shared actual Boolean superset(Set<Object> set) {
        for (element in set) {
            if (!contains(element)) {
                return false;
            }
        }
        return true;
    }

    doc "Determines if this Set is a subset of the specified Set,
         that is, if the specified Set contains all of the
         elements in this Set."
    shared actual Boolean subset(Set<Object> set) {
        for (element in this) {
            if (!set.contains(element)) {
                return false;
            }
        }
        return true;
    }
}
