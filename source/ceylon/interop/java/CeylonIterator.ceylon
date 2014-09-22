import java.util {
    JIterator=Iterator
}

"A Ceylon [[Iterator]] that adapts an instance of Java's 
 [[java.util::Iterator]]."
shared class CeylonIterator<T>(JIterator<out T> iterator) 
        satisfies Iterator<T> {

    shared actual T|Finished next() {
        if (iterator.hasNext()) {
            return iterator.next();
        } else {
            return finished;
        }
    }
    
}
