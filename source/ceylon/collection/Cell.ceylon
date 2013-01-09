class Cell<T>(T _car, Cell<T>? _cdr) satisfies Cloneable<Cell<T>> {
    shared variable T car = _car;
    shared variable Cell<T>? cdr = _cdr;
    // shallow clone
    shared actual Cell<T> clone {
        return Cell<T>(car, cdr?.clone);
    }
}