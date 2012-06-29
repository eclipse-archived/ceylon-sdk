
Array<Cell<Key->Item>?> makeCellEntryArray<Key,Item>(Integer size) 
    given Key satisfies Object 
    given Item satisfies Object {

    return arrayOfSize<Cell<Key->Item>?>(size, null);
}
Array<Cell<Element>?> makeCellElementArray<Element>(Integer size) {
    return arrayOfSize<Cell<Element>?>(size, null);
}