import ceylon.collection {
    MutableMap
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
                map.map((key->item) => key)
                        .iterator());
            
            contains(Object? key) 
                    => if (exists key) 
                    then map.defines(key)
                    else false;
            
            size() => map.size;
            
            empty => map.empty;
        };
    
    shared actual JSet<JEntry<K,V>> entrySet()
        => object extends AbstractSet<JEntry<K,V>>() {
        
            iterator() => JavaIterator<JEntry<K,V>>(
                map.map(JavaEntry<K,V>)
                        .iterator());
        
            contains(Object? entry)
                    => if (is Entry<out Anything,out Anything> entry,
                           exists key = entry.key,
                           exists val = entry.\ivalue,
                           exists it = map[key])
                    then val == it
                    else false;
        
            size() => map.size;
        
            empty => map.empty;
        };
        
    shared actual JavaCollection<V> values() 
        => JavaCollection(map.items);
    
    shared actual Boolean containsKey(Object? k) {
        if (exists k) {
            return map.defines(k);
        }
        else {
            return false;
        }
    }
    
    shared actual V? put(K? k, V? v) {
        if (exists k, exists v) {
            if (is MutableMap<K,V> map) {
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
            if (is MutableMap<K,V> map) {
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
    
    /*shared actual Boolean remove(Object? k, Object? v) {
        if (is K k, is V v) {
            if (is MutableMap<K,V> map) {
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
            if (is MutableMap<K,V> map) {
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
        if (is MutableMap<K,V> map) {
            map.clear();
        }
        else {
            throw UnsupportedOperationException("not a mutable map");
        }
    }
}