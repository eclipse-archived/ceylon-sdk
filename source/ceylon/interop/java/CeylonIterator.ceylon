import java.util {
    JIterator=Iterator
}

"A Ceylon [[Iterator]] that adapts an instance of Java's 
 [[java.util::Iterator]]."
shared class CeylonIterator<T>(JIterator<out T> iterator) 
        satisfies Iterator<T> {

    shared actual T|Finished next() {
        if (iterator.hasNext()) {
            if (exists next = iterator.next()) {
                return next;
            }
            else {
                "Java iterator returned null"
                assert (is T null);
                return null;
            }
        }
        else {
            return finished;
        }
    }
    
}
