import ceylon.interop.java {
    CeylonIterator
}

import java.util {
    JList=List,
    ArrayList
}

"A Ceylon [[List]] that wraps a [[java.util::List]]."
shared class CeylonList<Element>(JList<out Element> list) 
        satisfies List<Element> 
        given Element satisfies Object {
    
    getFromFirst(Integer index) => list.get(index);
    
    size => list.size();
    
    shared actual Integer? lastIndex {
        value size = this.size;
        return size>0 then size-1;
    }
    
    iterator() => CeylonIterator(list.iterator());
    
    clone() => CeylonList(ArrayList(list));
    
    equals(Object that) 
            => (super of List<Element>).equals(that);
    
    hash => (super of List<Element>).hash;
    
}