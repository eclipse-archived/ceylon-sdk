
import java.util { JIterator=Iterator }

"Takes a Java `Iterator` and turns it into a Ceylon `Iterator`"
shared class CeylonIterator<T>(JIterator<T> jiter) satisfies Iterator<T> {

    shared actual T|Finished next() {
        if (jiter.hasNext()) {
            return jiter.next();
        } else {
            return finished;
        }
    }
    
}
