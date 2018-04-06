/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
import ceylon.collection {
    MapMutator
}

import java.lang {
    UnsupportedOperationException,
    IllegalArgumentException
}
import java.util {
    AbstractSet,
    AbstractMap
}
import java.io {
    Serializable
}

"A Java [[java.util::Map]] that wraps a Ceylon [[Map]]. This 
 map is unmodifiable, throwing 
 [[java.lang::UnsupportedOperationException]] from mutator 
 methods."
shared class JavaMap<K,V>(Map<K,V?> map)
        extends AbstractMap<K,V>() 
        satisfies Serializable
        given K satisfies Object 
        given V satisfies Object {
    
    keySet()
            => object extends AbstractSet<K>() {
            
            iterator() => JavaIterator<K>(
                map.map((e) => e.key)
                    .iterator());
            
            contains(Object? key) 
                    => if (exists key) 
                    then map.defines(key)
                    else false;
            
            size() => map.size;
            
            empty => map.empty;
        };
    
    entrySet()
        => object extends AbstractSet<Entry<K,V>>() {
        
            iterator() => JavaIterator<Entry<K,V>>(
                map.map((e) => SimpleImmutableEntry(e.key, e.item))
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
        
    values() => JavaCollection(map.items);
    
    containsKey(Object? k)
            => if (exists k)
            then map.defines(k)
            else false;

    get(Object? key)
            => if (exists key)
            then map[key]
            else null;

    shared actual V? put(K? k, V? v) {
        if (exists k) {
            value old = map[k];
            if (exists v) {
                if (is MapMutator<K,V> map) {
                    map[k] = v;
                }
                else {
                    throw UnsupportedOperationException("not a mutable map");
                }
            }
            else {
                if (is MapMutator<K,Null> map) {
                    map[k] = null;
                }
                else {
                    if (map is MapMutator<Nothing,Nothing>) {
                        throw IllegalArgumentException("map may not have null items");
                    }
                    else {
                        throw UnsupportedOperationException("not a mutable map");
                    }
                }
            }
            return old;
        }
        else {
            throw IllegalArgumentException("map may not have null keys");
        }
    }
    
    shared actual V? remove(Object? k) {
        if (is MapMutator<K,Nothing> map) {
            if (is K k) {
                value old = map[k];
                map.remove(k);
                return old;
            }
            else {
                return null;
            }
        }
        else {
            throw UnsupportedOperationException("not a mutable map");
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
        if (is MapMutator<Nothing,Nothing> map) {
            map.clear();
        }
        else {
            throw UnsupportedOperationException("not a mutable map");
        }
    }
}