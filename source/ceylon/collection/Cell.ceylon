"A link in a singly linked list."
class Cell<Element>(element, rest) {
    "The element belonging to this link."
    shared variable Element element;
    "The next link in the list."
    shared variable Cell<Element>? rest;
    // shallow clone
    shared Cell<Element> clone()
            => Cell<Element>(element, rest?.clone());
}

class CellIterator<Element>(iter) 
        satisfies Iterator<Element> {
    variable Cell<Element>? iter;
    
    shared actual Element|Finished next() {
        if (exists iter = iter) {
            this.iter = iter.rest;
            return iter.element;
        }
        return finished;
    }
}