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
 - An [[unlinked]] set has an unstable iteration order that 
   may change when the set is modified. The order itself is 
   not meaningful to a client.
 
 The management of the backing array is controlled by the
 given [[hashtable]]."

by ("Stéphane Épardaud", "Gavin King")
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
    
    variable value store = elementStore<Element>
            (hashtable.initialCapacity);
    variable Integer length = 0;
    
    variable LinkedCell<Element>? head = null;
    variable LinkedCell<Element>? tip = null;
    
    // Write
    
    Integer storeIndex(Object elem, Array<Cell<Element>?> store)
            => (elem.hash % store.size).magnitude;
    
    Cell<Element> createCell(Element elem, Cell<Element>? rest) {
        if (stability==linked) {
            value cell = LinkedCell(elem, rest, tip);
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
            return Cell(elem, rest);
        }
    }
    
    void deleteCell(Cell<Element> cell) {
        if (stability==linked) {
            assert (is LinkedCell<Element> cell);
            if (exists last = cell.previous) {
                last.next = cell.next;
            }
            else {
                head = cell.next;
            }
            if (exists next = cell.next) {
                next.previous = cell.previous;
            }
            else {
                tip = cell.previous;
            }
        }
    }
    
    Boolean addToStore(Array<Cell<Element>?> store, Element element) {
        Integer index = storeIndex(element, store);
        variable value bucket = store[index];
        while (exists cell = bucket) {
            if (cell.element == element) {
                // modify an existing entry
                cell.element = element;
                return false;
            }
            bucket = cell.rest;
        }
        // add a new entry
        store.set(index, createCell(element, store[index]));
        return true;
    }
    
    void checkRehash() {
        if (hashtable.rehash(length, store.size)) {
            // must rehash
            value newStore = elementStore<Element>
                    (hashtable.capacity(length));
            variable Integer index = 0;
            // walk every bucket
            while (index < store.size) {
                variable value bucket = store[index];
                while (exists cell = bucket) {
                    bucket = cell.rest;
                    Integer newIndex = storeIndex(cell.element, newStore);
                    variable value newBucket = newStore[newIndex];
                    while (exists newCell = newBucket?.rest) {
                        newBucket = newCell;
                    }
                    cell.rest = newBucket;
                    newStore.set(newIndex, cell);
                }
                index++;
            }
            store = newStore;
        }
    }
    
    // Add initial values
    for (val in elements) {
        if (addToStore(store, val)) {
            length++;
        }        
    }
    checkRehash();
    
    // End of initialiser section
    
    shared actual Boolean add(Element element) {
        if(addToStore(store, element)){
            length++;
            checkRehash();
            return true;
        }
        return false;
    }
    
    shared actual Boolean addAll({Element*} elements) {
        variable Boolean ret = false;
        for(elem in elements){
            if (addToStore(store, elem)) {
                ret = true;
            }
        }
        if (ret) {
            checkRehash();
        }
        return ret;
    }
    
    shared actual Boolean remove(Element element) {
        variable value result = false;
        Integer index = storeIndex(element, store);
        while (exists head = store[index], 
            head.element == element) {
            store.set(index,head.rest);
            length--;
            result = true;
        }
        variable value bucket = store[index];
        while (exists cell = bucket) {
            value rest = cell.rest;
            if (exists rest,
                rest.element == element) {
                cell.rest = rest.rest;
                deleteCell(cell);
                length--;
                result = true;
            }
            else {
                bucket = rest;
            }
        }
        return result;
    }
    
    shared actual void clear(){
        variable Integer index = 0;
        // walk every bucket
        while(index < store.size){
            store.set(index++, null);
        }
        length = 0;
        head = null;
        tip = null;
    }
    
    // Read
    
    size => length;
    
    iterator() => stability==linked 
            then LinkedCellIterator(head)
            else StoreIterator(store);
    
    shared actual Integer count(Boolean selecting(Element element)) {
        variable Integer count = 0;
        variable Integer index = 0;
        // walk every bucket
        while(index < store.size){
            variable value bucket = store[index];
            while(exists cell = bucket){
                if(selecting(cell.element)){
                    count++;
                }
                bucket = cell.rest;
            }
            index++;
        }
        return count;
    }
    
    shared actual Integer hash {
        variable Integer index = 0;
        variable Integer hash = 0;
        // walk every bucket
        while (index < store.size){
            variable value bucket = store[index];
            while (exists cell = bucket){
                hash += cell.element.hash;
                bucket = cell.rest;
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
                    if(!that.contains(cell.element)){
                        return false;
                    }
                    bucket = cell.rest;
                }
                index++;
            }
            return true;
        }
        return false;
    }
    
    shared actual HashSet<Element> clone() {
        value clone = HashSet<Element>();
        clone.length = length;
        clone.store = elementStore<Element>(store.size);
        variable Integer index = 0;
        // walk every bucket
        while(index < store.size){
            if(exists bucket = store[index]){
                clone.store.set(index, bucket.clone()); 
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
                if(cell.element == element){
                    return true;
                }
                bucket = cell.rest;
            }
            index++;
        }
        return false;
    }
    
    shared actual HashSet<Element> complement<Other>
            (Set<Other> set) 
            given Other satisfies Object {
        value ret = HashSet<Element>();
        for(elem in this){
            if(!set.contains(elem)){
                ret.add(elem);
            }
        }
        return ret;
    }
    
    shared actual HashSet<Element|Other> exclusiveUnion<Other>
            (Set<Other> set) 
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
    
    shared actual HashSet<Element&Other> intersection<Other>
            (Set<Other> set) 
            given Other satisfies Object {
        value ret = HashSet<Element&Other>();
        for(elem in this){
            if(set.contains(elem), is Other elem){
                ret.add(elem);
            }
        }
        return ret;
    }
    
    shared actual HashSet<Element|Other> union<Other>
            (Set<Other> set) 
            given Other satisfies Object {
        value ret = HashSet<Element|Other>();
        ret.addAll(this);
        ret.addAll(set);
        return ret;
    }
    
    shared actual Element? first {
        if (stability==linked) {
            return head?.element;
        }
        else {
            return store[0]?.element;
        }
    }
    
    shared actual Element? last {
        if (stability==linked) {
            return tip?.element;
        }
        else {
            variable value bucket = store[store.size-1];
            while (exists cell = bucket?.rest) {
                bucket = cell;
            }
            return bucket?.element;
        }
    }
    
}
