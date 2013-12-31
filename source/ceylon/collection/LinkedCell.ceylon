class LinkedCell<Element>(Element car, Cell<Element>? cdr, previous) 
        extends Cell<Element>(car, cdr) {
    shared variable LinkedCell<Element>? next = null;
    shared variable LinkedCell<Element>? previous;
}

class LinkedCellIterator<Element>(iter) 
        satisfies Iterator<Element> {
    variable LinkedCell<Element>? iter;
    
    shared actual Element|Finished next() {
        if(exists iter = iter){
            this.iter = iter.next;
            return iter.element;
        }
        return finished;
    }
}