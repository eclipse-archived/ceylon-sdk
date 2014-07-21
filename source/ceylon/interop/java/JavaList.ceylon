import java.util {
    AbstractList
}

"A Java [[java.util::List]] that wraps a Ceylon [[List]].
 This list is unmodifiable, throwing 
 [[java.lang::UnsupportedOperationException]] from mutator 
 methods."
shared class JavaList<E>(List<E> list) 
        extends AbstractList<E>() {
    
    shared actual E? get(Integer int) => list.getFromFirst(int);
    
    size() => list.size;

}
