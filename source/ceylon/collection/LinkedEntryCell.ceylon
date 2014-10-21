"Cell with two traversal modes:
 
 -[[rest]] for storage
 -[[next]]/[[previous]] for stable iteration
 
 This allows us to use the same cell object in two different lists which
 have the same elements but different iteration order."
class LinkedEntryCell<Key,Element>(key, element, rest, previous) 
        extends EntryCell<Key,Element>(key, element, rest) 
        given Key satisfies Object {
    
    EntryCell<Key,Element>? rest;
    Element element;
    Key key;
    
    shared variable LinkedEntryCell<Key,Element>? next = null;
    shared variable LinkedEntryCell<Key,Element>? previous;
}

class LinkedEntryCellIterator<Key,Element>(iter) 
        satisfies Iterator<Key->Element> 
        given Key satisfies Object {
    
    variable LinkedEntryCell<Key,Element>? iter;
    
    shared actual <Key->Element>|Finished next() {
        if (exists iter = iter) {
            this.iter = iter.next;
            return iter.entry;
        }
        return finished;
    }
}