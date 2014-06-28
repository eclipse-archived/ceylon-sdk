"A [[MutableList]] implemented as a singly linked list.
 Also:

 - a [[Stack]], where the top of the stack is the _first_
   element of the list, and
 - a [[Queue]], where the front of the queue is the first
   element of the list and the back of the queue is the
   last element of the list."
by("Stéphane Épardaud")
shared class LinkedList<Element>(elements = {})
        satisfies MutableList<Element> &
                  Stack<Element> & Queue<Element> {

    "The initial elements of the list."
    {Element*} elements;

    variable Cell<Element>? head = null;
    variable Cell<Element>? tail = null;
    variable Integer length = 0;

    // initialiser section

    void addToTail(Element element) {
        value newTail = Cell(element, null);
        if (exists tail = tail) {
            tail.rest = newTail;
            this.tail = newTail;
        }
        else {
            // no tail means empty list
            tail = head = newTail;
        }
        length++;
    }

    // add initial values
    for (element in elements) {
        addToTail(element);
    }

    // End of initialiser section

    // Write

    shared actual void set(Integer index, Element element) {
        "index may not be negative or greater than the
         last index in the list"
        assert (0<=index<length);
        variable value iter = head;
        variable Integer i = 0;
        while (exists cell = iter) {
            if (i++ == index) {
                cell.element = element;
                return;
            }
            iter = cell.rest;
        }
    }

    shared actual void insert(Integer index, Element element) {
        "index may not be negative or greater than the
         length of the list"
        assert (0<=index<=length);
        if (index == length){
            add(element);
        }
        else {
            if (index == 0){
                head = Cell(element, head);
                // we only have to update the tail if
                // _size == 0 but that's not possible
                // since it has already been checked
                length++;
            }
            else {
                variable value iter = head;
                variable Integer i = 0;
                while (exists cell = iter) {
                    value rest = cell.rest;
                    if (++i == index) {
                        cell.rest = Cell(element, rest);
                        // no need to update the tail since
                        // we never modify the last element,
                        // we would have taken the other
                        // branch above instead
                        length++;
                        return;
                    }
                    iter = rest;
                }
                assert (false);
            }
        }
    }

    shared actual void add(Element element) {
        addToTail(element);
    }

    shared actual void addAll({Element*} elements) {
        for (element in elements) {
            add(element);
        }
    }

    shared actual Element? delete(Integer index){
        if (index == 0) {
            if (exists cell = head) {
                if (exists rest = cell.rest) {
                    head = rest;
                }
                else {
                    head = tail = null;
                }
                length--;
                return cell.element;
            }
            else {
                return null;
            }
        }
        else if (0 < index < length) {
            variable value iter = head;
            variable Integer i = 0;
            while (exists cell = iter) {
                value rest = cell.rest;
                if (++i == index) {
                    if (exists more = rest?.rest) {
                        cell.rest = more;
                    }
                    else {
                        tail = cell;
                        cell.rest = null;
                    }
                    length--;
                    return rest?.element;
                }
                else {
                    iter = rest;
                }
            }
            assert (false);
        }
        else {
            return null;
        }
    }

    shared actual void remove(Element&Object element) {
        while (exists cell = head,
            exists elem = cell.element,
            elem==element) {
            if (exists rest = cell.rest) {
                head = rest;
            }
            else {
                head = tail = null;
            }
            length--;
        }
        variable value iter = head;
        while (exists cell = iter) {
            value rest = cell.rest;
            if (exists rest,
                exists elem = rest.element,
                elem==element) {
                if (exists more = rest.rest) {
                    cell.rest = more;
                }
                else {
                    cell.rest = tail = null;
                }
                length--;
            }
            else {
                iter = rest;
            }
        }
    }

    shared actual void removeAll({<Element&Object>*} elements) {
        while (exists cell = head,
            exists elem = cell.element,
            elem in elements) {
            if (exists rest = cell.rest) {
                head = rest;
            }
            else {
                head = tail = null;
            }
            length--;
        }
        variable value iter = head;
        while (exists cell = iter) {
            value rest = cell.rest;
            if (exists rest,
                exists elem = rest.element,
                elem in elements) {
                if (exists more = rest.rest) {
                    cell.rest = more;
                }
                else {
                    cell.rest = tail = null;
                }
                length--;
            }
            else {
                iter = rest;
            }
        }
    }

    shared actual Boolean removeFirst(Element&Object element) {
        if (exists cell = head,
            exists elem = cell.element,
            elem==element) {
            if (exists rest = cell.rest) {
                head = rest;
            }
            else {
                head = tail = null;
            }
            length--;
            return true;
        }
        variable value iter = head;
        while (exists cell = iter) {
            value rest = cell.rest;
            if (exists rest,
                exists elem = rest.element,
                elem==element) {
                if (exists more = rest.rest) {
                    cell.rest = more;
                }
                else {
                    cell.rest = tail = null;
                }
                length--;
                return true;
            }
            iter = rest;
        }
        return false;
    }

    shared actual Boolean removeLast(Element&Object element) {
        variable Cell<Element>? current = null;
        while (exists cell = head,
               exists elem = cell.element,
               elem==element) {
            if (exists rest = cell.rest) {
                current = cell;
            }
            else {
                head = tail = null;
                length--;
                return true;
            }
        }
        variable value iter = head;
        while (exists cell = iter) {
            value rest = cell.rest;
            if (exists rest,
                exists elem = rest.element,
                elem==element) {
                if (exists more = rest.rest) {
                    current = cell;
                }
                else {
                    cell.rest = tail = null;
                    length--;
                    return true;
                }
            }
            else {
                iter = rest;
            }
        }
        if (exists last=current) {
            assert (exists cell=head);
            if (last===cell) {
                head = last.rest;
            }
            else {
                assert (exists more = last.rest?.rest);
                cell.rest = more;
            }
            length--;
            return true;
        }
        else {
            return false;
        }
    }

    shared actual void prune() {
        while (exists cell = head,
            !cell.element exists) {
            if (exists rest = cell.rest) {
                head = rest;
            }
            else {
                head = tail = null;
            }
            length--;
        }
        variable value iter = head;
        while (exists cell = iter) {
            value rest = cell.rest;
            if (exists rest,
                !rest.element exists) {
                if (exists more = rest.rest) {
                    cell.rest = more;
                }
                else {
                    cell.rest = tail = null;
                }
                length--;
            }
            else {
                iter = rest;
            }
        }
    }

    shared actual void replace(Element&Object element,
            Element replacement) {
        variable value iter = head;
        while (exists cell = iter) {
            if (exists elem = cell.element,
                elem==element) {
                cell.element = replacement;
            }
            iter = cell.rest;
        }
    }

    shared actual Boolean replaceFirst(Element&Object element,
            Element replacement) {
        variable value iter = head;
        while (exists cell = iter) {
            if (exists elem = cell.element,
                elem==element) {
                cell.element = replacement;
                return true;
            }
            iter = cell.rest;
        }
        return false;
    }

    shared actual Boolean replaceLast(Element&Object element,
            Element replacement) {
        variable Cell<Element>? last = null;
        variable value iter = head;
        while (exists cell = iter) {
            if (exists elem = cell.element,
            elem==element) {
                last = cell;
            }
            iter = cell.rest;
        }
        if (exists cell=last) {
            cell.element=replacement;
            return true;
        }
        else {
            return false;
        }
    }

    shared actual void infill(Element replacement) {
        variable value iter = head;
        while (exists cell = iter) {
            if (!cell.element exists) {
                cell.element = replacement;
            }
            iter = cell.rest;
        }
    }

    shared actual void clear() {
        length = 0;
        head = tail = null;
    }

    // Read

    shared actual Element? getFromFirst(Integer index) {
        variable value iter = head;
        variable Integer i = 0;
        while (exists cell = iter) {
            if (i++ == index) {
                return cell.element;
            }
            iter = cell.rest;
        }
        return null;
    }

    shared actual List<Element> spanFrom(Integer from) {
        value ret = LinkedList<Element>();
        variable value iter = head;
        variable Integer i = 0;
        while (exists cell = iter) {
            if(i >= from) {
                ret.add(cell.element);
            }
            i++;
            iter = cell.rest;
        }
        return ret;
    }

    shared actual List<Element> spanTo(Integer to) {
        value ret = LinkedList<Element>();
        variable value iter = head;
        variable Integer i = 0;
        while (exists cell = iter) {
            if (i > to) {
                break;
            }
            ret.add(cell.element);
            i++;
            iter = cell.rest;
        }
        return ret;
    }

    shared actual List<Element> span(Integer from, Integer to) {
        value measure = spanToMeasure(from, to, length);
        value start = measure[0];
        value len = measure[1];
        value reversed = measure[2];
        value result = LinkedList(skip(start).take(len));
        return reversed then result.reversed else result;
    }
    
    shared actual void deleteSpan(Integer from, Integer to)  {
        value measure = spanToMeasure(from, to, length);
        value start = measure[0];
        value len = measure[1];
        if (start < length && len > 0) {
            value keepHead = start > 0;
            value lastPreMeasureCell = advanceBy(start-1, head);
            value skipCells = len + (keepHead then 1 else 0);
            value firstPostMeasureCell 
                    = advanceBy(skipCells, lastPreMeasureCell else head);
            if (!keepHead) {
                head = lastPreMeasureCell else firstPostMeasureCell;
            }
            if (exists preCell = lastPreMeasureCell) {
                preCell.rest = firstPostMeasureCell;
            }
            if (len >= length) {
                tail = null;
            }
            length -= len;
        }
    }

    Cell<Element>? advanceBy(Integer cells, Cell<Element>? start) {
        if (cells < 0) {
            return null;
        }
        variable Cell<Element>? result = start;
        if (exists start, cells > 0) {
            for (i in 1..cells) {
                result = result?.rest;
            }
        }
        return result;
    }
    
    measure(Integer from, Integer length) 
            => span(*measureToSpan(from, length));
    
    deleteMeasure(Integer from, Integer length) 
            => deleteSpan(*measureToSpan(from, length));
    
    defines(Integer index)
            => index >= 0 && index < length;

    shared actual Boolean contains(Object element) {
        variable value iter = head;
        while (exists cell = iter) {
            if (exists elem = cell.element) {
                if(elem == element) {
                    return true;
                }
            }
            iter = cell.rest;
        }
        return false;
    }

    size => length;

    shared actual Integer count(Boolean selecting(Element element)) {
        variable value iter = head;
        variable Integer count = 0;
        while (exists cell = iter) {
            if (selecting(cell.element)) {
                count++;
            }
            iter = cell.rest;
        }
        return count;
    }

    lastIndex => !empty then length - 1;

    iterator() => CellIterator(head);

    shared actual MutableList<Element> clone() {
        value ret = LinkedList<Element>();
        ret.head = head;
        ret.tail = tail;
        ret.length = size;
        return ret;
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
        variable Integer hash = 17;
        variable value iter = head;
        while (exists cell = iter) {
            if (exists car = cell.element) {
                hash = hash * 31 + car.hash;
            }
            else {
                hash = hash * 31;
            }
            iter = cell.rest;
        }
        return hash;
    }

    shared actual Boolean equals(Object that) {
        if (is List<Anything> that,
            length == that.size) {
            variable value iter = head;
            variable value iter2 = that.iterator();
            while (exists cell = iter) {
                if (!is Finished thatElement = iter2.next()) {
                    value thisElement=cell.element;
                    if (exists thatElement) {
                        if (exists thisElement,
                            thisElement==thatElement) {
                            iter = cell.rest;
                        }
                        else {
                            return false;
                        }
                    }
                    else {
                        if (exists thisElement) {
                            return false;
                        }
                        else {
                            iter = cell.rest;
                        }
                    }

                }
                else {
                    return false;
                }
            }
            return true;
        }
        return false;
    }
    
    shared actual void truncate(Integer size) {
        assert (size>=0);
        if (size==0) {
            head=tail=null;
            length=0;
        }
        else {
            variable value i=0;
            variable value iter = head;
            while (++i<size, exists cell=iter) {
                iter = cell.rest;
            }
            if (exists cell=iter) {
                cell.rest=null;
                tail=cell;
                length=size;
            }
        }
    }
    
    /*
     The default List implementation of firstIndexWhere + lastIndexWhere
     uses getFromFirst(index) instead of iterating over the list
     because for tuples and array sequences that's slightly faster.
     It is of course desastrous for a linked list, where getFromFirst(index)
     runs in O(index) time, which means that the default firstIndexWhere()
     and lastIndexWhere() run in O(size^2) time, so we refine it here.
     */
    
    shared actual Integer? firstIndexWhere(
            "The predicate function the indexed elements 
             must satisfy"
            Boolean selecting(Element&Object element)) {
        variable value index = 0;
        for (element in this) {
            if (exists element,
                selecting(element)) {
                return index;
            }
            index++;
        }
        return null;
    }
    
    shared actual Integer? lastIndexWhere(
            "The predicate function the indexed elements 
             must satisfy."
            Boolean selecting(Element&Object element)) {
        variable value index = 0;
        variable Integer? result = null;
        for (element in this) {
            if (exists element,
                selecting(element)) {
                result = index;
            }
            index++;
        }
        return result;
    }

    first => head?.element;

    last => tail?.element;

    push(Element element) => insert(0, element);

    pop() => deleteFirst();

    top => first;

    offer(Element element) => add(element);

    accept() => deleteFirst();

    back => last;

    front => first;
    
    shared actual Element[] sequence()
        => Array(this).sequence();
}
