import ceylon.collection {
    ListMutator
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
shared class JavaList<E>(List<E?> list)
        extends AbstractList<E>() {
    
    get(Integer int) => list[int];
    
    size() => list.size;

    iterator() => object satisfies Iterator<E> {
        variable value delegate 
                = JavaIterator(list.iterator());
        variable value currentIndex = -1;

        hasNext() => delegate.hasNext();
        
        shared actual E? next() {
            currentIndex++;
            return delegate.next();
        }
        
        shared actual void remove() {
            if (!is ListMutator<Nothing> list) {
                throw UnsupportedOperationException("not a mutable list");
            }
            if (currentIndex < 0) {
                throw IllegalStateException();
            }
            list.delete(currentIndex--);
            delegate = JavaIterator(list.skip(currentIndex).iterator());
        }
    };

    shared actual E? set(Integer index, E? e) {
        if (exists e) {
            if (is ListMutator<E> list) {
                value result = list[index];
                list[index] = e;
                return result;
            }
            else {
                throw UnsupportedOperationException("not a mutable list");
            }
        }
        else {
            if (is ListMutator<Null> list) {
                value result = list[index];
                list[index] = null;
                return result;
            }
            else {
                if (list is ListMutator<Nothing>) {
                    throw IllegalArgumentException("list may not have null elements");
                }
                else {
                    throw UnsupportedOperationException("not a mutable list");
                }
            }
        }
    }

    shared actual Boolean add(E? e) {
        if (exists e) {
            if (is ListMutator<E> list) {
                list.add(e);
            }
            else {
                throw UnsupportedOperationException("not a mutable list");
            }
        }
        else {
            if (is ListMutator<Null> list) {
                list.add(null);
            }
            else {
                if (list is ListMutator<Nothing>) {
                    throw IllegalArgumentException("list may not have null elements");
                }
                else {
                    throw UnsupportedOperationException("not a mutable list");
                }
            }
        }
        return true;
    }
    
    shared actual void add(Integer index, E? e) {
        if (exists e) {
            if (is ListMutator<E> list) {
                list.insert(index, e);
            }
            else {
                throw UnsupportedOperationException("not a mutable list");
            }
        }
        else {
            if (is ListMutator<Null> list) {
                list.insert(index, null);
            }
            else {
                if (list is ListMutator<Nothing>) {
                    throw IllegalArgumentException("list may not have null elements");
                }
                else {
                    throw UnsupportedOperationException("not a mutable list");
                }
            }
        }
    }
    
    shared actual Boolean remove(Object? e) {
        if (is ListMutator<E> list) {
            if (is E? e) {
                if (exists e) {
                    return list.removeFirst(e);
                }
                else {
                    throw IllegalArgumentException("cannot remove null elements");
                }
            }
            else {
                return false;
            }
        }
        else {
            throw UnsupportedOperationException("not a mutable list");
        }
    }
    
    shared actual Boolean removeAll(Collection<out Object> collection) {
        if (is ListMutator<E> list) {
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
        if (is ListMutator<E> list) {
            variable Boolean result = false;
            for (e in list.clone()) { //TODO: is the clone really necessary?
                if (exists e, //TODO: what to do with nulls, this is sorta wrong?
                    !e in collection) {
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
        if (is ListMutator<Nothing> list) {
            list.clear();
        }
        else {
            throw UnsupportedOperationException("not a mutable list");
        }
    }
}
