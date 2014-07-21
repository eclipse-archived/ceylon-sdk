import java.lang {
    ObjectArray
}
import java.util {
    Iterator,
    AbstractCollection,
    Arrays
}

"A Java [[java.util::Collection]] that wraps a Ceylon
 [[Collection]]. This collection is unmodifiable, throwing 
 [[java.lang::UnsupportedOperationException]] from mutator 
 methods."
shared class JavaCollection<E>(Collection<E> collection)
        extends AbstractCollection<E>() {
    
    shared actual Iterator<E> iterator() 
            => JavaIterator(collection.iterator());
    
    shared actual Integer size() => collection.size;
    
    shared actual ObjectArray<Object> toArray() 
            => createJavaObjectArray<Object> { 
        for (e in collection) e of Object?
    };
    
    shared actual ObjectArray<T> toArray<T>(ObjectArray<T> array) 
            => Arrays.asList(createJavaObjectArray(collection)).toArray(array);
    
    shared actual Boolean equals(Object that) {
        //TODO: this does not obey the contract of Collection
        if (is JavaCollection<out Anything> that) {
            return collection==that.collection;
        }
        else {
            return false;
        }
    }
    
    shared actual Integer hash => collection.hash;
    
}

