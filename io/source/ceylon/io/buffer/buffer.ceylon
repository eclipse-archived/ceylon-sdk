shared abstract class Buffer<T>() satisfies Iterable<T> {
    shared formal variable Integer position;
    shared formal Integer capacity;
    shared formal variable Integer limit;

    shared formal void resize(Integer newSize, Boolean growLimit = false);

    shared default Boolean writable = true;
    
    shared Boolean hasAvailable {
        return available > 0;
    }
    
    shared Integer available {
        return limit - position;
    }
    
    shared formal T get();
    shared formal void put(T element);
    shared formal void clear();
    shared formal void flip();
    
    shared actual Iterator<T> iterator {
        object it satisfies Iterator<T> {
            shared actual T|Finished next() {
                if(hasAvailable){
                    return get();
                }
                return exhausted;
            }
        }
        return it;
    } 
}
