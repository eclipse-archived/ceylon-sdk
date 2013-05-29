
/*

import java.lang { UnsupOpEx=UnsupportedOperationException, ObjectArray, arrays }
import java.util { JCollection=Collection, JIterator=Iterator }

shared class JavaCollection<T>({T*} items) satisfies JCollection<T> {

    shared actual Boolean add(T? e) { throw UnsupOpEx("add()"); }
    
    shared actual Boolean addAll(JCollection<T>? collection) { throw UnsupOpEx("addAll()"); }
    
    shared actual void clear() { throw UnsupOpEx("clear()"); }
    
    shared actual Boolean contains(Object? obj) {
        if (exists obj) {
            return items.contains(obj);
        } else {
            return false;
        }
    }
    
    shared actual Boolean containsAll(JCollection<Object>? collection) {
        if (exists collection) {
            return items.containsEvery(CeylonIterable(collection));
        } else {
            return false;
        }
    }
    
    shared actual Boolean empty => items.empty;
    
    shared actual JIterator<T> iterator() => JavaIterator(items.iterator());
    
    shared actual Boolean remove(Object? obj)  { throw UnsupOpEx("remove()"); }
    
    shared actual Boolean removeAll(JCollection<Object>? collection) { throw UnsupOpEx("removeAll()"); }
    
    shared actual Boolean retainAll(JCollection<Object>? collection)  { throw UnsupOpEx("retainAll()"); }
    
    shared actual Integer size() => items.size;
    
    shared actual ObjectArray<Object> toArray() {
        value x = arrays.toObjectArray(items);
        return nothing;
    }
    
    shared actual Boolean equals(Object that) => items.equals(that);
    
    shared actual Integer hash => items.hash;
    


}

*/

