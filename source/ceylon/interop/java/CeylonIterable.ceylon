
import java.lang { JIterable=Iterable }

shared class CeylonIterable<T>(JIterable<T> jiter) satisfies Iterable<T> {

    shared actual Iterator<T> iterator() {
        return CeylonIterator(jiter.iterator());
    }
    
}
