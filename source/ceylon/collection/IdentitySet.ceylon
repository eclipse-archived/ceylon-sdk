"An identity set implemented as a hash set stored in an 
 [[Array]] of singly linked lists. The hash code of an 
 element is defined by [[identityHash]]. Note that an 
 `IdentitySet` is not a [[Set]], since it does not obey the 
 semantics of a `Set`. In particular, it may contain 
 multiple elements which are equal, as determined by the
 `==` operator."
by ("Gavin King")
shared class IdentitySet<Element>
        (hashtable=Hashtable(), elements = {})
        satisfies {Element*} & Collection<Element> &
                  Cloneable<IdentitySet<Element>>
        given Element satisfies Identifiable {
    
    "The initial elements of the set."
    {Element*} elements;
    
    "Performance-related settings for the backing array."
    Hashtable hashtable;
    
    variable value store = elementStore<Element>
            (hashtable.initialCapacity);
    variable Integer length = 0;
    
    // Write
    
    Integer storeIndex(Identifiable elem, Array<Cell<Element>?> store)
            => (identityHash(elem) % store.size).magnitude;
    
    Boolean addToStore(Array<Cell<Element>?> store, Element element){
        Integer index = storeIndex(element, store);
        variable value bucket = store[index];
        while(exists cell = bucket){
            if(cell.element === element){
                // modify an existing entry
                cell.element = element;
                return false;
            }
            bucket = cell.rest;
        }
        // add a new entry
        store.set(index, Cell(element, store[index]));
        return true;
    }
    
    void checkRehash(){
        if(length > (store.size.float * hashtable.loadFactor).integer){
            // must rehash
            value newStore = elementStore<Element>
                    ((length * hashtable.growthFactor).integer);
            variable Integer index = 0;
            // walk every bucket
            while(index < store.size){
                variable value bucket = store[index];
                while(exists cell = bucket){
                    bucket = cell.rest;
                    Integer newIndex = storeIndex(cell.element, newStore);
                    variable value newBucket = newStore[newIndex];
                    while(exists newCell = newBucket?.rest){
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
    for(element in elements){
        if(addToStore(store, element)){
            length++;
        }        
    }
    checkRehash();
    
    // End of initialiser section
    
    shared Boolean add(Element element){
        if(addToStore(store, element)){
            length++;
            checkRehash();
            return true;
        }
        return false;
    }
    
    shared Boolean addAll({Element*} elements){
        variable Boolean ret = false;
        for(Element elem in elements){
            ret ||= add(elem);
        }
        if (ret) {
            checkRehash();
        }
        return ret;
    }
    
    shared Boolean remove(Element element){
        Integer index = storeIndex(element, store);
        variable value bucket = store[index];
        variable value prev = null of Cell<Element>?;
        while(exists  cell = bucket){
            if(cell.element === element){
                // found it
                if(exists last = prev){
                    last.rest = cell.rest;
                }else{
                    store.set(index, cell.rest);
                }
                length--;
                return true;
            }
            prev = cell;
            bucket = cell.rest;
        }
        return false;
    }
    
    "Removes every element"
    shared void clear(){
        variable Integer index = 0;
        // walk every bucket
        while(index < store.size){
            store.set(index++, null);
        }
        length = 0;
    }
    
    // Read
    
    size => length;
    
    iterator() => StoreIterator(store);
    
    shared actual Integer count(Boolean selecting(Element element)) {
        variable Integer c = 0;
        variable Integer index = 0;
        // walk every bucket
        while(index < store.size){
            variable value bucket = store[index];
            while(exists cell = bucket){
                if(selecting(cell.element)){
                    c++;
                }
                bucket = cell.rest;
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
            variable Cell<Element>? bucket = store[index];
            while(exists Cell<Element> cell = bucket){
                hash = hash * 31 + identityHash(cell);
                bucket = cell.rest;
            }
            index++;
        }
        return hash;
    }
    
    shared actual Boolean equals(Object that) {
        if(is IdentitySet<Object> that,
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
    
    shared actual IdentitySet<Element> clone {
        value clone = IdentitySet<Element>();
        clone.length = length;
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
        if (is Identifiable element) {
            variable Integer index = 0;
            // walk every bucket
            while(index < store.size){
                variable value bucket = store[index];
                while(exists cell = bucket){
                    if(cell.element === element){
                        return true;
                    }
                    bucket = cell.rest;
                }
                index++;
            }
        }
        return false;
    }
    
    shared default Boolean superset<Other>
            (IdentitySet<Other> set) 
            given Other satisfies Identifiable {
        for (element in set) {
            if (!element in this) {
                return false;
            }
        }
        else {
            return true;
        }
    }
    
    shared default Boolean subset<Other>
            (IdentitySet<Other> set) 
            given Other satisfies Identifiable {
        for (element in this) {
            if (!element in set) {
                return false;
            }
        }
        else {
            return true;
        }
    }
    
    shared IdentitySet<Element> complement<Other>
            (IdentitySet<Other> set) 
            given Other satisfies Identifiable {
        value ret = IdentitySet<Element>();
        for(elem in this){
            if(!set.contains(elem)){
                ret.add(elem);
            }
        }
        return ret;
    }
    
    shared IdentitySet<Element|Other> exclusiveUnion<Other>
            (IdentitySet<Other> set) 
            given Other satisfies Identifiable {
        value ret = IdentitySet<Element|Other>();
        for(elem in this){
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
    
    shared IdentitySet<Element&Other> intersection<Other>
            (IdentitySet<Other> set) 
            given Other satisfies Identifiable {
        value ret = IdentitySet<Element&Other>();
        for(elem in this){
            if(set.contains(elem), is Other elem){
                ret.add(elem);
            }
        }
        return ret;
    }
    
    shared IdentitySet<Element|Other> union<Other>
            (IdentitySet<Other> set) 
            given Other satisfies Identifiable {
        value ret = IdentitySet<Element|Other>();
        ret.addAll(this);
        ret.addAll(set);
        return ret;
    }
    
}
