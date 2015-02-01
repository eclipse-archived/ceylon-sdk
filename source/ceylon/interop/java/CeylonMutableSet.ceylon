import ceylon.collection {
    MutableSet
}

import java.util {
    JSet=Set,
    HashSet
}

"A Ceylon [[MutableSet]] that wraps a [[java.util::Set]]."
shared class CeylonMutableSet<Element>(JSet<Element> set)
        extends CeylonSet<Element>(set)
        satisfies MutableSet<Element> 
        given Element satisfies Object {

    add(Element element) => set.add(element);
    
    remove(Element element) => set.remove(element);
    
    clear() => set.clear();
    
    clone() => CeylonMutableSet(HashSet(set));
    
}