class PeekingIterator<Element>(Iterator<Element> delegate)
        satisfies Iterator<Element>
        given Element satisfies Object {

    variable Element | Finished | Null peeked = null;

    shared Element | Finished peek()
        =>  peeked else (peeked = delegate.next());

    shared actual Element | Finished next() {
        if (exists p = peeked) {
            peeked = null;
            return p;
        }
        return delegate.next();
    }
}
