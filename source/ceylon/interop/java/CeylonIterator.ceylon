import java.util {
    JIterator=Iterator
}

"Adapts an instance of Java's `Iterator` to Ceylon's `Iterator`."
shared class CeylonIterator<T>(JIterator<T> iterator) 
        satisfies Iterator<T> {

    shared actual T|Finished next() {
        if (iterator.hasNext()) {
            return iterator.next();
        } else {
            return finished;
        }
    }
    
}
