import java.lang {
    JIterable=Iterable
}
import java.util {
    JIterator=Iterator
}

"A Java [[JIterable]] that wraps a Ceylon [[Iterable]]."
shared class JavaIterable<T>(Iterable<T> iter) 
        satisfies JIterable<T> {

    shared actual JIterator<T> iterator() 
            => JavaIterator(iter.iterator());

}
