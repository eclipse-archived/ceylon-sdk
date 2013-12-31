"A link in a linked list."
class Cell<Element>(car, cdr) 
        satisfies Cloneable<Cell<Element>> {
    "The element belonging to this link."
    shared variable Element car;
    "The next link in the list."
    shared variable Cell<Element>? cdr;
    // shallow clone
    shared actual Cell<Element> clone
            => Cell<Element>(car, cdr?.clone);
}

class CellIterator<Element>(iter) 
        satisfies Iterator<Element> {
    variable Cell<Element>? iter;
    
    shared actual Element|Finished next() {
        if(exists iter = iter){
            this.iter = iter.cdr;
            return iter.car;
        }
        return finished;
    }
}