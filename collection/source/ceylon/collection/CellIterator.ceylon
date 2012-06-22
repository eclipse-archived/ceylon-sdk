class CellIterator<T>(Cell<T>? _iter) satisfies Iterator<T> {
    variable Cell<T>? iter := _iter;

    shared actual T|Finished next() {
        if(exists Cell<T> iter = iter){
            this.iter := iter.cdr;
            return iter.car;
        }
        return exhausted;
    }
}