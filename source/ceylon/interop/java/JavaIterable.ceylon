import java.lang {
    JIterable=Iterable
}

"A Java [[JIterable]] that wraps a Ceylon [[Iterable]]."
shared class JavaIterable<Element>(Iterable<Element?> iter)
        satisfies JIterable<Element> {

    iterator() => JavaIterator(iter.iterator());

    string => iter.string;
}
