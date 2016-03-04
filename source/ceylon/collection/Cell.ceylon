"A link in a singly linked list with an attribute to cache hash codes."
class CachingCell<Element>(element, keyHash, rest) {
    "The element belonging to this link."
    shared variable Element element;
    "The hash code of the element (sets) or key (maps) for this cell."
    shared variable Integer keyHash;
    "The next link in the list."
    shared variable CachingCell<Element>? rest;
    // shallow clone
    shared CachingCell<Element> clone()
            => CachingCell<Element>(element, keyHash, rest?.clone());
}

class CachingCellIterator<Element>(iter) 
        satisfies Iterator<Element> {
    variable CachingCell<Element>? iter;
    
    shared actual Element|Finished next() {
        if (exists iter = iter) {
            this.iter = iter.rest;
            return iter.element;
        }
        return finished;
    }
}