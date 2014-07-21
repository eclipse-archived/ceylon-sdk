import java.util {
    AbstractSet
}

"A Java [[java.util::Set]] that wraps a Ceylon [[Set]]. This 
 set is unmodifiable, throwing 
 [[java.lang::UnsupportedOperationException]] from mutator 
 methods."
shared class JavaSet<E>(Set<E> set) 
        extends AbstractSet<E>() 
        given E satisfies Object {
    
    iterator() => JavaIterator<E>(set.iterator());
    
    size() => set.size;
    
}