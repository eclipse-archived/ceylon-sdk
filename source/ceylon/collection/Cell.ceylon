"A link in a linked list."
shared class Cell<Element>(car, cdr) 
        satisfies Cloneable<Cell<Element>> {
    "The element belonging to this link."
    shared variable Element car;
    "The next link in the list."
    shared variable Cell<Element>? cdr;
    // shallow clone
    shared actual Cell<Element> clone
            => Cell<Element>(car, cdr?.clone);
}