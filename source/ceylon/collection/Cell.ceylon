"A link in a singly linked list."
class Cell<Element>(element, keyHash, rest) {
    "The element belonging to this link."
    shared variable Element element;
    "The hash code of the element (sets) or key (maps) for this cell."
    shared variable Integer keyHash;
    "The next link in the list."
    shared variable Cell<Element>? rest;
    // shallow clone
    shared Cell<Element> clone()
            => Cell<Element>(element, keyHash, rest?.clone());
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