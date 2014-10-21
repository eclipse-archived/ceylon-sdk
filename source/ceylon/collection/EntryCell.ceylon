"A link in a singly linked list."
class EntryCell<Key,Element>(key, element, rest) 
        given Key satisfies Object {
    
    "The key of the element belonging to this link."
    shared variable Key key;
    "The element belonging to this link."
    shared variable Element element;
    "The next link in the list."
    shared variable EntryCell<Key,Element>? rest;
    
    shared Key->Element entry => key-> element;
    
    // shallow clone
    shared EntryCell<Key,Element> clone()
            => EntryCell<Key,Element>(key, element, rest?.clone());
}

class EntryCellIterator<Key,Element>(iter) 
        satisfies Iterator<Key->Element> 
        given Key satisfies Object {
    
    variable EntryCell<Key,Element>? iter;
    
    shared actual <Key->Element>|Finished next() {
        if (exists iter = iter) {
            this.iter = iter.rest;
            return iter.key->iter.element;
        }
        return finished;
    }
}