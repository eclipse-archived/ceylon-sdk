
Array<Cell<Key->Item>?> makeCellEntryArray<Key,Item>(Integer size) 
    given Key satisfies Object 
    given Item satisfies Object {

    return makeArray<Cell<Key->Item>?>(size, (Integer index) null);
}
Array<Cell<Element>?> makeCellElementArray<Element>(Integer size) {
    return makeArray<Cell<Element>?>(size, (Integer index) null);
}