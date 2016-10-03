"Cell with two traversal modes:
 
 -[[rest]] for storage
 -[[next]]/[[previous]] for stable iteration
 
 This allows us to use the same cell object in two different 
 lists which have the same elements but different iteration 
 order."
serializable class LinkedCell<Element>(Element element, Integer keyHash, 
    CachingCell<Element>? rest, previous) 
        extends CachingCell<Element>(element, keyHash, rest) {
    shared variable LinkedCell<Element>? next = null;
    shared variable LinkedCell<Element>? previous;
}

class LinkedCellIterator<Element>(iter) 
        satisfies Iterator<Element> {
    variable LinkedCell<Element>? iter;
    
    shared actual Element|Finished next() {
        if (exists iter = iter) {
            this.iter = iter.next;
            return iter.element;
        }
        return finished;
    }
}