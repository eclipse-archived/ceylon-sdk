import java.util {
    JIterator=Iterator,
    JCollection=Collection
}
import java.lang {
    UnsupOpEx=UnsupportedOperationException,
    ObjectArray
}

shared class JavaCollection<T>(Collection<T> collection)
        satisfies JCollection<T> {
    shared actual JIterator<T> iterator() 
            => JavaIterator(collection.iterator());
    shared actual Boolean empty => collection.empty;
    shared actual Integer size() => collection.size;
    shared actual Boolean add(T? \iobject) {
        throw UnsupOpEx("add()");
    }
    shared actual Boolean addAll(JCollection<out T>? collection) {
        throw UnsupOpEx("addAll()");
    }
    shared actual Boolean remove(Object? \iobject) {
        throw UnsupOpEx("remove()");
    }
    shared actual Boolean removeAll(JCollection<out Object>? collection) {
        throw UnsupOpEx("removeAll()");
    }
    shared actual Boolean retainAll(JCollection<out Object>? collection) {
        throw UnsupOpEx("retainAll()");
    }
    shared actual Boolean contains(Object? obj) {
        assert (exists obj);
        return collection.contains(obj);
    }
    shared actual Boolean containsAll(JCollection<out Object>? collection) {
        assert (exists collection);
        return collection.containsAll(collection);
    }
    shared actual void clear() {
        throw UnsupOpEx("clear()");
    }
    shared actual Integer hash => collection.hash;
    shared actual Boolean equals(Object that) {
        if (is JavaCollection<Anything> that) {
            return collection==that.collection;
        }
        else {
            return false;
        }
    }
    shared actual ObjectArray<Object> toArray() 
            => createJavaObjectArray<Object>(collection.coalesced);
}