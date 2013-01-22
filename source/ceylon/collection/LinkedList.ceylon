by "Stéphane Épardaud"
doc "A mutable Linked List"
shared class LinkedList<Element>() satisfies MutableList<Element> {
    variable Cell<Element>? head = null;
    variable Cell<Element>? tail = null;
    variable Integer _size = 0; 

    // Write
    
    doc "Sets an item at the given index. List is expanded if index > size"
    shared actual void setItem(Integer index, Element val){
        if(index < _size){
            variable Cell<Element>? iter = head;
            variable Integer i = 0;
            while(exists Cell<Element> cell = iter){
                if(i++ == index){
                    cell.car = val;
                    return;
                }
                iter = cell.cdr;
            }
        }else{
            // need to grow
            variable Integer need = index - _size;
            Cell<Element> newTail = Cell<Element>(val, null);
            variable Cell<Element> newHead = newTail;
            while(need-- > 0){
                newHead = Cell<Element>(/*FIXME*/val, newHead);
            }
            // now put it at the end
            if(exists Cell<Element> tail = tail){
                tail.cdr = newHead;
            }else{
                // if we don't have a tail, we also don't have a head
                head = newHead;
            }
            // change the tail
            tail = newTail;
            // cache the size
            _size = index+1;
        }
    }

    doc "Inserts an item at specified index, list is expanded if index > size"    
    shared actual void insert(Integer index, Element val){
        if(index >= _size){
            setItem(index, val);
        }else{
            Cell<Element> newCell = Cell<Element>(val, null);
            if(index == 0){
                newCell.cdr = head;
                head = newCell;
                // we only have to update the tail if _size == 0 but that's not possible
                // since it has already been checked
            }else{
                variable Cell<Element>? iter = head;
                variable Cell<Element>? prev = null;
                variable Integer i = 0;
                while(exists Cell<Element> cell = iter){
                    if(i++ == index){
                        if(exists Cell<Element> prev2 = prev){
                            prev2.cdr = newCell;
                            newCell.cdr = cell;
                            // no need to update the tail since we never modify the last element, we would
                            // have called setItem above instead
                        }else{
                            // cannot happen
                        }
                        break;
                    }
                    prev = iter;
                    iter = cell.cdr;
                }
            }
            _size++;
        }
    }
    
    doc "Adds an item at the end of this list"
    shared actual void add(Element val){
        Cell<Element> newTail = Cell<Element>(val, null);
        if(exists Cell<Element> tail = tail){
            tail.cdr = newTail;
            this.tail = newTail;
        }else{
            // no tail means empty list
            tail = head = newTail;
        }
        _size++;
    }
    
    shared actual void addAll(Element* values) {
        for (val in values) {
            add(val);
        }
    }
    
    doc "Removes the item at the specified index"
    shared actual void remove(Integer index){
        if(index < _size){
            variable Cell<Element>? iter = head;
            variable Cell<Element>? prev = null;
            variable Integer i = 0;
            while(exists Cell<Element> cell = iter){
                if(i++ == index){
                    if(exists Cell<Element> prev2 = prev){
                        prev2.cdr = cell.cdr;
                    }else{
                        // changing the head
                        head = cell.cdr;
                    }
                    // see if we need to update the tail
                    if(!cell.cdr exists){
                        tail = prev;
                    }
                    _size--;
                    return;
                }
                prev = iter;
                iter = cell.cdr;
            }
        }else{
            // FIXME
            throw;
        }
    }

    doc "Remove every item"
    shared actual void clear(){
        _size = 0;
        head = tail = null;
    }
    
    // Read
    
    shared actual Element? item(Integer index) {
        variable Cell<Element>? iter = head;
        variable Integer i = 0;
        while(exists Cell<Element> cell = iter){
            if(i++ == index){
                return cell.car;
            }
            iter = cell.cdr;
        }
        return null;
    }
    
    doc "Not implemented yet"
    // FIXME
    shared actual Element?[] items({Integer*} keys) {
        return nothing;
    }
    
    doc "Not implemented yet"
    // FIXME
    shared actual Sequence<Element> span(Integer from, Integer to) {
        return nothing;
    }
    doc "Not implemented yet"
    // FIXME
    shared actual Sequence<Element> spanFrom(Integer from) {
        return nothing;
    }
    doc "Not implemented yet"
    // FIXME
    shared actual Sequence<Element> spanTo(Integer to) {
        return nothing;
    }
    doc "Not implemented yet"
    // FIXME
    shared actual Sequence<Element> segment(Integer from, Integer length) {
        return nothing;
    }
    
    shared actual Boolean defines(Integer index) {
        return index >= 0 && index < _size;
    }
    shared actual Boolean definesAny({Integer*} keys) {
        for(Integer key in keys){
            if(defines(key)){
                return true;
            }
        }
        return false;
    }
    shared actual Boolean definesEvery({Integer*} keys) {
        for(Integer key in keys){
            if(!defines(key)){
                return false;
            }
        }
        return true;
    }
    
    shared actual Boolean contains(Object element) {
        variable Cell<Element>? iter = head;
        while(exists Cell<Element> cell = iter){
            if(is Object elem = cell.car){
                if(elem == element){
                    return true;
                }
            }
            iter = cell.cdr;
        }
        return false;
    }
    
    shared actual Boolean containsAny({Object*} elements) {
        for(Object elem in elements){
            if(contains(elem)){
                return true;
            }
        }
        return false;
    }
    shared actual Boolean containsEvery({Object*} elements) {
        for(Object elem in elements){
            if(!contains(elem)){
                return false;
            }
        }
        return true;
    }
    
    shared actual Integer size {
        return _size;
    }
    
    shared actual Boolean empty {
        return size == 0;
    }
    
    shared actual Integer count(Boolean selecting(Element element)) {
        variable Cell<Element>? iter = head;
        variable Integer c = 0;
        while(exists Cell<Element> cell = iter){
            if(selecting(cell.car)){
                c++;
            }
            iter = cell.cdr;
        }
        return c;
    }
    
    shared actual Integer? lastIndex {
        return !empty then _size - 1;
    }
    
    shared actual Iterator<Element> iterator {
        return CellIterator(head);
    }
    
    shared actual List<Element> clone {
        LinkedList<Element> ret = LinkedList<Element>();
        ret.head = head;
        ret.tail = tail;
        ret._size = size;
        return ret;
    }
    shared actual Integer[] keys {
        return empty then {} else 0.._size;
    }

    shared actual String string {
        StringBuilder b = StringBuilder();
        b.append("[");
        variable Cell<Element>? iter = head;
        while(exists Cell<Element> cell = iter){
            if(is Object car = cell.car){
                b.append(car.string);
            }else{
                b.append("null");
            }
            iter = cell.cdr;
            if(iter exists){
                b.append(", ");
            }
        }
        b.append("]");
        return b.string;
    }
    
    shared actual Integer hash {
        variable Integer h = 17;
        variable Cell<Element>? iter = head;
        while(exists Cell<Element> cell = iter){
            if(is Object car = cell.car){
                h = h * 31 + car.hash;                
            }else{
                h = h * 31;
            }
            iter = cell.cdr;
        }
        return h;
    }
    
    doc "Not implemented yet"
    see (equalsTemp)
    shared actual Boolean equals(Object that) {
        // grrr, we can't implement this :(
        return false;
    }
    
    shared Boolean equalsTemp(LinkedList<Element> that){
        if(_size != that._size){
            return false;
        }
        variable Cell<Element>? iter = head;
        variable Cell<Element>? iter2 = that.head;
        while(exists Cell<Element> cell = iter){
            if(exists Cell<Element> cell2 = iter2){
                if(is Object car = cell.car){
                    if(is Object car2 = cell2.car){
                       if(car != car2){
                           return false;
                       }
                    }else{
                        return false;
                    }
                }else{
                    // both must be non-objects?
                    if(cell2.car is Object){
                        return false;
                    }
                }
                iter2 = cell2.cdr;
            }else{
                return false;
            }
            iter = cell.cdr;
        }
        return true;
    }

    doc "Not implemented yet"
    shared actual LinkedList<Element> reversed {
        return nothing;
    }
}
