import java.util {
    AbstractSet,
    Collection
}
import ceylon.collection {
    MutableSet
}
import java.lang {
    UnsupportedOperationException,
    IllegalArgumentException
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
    
    shared actual Boolean add(E? e) {
        if (exists e) {
            if (is MutableSet<in E> set) {
                return set.add(e);
            }
            else {
                throw UnsupportedOperationException("not a mutable set");
            }
        }
        else {
            throw IllegalArgumentException("set may not have null elements");
        }
    }
    
    shared actual Boolean remove(Object? e) {
        if (is E e) {
            if (is MutableSet<in E> set) {
                return set.remove(e);
            }
            else {
                throw UnsupportedOperationException("not a mutable set");
            }
        }
        else {
            return false;
        }
    }
    
    shared actual Boolean removeAll(Collection<out Object> collection) {
        if (is MutableSet<in E> set) {
            variable Boolean result = false;
            for (e in collection) {
                if (is E e, set.remove(e)) {
                    result = true;
                }
            }
            return result;
        }
        else {
            throw UnsupportedOperationException("not a mutable set");
        }
    }
    
    shared actual Boolean retainAll(Collection<out Object> collection) {
        if (is MutableSet<in E> set) {
            variable Boolean result = false;
            for (e in set.clone()) { //TODO: is the clone really necessary?
                if (!collection.contains(e)) {
                    set.remove(e);
                    result = true;
                }
            }
            return result;
        }
        else {
            throw UnsupportedOperationException("not a mutable set");
        }
    }
    
    shared actual void clear() {
        if (is MutableSet<out Anything> set) {
            set.clear();
        }
        else {
            throw UnsupportedOperationException("not a mutable set");
        }
    }
    
}