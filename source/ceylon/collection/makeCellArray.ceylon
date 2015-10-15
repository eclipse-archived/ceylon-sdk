"Create a backing array for storing linked lists of hash map
 entries"
Array<Cell<Key->Item>?> entryStore<Key,Item>(Integer size) 
        given Key satisfies Object
        => Array<Cell<Key->Item>?>.ofSize(size, null);

"Create a backing array for storing linked lists of hash set
 elements"
Array<Cell<Element>?> elementStore<Element>(Integer size) 
        => Array<Cell<Element>?>.ofSize(size, null);