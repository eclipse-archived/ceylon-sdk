import java.lang {
    UnsupportedOperationException,
    ObjectArray
}
import java.util {
    ListIterator,
    JCollection=Collection,
    AbstractList,
    Arrays
}

class JavaListIterator<E>(List<E> list, index) 
        satisfies ListIterator<E> {
    variable Integer index;
    shared actual E? next() => list[index++];
    shared actual Boolean hasNext() => index<list.size-1;
    shared actual Boolean hasPrevious() => index>0;
    shared actual E? previous() => list[--index];
    shared actual Integer previousIndex() => index-1;
    shared actual Integer nextIndex() => index;
    shared actual void add(E? e) {
        throw UnsupportedOperationException();
    }
    shared actual void remove() {
        throw UnsupportedOperationException();
    }
    shared actual void set(E? e) {
        throw UnsupportedOperationException(); 
    }
}


"A Java [[java.util::List]] that wraps a Ceylon [[List]].
 This list is unmodifiable, throwing 
 [[UnsupportedOperationException]] from mutator methods."
shared class JavaList<E>(List<E> list) 
        extends AbstractList<E>() {
    
    shared actual E? get(Integer int) => list.getFromFirst(int);
    
    shared actual ListIterator<E> listIterator() 
            => JavaListIterator(list,0);
    
    shared actual ListIterator<E> listIterator(Integer int) 
            => JavaListIterator(list, int);
    
    shared actual Integer size() => list.size;

    shared actual Boolean empty => list.empty;
    
    shared actual Boolean contains(Object obj) => list.contains(obj);
    
    shared actual Boolean containsAll(JCollection<out Object> collection)
            => list.containsEvery(CeylonIterable<Object>(collection));
    
    shared actual ObjectArray<Object> toArray() 
            => createJavaObjectArray<Object> { 
        for (e in list) e of Object?
    };
    
    shared actual ObjectArray<T> toArray<T>(ObjectArray<T> array) 
            => Arrays.asList(createJavaObjectArray(list)).toArray(array);
    
}