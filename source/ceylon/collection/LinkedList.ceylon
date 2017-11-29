/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
"A [[MutableList]] implemented as a singly linked list.
 Also:

 - a [[Stack]], where the top of the stack is the _first_
   element of the list, and
 - a [[Queue]], where the front of the queue is the first
   element of the list and the back of the queue is the
   last element of the list."
by("Stéphane Épardaud")
shared serializable class LinkedList<Element>
        satisfies MutableList<Element> &
                  Stack<Element> & Queue<Element> {

    variable Cell<Element>? head = null;
    variable Cell<Element>? tail = null;
    variable Integer length = 0;
    
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
    
    "Create a new `LinkedList` with the given initial 
     [[elements]]."
    shared new (
        "The initial elements of the list."
        {Element*} elements = {}) {
        for (element in elements) {
            addToTail(element);
        }
    }
    
    "Create a new `LinkedList` with the same initial 
     elements as the given [[linkedList]]."
    shared new copy(
        "The `LinkedList` to copy."
        LinkedList<Element> linkedList) {
        variable value iter = linkedList.head;
        while (exists cell = iter) {
            addToTail(cell.element);
            iter = cell.rest;
        }
    }
    
    // End of initialiser section

    // Write

    shared actual 
    void set(Integer index, Element element) {
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

    shared actual 
    void insert(Integer index, Element element) {
        "index may not be negative or greater than the
         length of the list"
        assert (0<=index<=length);
        if (index == length) {
            add(element);
        }
        else {
            //no need to update the tail in this branch
            if (index == 0) {
                head = Cell(element, head);
                length++;
            }
            else {
                variable value iter = head;
                variable Integer i = 0;
                while (exists cell = iter) {
                    value rest = cell.rest;
                    if (++i == index) {
                        cell.rest = Cell(element, rest);
                        length++;
                        return;
                    }
                    iter = rest;
                }
                assert (false);
            }
        }
    }
    
    shared actual 
    void insertAll(Integer index, 
            {Element*} elements) {
        "index may not be negative or greater than the
         length of the list"
        assert (0<=index<=length);
        if (index == length) {
            addAll(elements);
        }
        else {
            value reversed = Array(elements);
            reversed.reverseInPlace();
            //no need to update the tail in this branch
            if (index == 0) {
                head = reversed.fold(head,
                    (rest,element) => Cell(element, rest));
                length+=reversed.size;
            }
            else {
                variable value iter = head;
                variable Integer i = 0;
                while (exists cell = iter) {
                    value rest = cell.rest;
                    if (++i == index) {
                        cell.rest = reversed.fold(rest,
                            (rest,element) => Cell(element, rest));
                        length+=reversed.size;
                        return;
                    }
                    iter = rest;
                }
                assert (false);
            }
        }
    }

    shared actual 
    void add(Element element) => addToTail(element);

    shared actual 
    void addAll({Element*} elements) {
        for (element in elements) {
            add(element);
        }
    }

    shared actual 
    Element? delete(Integer index) {
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

    shared actual 
    Integer removeAll({<Element&Object>*} elements) {
        Category<> set = HashSet { *elements };
        variable value result = 0;
        while (exists cell = head,
            exists elem = cell.element,
            elem in set) {
            if (exists rest = cell.rest) {
                head = rest;
            }
            else {
                head = tail = null;
            }
            length--;
            result++;
        }
        variable value iter = head;
        while (exists cell = iter) {
            value rest = cell.rest;
            if (exists rest,
                exists elem = rest.element,
                elem in set) {
                if (exists more = rest.rest) {
                    cell.rest = more;
                }
                else {
                    cell.rest = tail = null;
                }
                length--;
                result++;
            }
            else {
                iter = rest;
            }
        }
        return result;
    }

    /*shared actual 
    Integer remove(Element&Object element) {
        variable value result = 0;
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
            result++;
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
                result++;
            }
            else {
                iter = rest;
            }
        }
        return result;
    }
    
    shared actual 
    Boolean removeFirst(Element&Object element) {
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

    shared actual 
    Boolean removeLast(Element&Object element) {
        //...
    }*/

    shared actual Element? findAndRemoveFirst(
        Boolean selecting(Element&Object element)) {
        if (exists cell = head,
            exists elem = cell.element,
            selecting(elem)) {
            if (exists rest = cell.rest) {
                head = rest;
            }
            else {
                head = tail = null;
            }
            length--;
            return elem;
        }
        variable value iter = head;
        while (exists cell = iter) {
            value rest = cell.rest;
            if (exists rest,
                exists elem = rest.element,
                selecting(elem)) {
                if (exists more = rest.rest) {
                    cell.rest = more;
                }
                else {
                    cell.rest = tail = null;
                }
                length--;
                return elem;
            }
            iter = rest;
        }
        return null;
    }
    
    shared actual Element? findAndRemoveLast(
        Boolean selecting(Element&Object element)) {
        if (exists index = lastIndexWhere(selecting)) {
            return delete(index);
        }
        else {
            return null;
        }
    }
    
    shared actual Integer removeWhere(
        Boolean selecting(Element&Object element)) {
        variable value result = 0;
        while (exists cell = head,
            exists elem = cell.element,
            selecting(elem)) {
            if (exists rest = cell.rest) {
                head = rest;
            }
            else {
                head = tail = null;
            }
            length--;
            result++;
        }
        variable value iter = head;
        while (exists cell = iter) {
            value rest = cell.rest;
            if (exists rest,
                exists elem = rest.element,
                selecting(elem)) {
                if (exists more = rest.rest) {
                    cell.rest = more;
                }
                else {
                    cell.rest = tail = null;
                }
                length--;
                result++;
            }
            else {
                iter = rest;
            }
        }
        return result;
    }
    
    shared actual 
    Integer prune() {
        variable value originalLength = length;
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
        return originalLength - length;
    }

    /*shared actual 
    void replace(Element&Object element, 
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

    shared actual 
    Boolean replaceFirst(Element&Object element, 
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

    shared actual 
    Boolean replaceLast(Element&Object element, 
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
    }*/
    
    shared actual Element? findAndReplaceFirst(
        Boolean selecting(Element&Object element), 
        Element replacement) {
        variable value iter = head;
        while (exists cell = iter) {
            if (exists elem = cell.element,
                selecting(elem)) {
                cell.element = replacement;
                return elem;
            }
            iter = cell.rest;
        }
        return null;
    }
    
    shared actual Element? findAndReplaceLast(
        Boolean selecting(Element&Object element), 
        Element replacement) {
        variable Cell<Element>? last = null;
        variable value iter = head;
        while (exists cell = iter) {
            if (exists elem = cell.element,
                selecting(elem)) {
                last = cell;
            }
            iter = cell.rest;
        }
        if (exists cell = last) {
            value result = cell.element;
            cell.element = replacement;
            return result;
        }
        else {
            return null;
        }
    }
    
    shared actual Integer replaceWhere(
        Boolean selecting(Element&Object element), 
        Element replacement) {
        variable Integer count = 0;
        variable value iter = head;
        while (exists cell = iter) {
            if (exists elem = cell.element,
                selecting(elem)) {
                cell.element = replacement;
                count++;
            }
            iter = cell.rest;
        }
        return count;
    }

    shared actual 
    void infill(Element replacement) {
        variable value iter = head;
        while (exists cell = iter) {
            if (!cell.element exists) {
                cell.element = replacement;
            }
            iter = cell.rest;
        }
    }

    shared actual 
    void clear() {
        length = 0;
        head = tail = null;
    }

    // Read

    shared actual 
    Element? getFromFirst(Integer index) {
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

    shared actual 
    List<Element> spanFrom(Integer from) {
        value ret = LinkedList<Element>();
        variable value iter = head;
        variable Integer i = 0;
        while (exists cell = iter) {
            if (i >= from) {
                ret.add(cell.element);
            }
            i++;
            iter = cell.rest;
        }
        return ret;
    }

    shared actual 
    List<Element> spanTo(Integer to) {
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

    shared actual 
    List<Element> span(Integer from, Integer to) {
        let ([start, len, reversed]
                = spanToMeasure(from, to, length));
        value result = LinkedList(skip(start).take(len));
        return reversed then result.reversed else result;
    }
    
    shared actual 
    void deleteSpan(Integer from, Integer to)  {
        let ([start, len, _]
                = spanToMeasure(from, to, length));
        if (start < length && len > 0) {
            value keepHead = start > 0;
            value lastPreMeasureCell 
                    = advanceBy(start-1, head);
            value skipCells 
                    = len + (keepHead then 1 else 0);
            value firstPostMeasureCell 
                    = advanceBy(skipCells, 
                            lastPreMeasureCell else head);
            if (!keepHead) {
                head = lastPreMeasureCell 
                            else firstPostMeasureCell;
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

    Cell<Element>? advanceBy
            (Integer cells, Cell<Element>? start) {
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

    shared actual 
    Boolean contains(Object element) {
        variable value iter = head;
        while (exists cell = iter) {
            if (exists elem = cell.element) {
                if (elem == element) {
                    return true;
                }
            }
            iter = cell.rest;
        }
        return false;
    }

    size => length;

    shared actual 
    Integer count(Boolean selecting(Element element)) {
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

    shared actual 
    LinkedList<Element> clone() => copy(this);
    
    shared actual 
    void each(void step(Element element)) {
        variable value iter = head;
        while (exists cell = iter) {
            step(cell.element);
            iter = cell.rest;
        }
    }
    
    shared actual 
    Element? find(Boolean selecting(Element&Object elem)) {
        variable value iter = head;
        while (exists cell = iter) {
            value element = cell.element;
            if (exists element, 
                selecting(element)) {
                return element;
            }
            iter = cell.rest;
        }
        return null;
    }

    shared actual 
    Element? findLast
            (Boolean selecting(Element&Object elem)) {
        variable Element? result = null;
        variable value iter = head;
        while (exists cell = iter) {
            value element = cell.element;
            if (exists element, 
                selecting(element)) {
                result = element;
            }
            iter = cell.rest;
        }
        return result;
    }
    
    shared actual 
    Boolean every(Boolean selecting(Element element)) {
        variable value iter = head;
        while (exists cell = iter) {
            if (!selecting(cell.element)) {
                return false;
            }
            iter = cell.rest;
        }
        return true;
    }
    
    shared actual 
    Boolean any(Boolean selecting(Element element)) {
        variable value iter = head;
        while (exists cell = iter) {
            if (selecting(cell.element)) {
                return true;
            }
            iter = cell.rest;
        }
        return false;
    }
    
    shared actual 
    Result|Element|Null reduce<Result>
            (Result accumulating(Result|Element partial, 
                                 Element element)) {
        if (exists first = head) {
            variable Result|Element partial = first.element;
            variable value iter = first.rest;
            while (exists cell = iter) {
                partial = accumulating(partial, cell.element);
                iter = cell.rest;
            }
            return partial;
        }
        else {
            return null;
        }
    }
    
    /*shared actual String string {
        StringBuilder b = StringBuilder();
        b.append("[");
        variable Cell<Element>? iter = head;
        while(exists Cell<Element> cell = iter){
            if (is Object car = cell.car){
                b.append(car.string);
            }
            else {
                b.append("null");
            }
            iter = cell.cdr;
            if (iter exists){
                b.append(", ");
            }
        }
        b.append("]");
        return b.string;
    }*/

    shared actual 
    Integer hash {
        variable value hash = 1;
        variable value iter = head;
        while (exists cell = iter) {
            hash *= 31;
            if (exists car = cell.element) {
                hash += car.hash;
            }
            iter = cell.rest;
        }
        return hash;
    }

    shared actual 
    Boolean equals(Object that) {
        if (is LinkedList<Anything> that) {
            if (this===that) {
                return true;
            }
            if (this.length!=that.length) {
                return false;
            }
            variable value thisIter = this.head;
            variable value thatIter = that.head;
            while (exists thisCell = thisIter,
                   exists thatCell = thatIter) {
                value thisElement = thisCell.element;
                value thatElement = thatCell.element;
                if (exists thisElement) {
                    if (!exists thatElement) {
                        return false;
                    }
                    else if (thisElement!=thatElement) {
                        return false;
                    }
                }
                else if (thatElement exists) {
                    return false;
                }
                thisIter = thisCell.rest;
                thatIter = thatCell.rest;
            }
            return true;
        }
        else {
            return (super of List<>).equals(that);
        }
    }
    
    shared actual 
    void truncate(Integer size) {
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
     The default List implementations of firstIndexWhere, lastIndexWhere
     and collect use getFromFirst(index) instead of iterating over the list
     because for tuples and array sequences that's slightly faster.
     It is of course disastrous for a linked list, where getFromFirst(index)
     runs in O(index) time, which means that the default firstIndexWhere(),
     lastIndexWhere() and collect() run in O(size^2) time, so we refine it here.
     */
    
    shared actual 
    Integer? firstIndexWhere(
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
    
    shared actual 
    Integer? lastIndexWhere(
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
    
    shared actual 
    [Result+]|[] collect<Result>(
            "The transformation applied to the elements."
            Result collecting(Element element))
            => [for (element in this) collecting(element)]
                    of [Result+]|[];

    first => head?.element;

    last => tail?.element;

    push(Element element) => insert(0, element);

    pop() => deleteFirst();

    top => first;

    offer(Element element) => add(element);

    accept() => deleteFirst();

    back => last;

    front => first;
    
    sequence() => Array(this).sequence();
    
}
