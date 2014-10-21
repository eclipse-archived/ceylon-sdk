import ceylon.collection {
    Cell
}

// FIXME: make this faster with a size check
class EntryStoreIterator<Key,Element>(Array<EntryCell<Key,Element>?> store) 
        satisfies Iterator<Key->Element> 
        given Key satisfies Object {
    
    variable Integer index = 0;
    variable value bucket = store[index];
    
    shared actual <Key->Element>|Finished next() {
        // do we need a new bucket?
        if (!bucket exists) {
            // find the next non-empty bucket
            while (++index < store.size) {
                bucket = store[index];
                if (bucket exists) {
                    break;
                }
            }
        }
        // do we have a bucket?
        if (exists bucket = bucket) {
            value car = bucket.entry;
            // advance to the next cell
            this.bucket = bucket.rest;
            return car;
        }
        return finished;
    }
}