"Create a backing array for storing linked lists of hash map
 entries"
Array<Cell<Key->Item>?> entryStore<Key,Item>(Integer size) 
        given Key satisfies Object 
        given Item satisfies Object
        => arrayOfSize<Cell<Key->Item>?>(size, null);

"Create a backing array for storing linked lists of hash set
 elements"
Array<Cell<Element>?> elementStore<Element>(Integer size) 
        => arrayOfSize<Cell<Element>?>(size, null);