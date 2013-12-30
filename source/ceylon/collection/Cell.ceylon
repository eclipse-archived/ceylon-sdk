"A link in a linked list."
class Cell<T>(car, cdr) 
        satisfies Cloneable<Cell<T>> {
    "The element belonging to this link."
    shared variable T car;
    "The next link in the list."
    shared variable Cell<T>? cdr;
    // shallow clone
    shared actual Cell<T> clone
            => Cell<T>(car, cdr?.clone);
}