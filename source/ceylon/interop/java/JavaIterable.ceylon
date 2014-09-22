import java.lang {
    JIterable=Iterable
}

"A Java [[JIterable]] that wraps a Ceylon [[Iterable]]."
shared class JavaIterable<T>(Iterable<T> iter) 
        satisfies JIterable<T> {

    iterator() => JavaIterator(iter.iterator());

}
