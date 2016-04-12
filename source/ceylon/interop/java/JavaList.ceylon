import ceylon.collection {
    MutableList
}

import java.lang {
    IllegalArgumentException,
    UnsupportedOperationException,
    IllegalStateException
}
import java.util {
    AbstractList,
    Collection,
    Iterator
}

"A Java [[java.util::List]] that wraps a Ceylon [[List]].
 This list is unmodifiable, throwing 
 [[java.lang::UnsupportedOperationException]] from mutator 
 methods."
shared class JavaList<E>(List<E> list) 
        extends AbstractList<E>() {
    
    shared actual E? get(Integer int) => list.getFromFirst(int);
    
    size() => list.size;

    iterator() => object satisfies Iterator<E> {
        variable value delegate = JavaIterator(list.iterator());
        variable value currentIndex = -1;

        hasNext() => delegate.hasNext();
        
        shared actual E? next() {
            currentIndex++;
            return delegate.next();
        }
        
        shared actual void remove() {
            if (!is MutableList<E> list) {
                throw UnsupportedOperationException("not a mutable list");
            }
            if (currentIndex < 0) {
                throw IllegalStateException();
            }
            list.delete(currentIndex--);
            delegate = JavaIterator(list.skip(currentIndex).iterator());
        }
    };

    shared actual Boolean add(E? e) {
        if (is E e) {
            if (is MutableList<E> list) {
                list.add(e);
                return true;
            }
            else {
                throw UnsupportedOperationException("not a mutable list");
            }
        }
        else {
            throw IllegalArgumentException("list may not have null elements");
        }
    }
    
    shared actual void add(Integer index, E? e) {
        if (is E e) {
            if (is MutableList<E> list) {
                list.insert(index, e);
            }
            else {
                throw UnsupportedOperationException("not a mutable list");
            }
        }
        else {
            throw IllegalArgumentException("list may not have null elements");
        }
    }
    
    shared actual Boolean remove(Object? e) {
        if (is E e) {
            if (is MutableList<E> list) {
                if (exists e) {
                    return list.removeFirst(e);
                }
                else {
                    throw IllegalArgumentException("cannot remove null elements");
                }
            }
            else {
                throw UnsupportedOperationException("not a mutable list");
            }
        }
        else {
            return false;
        }
    }
    
    shared actual Boolean removeAll(Collection<out Object> collection) {
        if (is MutableList<E> list) {
            variable Boolean result = false;
            for (e in collection) {
                if (is E e, list.removeFirst(e)) {
                    result = true;
                }
            }
            return result;
        }
        else {
            throw UnsupportedOperationException("not a mutable list");
        }
    }
    
    shared actual Boolean retainAll(Collection<out Object> collection) {
        if (is MutableList<E> list) {
            variable Boolean result = false;
            for (e in list.clone()) { //TODO: is the clone really necessary?
                if (exists e, //TODO: what to do with nulls, this is sorta wrong?
                    !collection.contains(e)) {
                    list.removeFirst(e);
                    result = true;
                }
            }
            return result;
        }
        else {
            throw UnsupportedOperationException("not a mutable list");
        }
    }
    
    shared actual void clear() {
        if (is MutableList<E> list) {
            list.clear();
        }
        else {
            throw UnsupportedOperationException("not a mutable list");
        }
    }
}
