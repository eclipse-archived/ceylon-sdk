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
    
    variable value store = elementStore<Element>(hashtable.initialCapacity);
    variable Integer _size = 0;
    
    // Write
    
    Integer storeIndex(Identifiable elem, Array<Cell<Element>?> store)
            => (identityHash(elem) % store.size).magnitude;
    
    Boolean addToStore(Array<Cell<Element>?> store, Element element){
        Integer index = storeIndex(element, store);
        variable Cell<Element>? bucket = store[index];
        while(exists Cell<Element> cell = bucket){
            if(cell.car === element){
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
        if(_size > (store.size.float * hashtable.loadFactor).integer){
            // must rehash
            value newStore = elementStore<Element>((_size * hashtable.growthFactor).integer);
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
    for(element in elements){
        if(addToStore(store, element)){
            _size++;
        }        
    }
    checkRehash();
    
    // End of initialiser section
    
    shared Boolean add(Element element){
        if(addToStore(store, element)){
            _size++;
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
        checkRehash();
        return ret;
    }
    
    shared Boolean remove(Element element){
        Integer index = storeIndex(element, store);
        variable Cell<Element>? bucket = store[index];
        variable Cell<Element>? prev = null;
        while(exists Cell<Element> cell = bucket){
            if(cell.car === element){
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
    shared void clear(){
        variable Integer index = 0;
        // walk every bucket
        while(index < store.size){
            store.set(index++, null);
        }
        _size = 0;
    }
    
    // Read
    
    shared actual Integer size {
        return _size;
    }
    
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
                hash = hash * 31 + identityHash(cell);
                bucket = cell.cdr;
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
    
    shared actual IdentitySet<Element> clone {
        IdentitySet<Element> clone = IdentitySet<Element>();
        clone._size = _size;
        clone.store = elementStore<Element>(store.size);
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
        if (is Identifiable element) {
            variable Integer index = 0;
            // walk every bucket
            while(index < store.size){
                variable Cell<Element>? bucket = store[index];
                while(exists Cell<Element> cell = bucket){
                    if(cell.car === element){
                        return true;
                    }
                    bucket = cell.cdr;
                }
                index++;
            }
        }
        return false;
    }
    
    shared default Boolean superset<Other>(IdentitySet<Other> set) 
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
    
    shared default Boolean subset<Other>(IdentitySet<Other> set) 
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
    
    shared IdentitySet<Element> complement<Other>(IdentitySet<Other> set) 
            given Other satisfies Identifiable {
        IdentitySet<Element> ret = IdentitySet<Element>();
        for(Element elem in this){
            if(!set.contains(elem)){
                ret.add(elem);
            }
        }
        return ret;
    }
    
    shared IdentitySet<Element|Other> exclusiveUnion<Other>(IdentitySet<Other> set) 
            given Other satisfies Identifiable {
        IdentitySet<Element|Other> ret = IdentitySet<Element|Other>();
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
    
    shared IdentitySet<Element&Other> intersection<Other>(IdentitySet<Other> set) 
            given Other satisfies Identifiable {
        IdentitySet<Element&Other> ret = IdentitySet<Element&Other>();
        for(Element elem in this){
            if(set.contains(elem), is Other elem){
                ret.add(elem);
            }
        }
        return ret;
    }
    
    shared IdentitySet<Element|Other> union<Other>(IdentitySet<Other> set) 
            given Other satisfies Identifiable {
        IdentitySet<Element|Other> ret = IdentitySet<Element|Other>();
        ret.addAll(this);
        ret.addAll(set);
        return ret;
    }
    
}
