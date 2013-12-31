import ceylon.collection {
    Cell,
    MutableSet,
    elementStore
}

"A [[MutableSet]] implemented as a hash set stored in an 
 [[Array]] of singly linked lists. Each element is assigned 
 an index of the array according to its hash code. The hash 
 code of an element is defined by [[Object.hash]].
 
 The [[stability]] of a `HashSet` controls its iteration
 order:
 
 - A [[linked]] set has a stable and meaningful order of 
   iteration. The elements of the set form a linked list, 
   where new elements are added to the end of the linked 
   list. Iteration of the set follows this linked list, from 
   least recently added elements to most recently added 
   elements.
 - An [[unlinked]] `HashSet` has an unstable iteration order
   that may change when the set is modified. The order 
   itself is not meaningful to a client.
 
 The management of the backing array is controlled by the
 given [[hashtable]]."

by("Stéphane Épardaud", "Gavin King")
shared class HashSet<Element>
        (stability=linked, hashtable = Hashtable(), elements = {})
        satisfies MutableSet<Element>
        given Element satisfies Object {
    
    "Determines whether this is a linked hash set with a
     stable iteration order."
    Stability stability;
    
    "The initial elements of the set."
    {Element*} elements;
    
    "Performance-related settings for the backing array."
    Hashtable hashtable;
    
    variable value store = elementStore<Element>(hashtable.initialCapacity);
    variable Integer _size = 0;
    
    variable LinkedCell<Element>? head = null;
    variable LinkedCell<Element>? tip = null;
    
    // Write
    
    Integer storeIndex(Object elem, Array<Cell<Element>?> store)
            => (elem.hash % store.size).magnitude;
    
    Cell<Element> createCell(Element car, Cell<Element>? cdr) {
        if (stability==linked) {
            value cell = LinkedCell(car, cdr, tip);
            if (exists last = tip) {
                last.next = cell;
            }
            tip = cell;
            if (!head exists) {
                head = cell;
            }
            return cell;
        }
        else {
            return Cell(car, cdr);
        }
    }
    
    void deleteCell(Cell<Element> cell) {
        if (stability==linked) {
            assert (is LinkedCell<Element> cell);
            if (exists last = cell.last) {
                last.next = cell.next;
            }
            else {
                head = cell.next;
            }
            if (exists next = cell.next) {
                next.last = cell.last;
            }
            else {
                tip = cell.last;
            }
        }
    }
    
    Boolean addToStore(Array<Cell<Element>?> store, Element element){
        Integer index = storeIndex(element, store);
        variable value bucket = store[index];
        while(exists cell = bucket){
            if(cell.car == element){
                // modify an existing entry
                cell.car = element;
                return false;
            }
            bucket = cell.cdr;
        }
        // add a new entry
        store.set(index, createCell(element, store[index]));
        return true;
    }
    
    void checkRehash(){
        if(_size > (store.size.float * hashtable.loadFactor).integer){
            // must rehash
            value newStore = elementStore<Element>((_size * hashtable.growthFactor).integer);
            variable Integer index = 0;
            // walk every bucket
            while(index < store.size){
                variable value bucket = store[index];
                while(exists cell = bucket){
                    bucket = cell.cdr;
                    Integer newIndex = storeIndex(cell.car, newStore);
                    variable value newBucket = newStore[newIndex];
                    while(exists newCell = newBucket?.cdr){
                        newBucket = newCell;
                    }
                    cell.cdr = newBucket;
                    newStore.set(newIndex, cell);
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
        for(elem in elements){
            ret ||= add(elem);
        }
        checkRehash();
        return ret;
    }
    
    shared actual Boolean remove(Element element){
        Integer index = storeIndex(element, store);
        variable value bucket = store[index];
        variable value prev = null of Cell<Element>?;
        while(exists cell = bucket){
            if(cell.car == element){
                // found it
                if(exists last = prev){
                    last.cdr = cell.cdr;
                }else{
                    store.set(index, cell.cdr);
                }
                deleteCell(cell);
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
        head = null;
        tip = null;
    }
    
    // Read
    
    size => _size;
    
    iterator() => stability==linked 
            then LinkedCellIterator(head)
            else StoreIterator(store);
    
    shared actual Integer count(Boolean selecting(Element element)) {
        variable Integer c = 0;
        variable Integer index = 0;
        // walk every bucket
        while(index < store.size){
            variable value bucket = store[index];
            while(exists cell = bucket){
                if(selecting(cell.car)){
                    c++;
                }
                bucket = cell.cdr;
            }
            index++;
        }
        return c;
    }
    
    shared actual Integer hash {
        variable Integer index = 0;
        variable Integer hash = 17;
        // walk every bucket
        while(index < store.size){
            variable value bucket = store[index];
            while(exists cell = bucket){
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
                variable value bucket = store[index];
                while(exists cell = bucket){
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
        value clone = HashSet<Element>();
        clone._size = _size;
        clone.store = elementStore<Element>(store.size);
        variable Integer index = 0;
        // walk every bucket
        while(index < store.size){
            if(exists bucket = store[index]){
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
            variable value bucket = store[index];
            while(exists cell = bucket){
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
        value ret = HashSet<Element>();
        for(elem in this){
            if(!set.contains(elem)){
                ret.add(elem);
            }
        }
        return ret;
    }
    
    shared actual HashSet<Element|Other> exclusiveUnion<Other>(Set<Other> set) 
    given Other satisfies Object {
        value ret = HashSet<Element|Other>();
        for(elem in this){
            if(!set.contains(elem)){
                ret.add(elem);
            }
        }
        for(elem in set){
            if(!contains(elem)){
                ret.add(elem);
            }
        }
        return ret;
    }
    
    shared actual HashSet<Element&Other> intersection<Other>(Set<Other> set) 
    given Other satisfies Object {
        value ret = HashSet<Element&Other>();
        for(elem in this){
            if(set.contains(elem), is Other elem){
                ret.add(elem);
            }
        }
        return ret;
    }
    
    shared actual HashSet<Element|Other> union<Other>(Set<Other> set) 
    given Other satisfies Object {
        value ret = HashSet<Element|Other>();
        ret.addAll(this);
        ret.addAll(set);
        return ret;
    }
    
    shared actual Element? first {
        if (stability==linked) {
            return head?.car;
        }
        else {
            return store[0]?.car;
        }
    }
    
    shared actual Element? last {
        if (stability==linked) {
            return tip?.car;
        }
        else {
            variable value bucket = store[store.size-1];
            while (exists cell = bucket?.cdr) {
                bucket = cell;
            }
            return bucket?.car;
        }
    }
    
}
