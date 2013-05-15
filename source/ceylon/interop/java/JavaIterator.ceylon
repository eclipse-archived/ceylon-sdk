
import java.lang { UnsupOpEx=UnsupportedOperationException }
import java.util { JIterator=Iterator }

"Takes a Ceylon `Iterator` and turns it into a Java `Iterator`"
shared class JavaIterator<T>(Iterator<T> iter) satisfies JIterator<T> {
    variable Boolean first = true;
    variable T|Finished item = finished;
    
    shared actual Boolean hasNext() {
        if (first) {
            item = iter.next();
            first = false;
        }
        return !item is Finished;
    }
    
    shared actual T? next() {
        if (first) {
            item = iter.next();
            first = false;
        }
        T|Finished olditem = item;
        item = iter.next();
        if (!is Finished olditem) {
            return olditem;
        } else {
            return null;
        }
    }
    
    shared actual void remove() { throw UnsupOpEx("remove()"); }
    
}
