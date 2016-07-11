import ceylon.collection {
    MutableMap
}
import ceylon.language {
    CEntry=Entry
}

import java.lang {
    UnsupportedOperationException,
    IllegalArgumentException
}
import java.util {
    JSet=Set,
    AbstractSet,
    AbstractMap,
    JMap=Map {
        JEntry=Entry
    }
}

class JavaEntry<K,V>(K->V entry) 
        extends Object()
        satisfies JEntry<K,V> 
        given K satisfies Object 
        given V satisfies Object {
    
    key => entry.key;
    \ivalue => entry.item;
    //assign \ivalue {
    //    throw UnsupportedOperationException();
    //}
    shared actual V setValue(V? v) {
        throw UnsupportedOperationException();
    }
    
    shared actual Boolean equals(Object that) {
        if (is JEntry<out Anything,out Anything> that,
            exists thatKey = that.key,
            exists thatValue = that.\ivalue) {
            return key==thatKey && 
                    \ivalue==thatValue;
        }
        else {
            return false;
        }
    }

    shared actual Integer hash
        // Calculate hash per java.util.Map.Entry contract, and
        // defeat bit shifting described in
        // https://github.com/ceylon/ceylon-compiler/issues/1334
        =>  key.hash.xor(\ivalue.hash).and(#ffffffff);
}

"A Java [[java.util::Map]] that wraps a Ceylon [[Map]]. This 
 map is unmodifiable, throwing 
 [[java.lang::UnsupportedOperationException]] from mutator 
 methods."
shared class JavaMap<K,V>(Map<K,V> map)
        extends AbstractMap<K,V>() 
        given K satisfies Object 
        given V satisfies Object {
    
    shared actual JSet<K> keySet()
            => object extends AbstractSet<K>() {
            
            iterator() => JavaIterator<K>(
                map.map(CEntry.key).iterator());
            
            contains(Object? key) 
                    => if (exists key) 
                    then map.defines(key)
                    else false;
            
            size() => map.size;
            
            empty => map.empty;
        };
    
    entrySet()
        => object extends AbstractSet<JEntry<K,V>>() {
        
            iterator() => JavaIterator<JEntry<K,V>>(
                map.map(JavaEntry).iterator());
        
            contains(Object? entry)
                    => if (is JEntry<out Anything,out Anything> entry,
                           exists key = entry.key,
                           exists val = entry.\ivalue,
                           exists it = map[key])
                    then val == it
                    else false;
        
            size() => map.size;
        
            empty => map.empty;
        };
        
    values() => JavaCollection(map.items);
    
    containsKey(Object? k) 
            => if (exists k) 
            then map.defines(k) 
            else false;
    
    shared actual V? put(K? k, V? v) {
        if (exists k, exists v) {
            if (is MutableMap<in K,V> map) {
                return map.put(k,v);
            }
            else {
                throw UnsupportedOperationException("not a mutable map");
            }
        }
        else {
            throw IllegalArgumentException("map may not have null keys or items");
        }
    }
    
    shared actual V? remove(Object? k) {
        if (is K k) {
            if (is MutableMap<in K,out V> map) {
                return map.remove(k);
            }
            else {
                throw UnsupportedOperationException("not a mutable map");
            }
        }
        else {
            return null;
        }
    }
    
    //TODO: put these back in once we can depend on Java 8!
    /*shared actual Boolean remove(Object? k, Object? v) {
        if (is K k, is V v) {
            if (is MutableMap<in K, in V> map) {
                return map.removeEntry(k, v);
            }
            else {
                throw UnsupportedOperationException("not a mutable map");
            }
        }
        else {
            return false;
        }
    }
    
    shared actual Boolean replace(K? k, V? v, V? v1) {
        if (exists k, exists v, exists v1) {
            if (is MutableMap<in K,in V> map) {
                return map.replaceEntry(k,v,v1);
            }
            else {
                throw UnsupportedOperationException("not a mutable map");
            }
        }
        else {
            throw IllegalArgumentException("map may not have null keys or items");
        }
    }*/
    
    shared actual void clear() {
        if (is MutableMap<out Anything, out Anything> map) {
            map.clear();
        }
        else {
            throw UnsupportedOperationException("not a mutable map");
        }
    }
}