class CellIterator<Element>(iter) 
        satisfies Iterator<Element> {
    variable Cell<Element>? iter;

    shared actual Element|Finished next() {
        if(exists iter = iter){
            this.iter = iter.cdr;
            return iter.car;
        }
        return finished;
    }
}