
import java.lang { JIterable=Iterable }

"Takes a Java `Iterable` and turns it into a Ceylon `Iterable`"
shared class CeylonIterable<T>(JIterable<T> jiter) satisfies Iterable<T> {

    shared actual Iterator<T> iterator() {
        return CeylonIterator(jiter.iterator());
    }
    
}
