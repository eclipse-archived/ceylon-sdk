import java.lang {
    UnsupOpEx=UnsupportedOperationException,
    ObjectArray
}
import java.util {
    JIterator=Iterator,
    JCollection=Collection
}

"Takes a Ceylon `Iterator` and turns it into a Java `Iterator`"
shared class JavaIterator<T>(Iterator<T> iterator)
        satisfies JIterator<T> {
    
    variable Boolean first = true;
    variable T|Finished item = finished;
    
    shared actual Boolean hasNext() {
        if (first) {
            item = iterator.next();
            first = false;
        }
        return !item is Finished;
    }
    
    shared actual T? next() {
        if (first) {
            item = iterator.next();
            first = false;
        }
        T|Finished olditem = item;
        item = iterator.next();
        if (!is Finished olditem) {
            return olditem;
        } else {
            return null;
        }
    }
    
    shared actual void remove() { 
        throw UnsupOpEx("remove()"); 
    }
    
}


