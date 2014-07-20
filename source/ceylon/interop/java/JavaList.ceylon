import java.util {
    ListIterator,
    JCollection=Collection,
    AbstractList
}
import java.lang {
    UnsupportedOperationException,
    ArrayStoreException,
    ObjectArray
}

class JavaListIterator<E>(List<E> list, variable Integer index) 
        satisfies ListIterator<E> {
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
    
    shared actual ObjectArray<T> toArray<T>(ObjectArray<T> array) {
        if (is {T?*} list) {
            if (list.size<=array.size) {
                variable value i = 0;
                for (e in list) {
                    array.set(i++, e);
                }
                while (i<array.size) {
                    array.set(i++, null);
                }
                return array;
            }
            else {
                return createJavaObjectArray<T>(list);
            }
        }
        else {
            throw ArrayStoreException("list cannot be stored in given array");
        }
    }
    
    shared actual Boolean addAll(Integer index, JCollection<out E> collection) {
        throw UnsupportedOperationException();
    }
    
    shared actual E remove(Integer index) {
        throw UnsupportedOperationException();
    }
    
    shared actual Boolean removeAll(JCollection<out Object> collection) {
        throw UnsupportedOperationException();
    }
    
    shared actual Boolean retainAll(JCollection<out Object> collection) {
        throw UnsupportedOperationException();
    }
    
}