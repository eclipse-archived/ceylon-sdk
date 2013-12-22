"A [[MutableList]] implemented as a singly linked list.
 Also:
 
 - a [[Stack]], where the top of the stack is the _first_ 
   element of the list, and
 - a [[Queue]], where the front of the queue is the first
   element of the list and the back of the queue is the
   last element of the list."
by("Stéphane Épardaud")
shared class LinkedList<Element>({Element*} elements = {}) 
        satisfies MutableList<Element> &
                  Stack<Element> & Queue<Element> {
    variable Cell<Element>? head = null;
    variable Cell<Element>? tail = null;
    variable Integer _size = 0; 
    
    // initialiser section
    
    void _add(Element element){
        Cell<Element> newTail = Cell<Element>(element, null);
        if(exists Cell<Element> tail = tail){
            tail.cdr = newTail;
            this.tail = newTail;
        }else{
            // no tail means empty list
            tail = head = newTail;
        }
        _size++;
    }
    
    // add initial values
    for(element in elements){
        _add(element);
    }
    
    // End of initialiser section
    
    // Write
    
    shared actual void set(Integer index, Element element){
        "index may not be negative or greater than the
         last index in the list"
        assert (0<=index<_size);
        variable Cell<Element>? iter = head;
        variable Integer i = 0;
        while(exists Cell<Element> cell = iter){
            if(i++ == index){
                cell.car = element;
                return;
            }
            iter = cell.cdr;
        }
    }
    
    shared actual void insert(Integer index, Element element){
        "index may not be negative or greater than the
         length of the list"
        assert (0<=index<=_size);
        if(index == _size){
            add(element);
        }else{
            Cell<Element> newCell = Cell<Element>(element, null);
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
                            // no need to update the tail since we never modify the last 
                            // element, we would have taken the other branch above instead
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
    
    shared actual void add(Element element){
        _add(element);
    }
    
    shared actual void addAll({Element*} elements) {
        for (element in elements) {
            add(element);
        }
    }
    
    shared actual Element? delete(Integer index){
        if(0 <= index < _size){
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
                    return cell.car;
                }
                prev = iter;
                iter = cell.cdr;
            }
            assert (false);
        }else{
            return null;
        }
    }
    
    shared actual void removeAll(Element&Object element) {
        variable Cell<Element>? iter = head;
        variable Cell<Element>? prev = null;
        while(exists Cell<Element> cell = iter){
            if(exists elem = cell.car, elem==element){
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
                // keep the same prev but move on
                iter = cell.cdr;
            }else{
                prev = iter;
                iter = cell.cdr;
            }
        }
    }
    
    shared actual Boolean removeFirst(Element&Object element) {
        variable Cell<Element>? iter = head;
        variable Cell<Element>? prev = null;
        while(exists Cell<Element> cell = iter){
            if(exists elem = cell.car, elem==element){
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
                // keep the same prev but move on
                iter = cell.cdr;
                return true;
            }else{
                prev = iter;
                iter = cell.cdr;
            }
        }
        return false;
    }
    
    shared actual void prune() {
        variable Cell<Element>? iter = head;
        variable Cell<Element>? prev = null;
        while(exists Cell<Element> cell = iter){
            if(!cell.car exists){
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
                // keep the same prev but move on
                iter = cell.cdr;
            }else{
                prev = iter;
                iter = cell.cdr;
            }
        }
    }
    
    shared actual void replaceAll(Element&Object element, 
            Element replacement) {
        variable Cell<Element>? iter = head;
        while(exists Cell<Element> cell = iter){
            if(exists elem = cell.car, elem==element){
                cell.car = replacement;
            }
            iter = cell.cdr;
        }
    }
    
    shared actual Boolean replaceFirst(Element&Object element, 
            Element replacement) {
        variable Cell<Element>? iter = head;
        while(exists Cell<Element> cell = iter){
            if(exists elem = cell.car, elem==element){
                cell.car = replacement;
                return true;
            }
            iter = cell.cdr;
        }
        return false;
    }
    
    shared actual void infill(Element replacement) {
        variable Cell<Element>? iter = head;
        while(exists Cell<Element> cell = iter){
            if(!cell.car exists){
                cell.car = replacement;
            }
            iter = cell.cdr;
        }
    }
    
    shared actual void clear(){
        _size = 0;
        head = tail = null;
    }
    
    // Read
    
    shared actual Element? get(Integer index) {
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
    
    shared actual List<Element> span(Integer from, Integer to) {
        value start = from>to then to else from;
        value end = from>to then from else to;
        value ret = LinkedList<Element>();
        variable Cell<Element>? iter = head;
        variable Integer i = 0;
        while(exists Cell<Element> cell = iter){
            if(i > end){
                break;
            }
            if(i >= start){
                ret.add(cell.car);
            }
            i++;
            iter = cell.cdr;
        }
        return ret;
    }
    
    shared actual List<Element> spanFrom(Integer from) {
        value ret = LinkedList<Element>();
        variable Cell<Element>? iter = head;
        variable Integer i = 0;
        while(exists Cell<Element> cell = iter){
            if(i >= from){
                ret.add(cell.car);
            }
            i++;
            iter = cell.cdr;
        }
        return ret;
    }
    
    shared actual List<Element> spanTo(Integer to) {
        value ret = LinkedList<Element>();
        variable Cell<Element>? iter = head;
        variable Integer i = 0;
        while(exists Cell<Element> cell = iter){
            if(i > to){
                break;
            }
            ret.add(cell.car);
            i++;
            iter = cell.cdr;
        }
        return ret;
    }
    
    shared actual List<Element> segment(Integer from, Integer length) {
        value ret = LinkedList<Element>();
        value len = from<0 then length+from else length;
        variable Cell<Element>? iter = head;
        variable Integer i = 0;
        while(exists Cell<Element> cell = iter){
            if(ret._size >= len){
                break;
            }
            if(i >= from){
                ret.add(cell.car);
            }
            i++;
            iter = cell.cdr;
        }
        return ret;
    }
    
    shared actual void deleteSegment(Integer from, Integer length) {
        value fst = from<0 then 0 else from;
        value len = from<0 then length+from else length;
        if (fst<this._size && len>0) {
            del(fst, len);
        }
    }
    
    shared actual void deleteSpan(Integer from, Integer to) {
        value start = from>to then to else from;
        value end = from>to then from else to;
        value fst = start<0 then 0 else start;
        value len = (end<0 then 0) else (start<0 then end+1) else end-start+1;
        if (fst<this._size && len>0) {
            del(fst, len);
        }
    }
    
    shared actual Boolean defines(Integer index) {
        return index >= 0 && index < _size;
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
    
    shared actual Integer size {
        return _size;
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
    
    shared actual Iterator<Element> iterator() {
        return CellIterator(head);
    }
    
    shared actual MutableList<Element> clone {
        LinkedList<Element> ret = LinkedList<Element>();
        ret.head = head;
        ret.tail = tail;
        ret._size = size;
        return ret;
    }

    shared actual Integer[] keys {
        return empty then {} else 0.._size;
    }

    /*shared actual String string {
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
    }*/
    
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
    
    shared actual Boolean equals(Object that) {
        if(is List<Object> that,
            _size == that.size){
            variable Cell<Element>? iter = head;
            variable Iterator<Object> iter2 = that.iterator();
            while(exists Cell<Element> cell = iter){
                if(!is Finished thatElement = iter2.next()){
                    if(!eq(cell.car, thatElement)){
                        return false;
                    }
                    iter = cell.cdr;
                }else{
                    return false;
                }
            }
            return true;
        }
        return false;
    }
    
    shared actual List<Element> reversed {
        value ret = LinkedList<Element>();

        variable Cell<Element>? iter = head;
        while(exists Cell<Element> cell = iter){
            // append before the head
            ret.head = Cell(cell.car, ret.head);
            if(!ret.tail exists){
                ret.tail = ret.head;
            }
            iter = cell.cdr;
        }
        ret._size = _size;
        return ret;
    }
    
    shared actual List<Element> rest {
        // this would be a lot cheaper if we were not mutable, but there we are
        value ret = LinkedList<Element>();
        variable Cell<Element>? iter = head?.cdr; // skip the first one
        while(exists Cell<Element> cell = iter){
            ret.add(cell.car);
            iter = cell.cdr;
        }
        return ret;
    }
    
    void del(Integer fst, Integer len) {
        if (fst==0) {
            head = null;
            variable Integer i = 0;
            variable Cell<Element>? iter = head;
            while(exists Cell<Element> next = iter){
                if (i++ == len) {
                    head=next;
                    return;
                }
                _size--;
            }
        }
        else {
            variable Cell<Element>? iter = head;
            variable Integer i = 0;
            while(exists Cell<Element> cell = iter){
                if(i++ == fst){
                    while(exists Cell<Element> next = iter){
                        if (i++ == fst+len) {
                            cell.cdr=next;
                            return;
                        }
                        _size--;
                    }
                    cell.cdr = null;
                    return;
                }
                iter = cell.cdr;
            }
        }
    }
    
    first => head?.car;
    
    last => tail?.car;
    
    push(Element element) => insert(0, element);
    
    pop() => deleteFirst();
    
    top => first;
    
    offer(Element element) => add(element);
    
    accept() => deleteFirst();
    
    back => last;
    
    front => first;
    
}
