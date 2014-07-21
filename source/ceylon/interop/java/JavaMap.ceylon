import java.lang {
    UnsupportedOperationException
}
import java.util {
    JSet=Set,
    AbstractSet,
    AbstractMap,
    JMap=Map {
        JEntry=Entry
    }
}

class JavaEntry<K,V>(Entry<K,V> entry) 
        extends Object()
        satisfies JEntry<K,V> 
        given K satisfies Object 
        given V satisfies Object {
    
    key => entry.key;
    \ivalue => entry.item;
    //assign \ivalue {
    //    throw UnsupportedOperationException();
    //}
    shared actual V setValue(V v) {
        throw UnsupportedOperationException();
    }
    
    shared actual Boolean equals(Object that) {
        if (is JEntry<out Anything,out Anything> that) {
            if (exists thatKey = that.key, 
                exists thatValue = that.\ivalue) {
                return key==thatKey && 
                        \ivalue==thatValue;
            }
        }
        return false;
    }
    
    shared actual Integer hash 
            => 31*key.hash+\ivalue.hash;
}

"A Java [[java.util::Map]] that wraps a Ceylon [[Map]]. This 
 amp is unmodifiable, throwing 
 [[java.lang::UnsupportedOperationException]] from mutator 
 methods."
shared class JavaMap<K,V>(Map<K,V> map)
        extends AbstractMap<K, V>() 
        given K satisfies Object 
        given V satisfies Object {
    
    shared actual JSet<JEntry<K,V>> entrySet() {
        object result
                extends AbstractSet<JEntry<K,V>>() {
            shared actual JavaIterator<JEntry<K,V>> iterator() {
                value entries = map.map<JEntry<K,V>>(JavaEntry<K,V>);
                return JavaIterator(entries.iterator());
            }
            size() => map.size;
            
        }
        return result;
    }
    
}