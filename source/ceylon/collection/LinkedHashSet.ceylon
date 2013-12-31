"A [[MutableSet]] implemented as a hash set stored in an 
 [[Array]] of singly linked lists. Each element is assigned 
 an index of the array according to its hash code. The hash 
 code of an element is defined by [[Object.hash]]. In 
 addition, the elements of the set form a linked list, where 
 new elements are added to the end of the linked list. 
 Iteration of the `LinkedHashSet` follows this linked list, 
 from least recently added elements to most recently added
 elements.
 
 The size of the backing `Array` is called the _capacity_
 of the `HashSet`. The capacity of a new instance is 
 specified by the given [[initialCapacity]]. The capacity is 
 increased, and the elements _rehashed_, when the ratio of 
 [[size]] to capacity exceeds the given [[loadFactor]]. The 
 new capacity is the product of the current capacity and the 
 given [[growthFactor]]."
by ("Gavin King")
shared class LinkedHashSet<Element>
        (initialCapacity=16, loadFactor=0.75, growthFactor=2.0)
        extends HashSet<Element>
                (initialCapacity, loadFactor, growthFactor)
        given Element satisfies Object {
    
    "The initial capacity of the backing array."
    Integer initialCapacity;
    
    "The ratio between the number of elements and the 
     capacity which triggers a rebuild of the hash set."
    Float loadFactor;
    
    "The factor used to determine the new size of the
     backing array when a new backing array is allocated."
    Float growthFactor;
    
    variable LinkedCell<Element>? head = null;
    variable LinkedCell<Element>? tip = null;
    
    shared actual Cell<Element> createCell(Element car, Cell<Element>? cdr) {
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
    
    shared actual void deleteCell(Cell<Element> cell) {
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
    
    shared actual void deleteAllCells() {
        head = null;
        tip = null;
    }
    
    iterator() => LinkedCellIterator(head);
    
}

class LinkedCell<Element>(Element car, Cell<Element>? cdr, last) 
        extends Cell<Element>(car, cdr) {
    shared variable LinkedCell<Element>? next = null;
    shared variable LinkedCell<Element>? last;
}

class LinkedCellIterator<Element>(iter) 
        satisfies Iterator<Element> {
    variable LinkedCell<Element>? iter;
    
    shared actual Element|Finished next() {
        if(exists iter = iter){
            this.iter = iter.next;
            return iter.car;
        }
        return finished;
    }
}