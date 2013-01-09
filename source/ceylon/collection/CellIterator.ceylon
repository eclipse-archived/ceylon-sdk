class CellIterator<T>(iter) satisfies Iterator<T> {
    variable Cell<T>? iter;

    shared actual T|Finished next() {
        if(exists Cell<T> iter = iter){
            this.iter = iter.cdr;
            return iter.car;
        }
        return finished;
    }
}