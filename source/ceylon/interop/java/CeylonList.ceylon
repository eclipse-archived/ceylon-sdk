import ceylon.interop.java {
    CeylonIterator
}

import java.util {
    JList=List,
    ArrayList
}

"A Ceylon [[List]] that wraps a [[java.util::List]]."
shared class CeylonList<out Element>(JList<out Element> list)
        extends CeylonCollection<Element>(list)
        satisfies List<Element> 
        given Element satisfies Object {
    
    getFromFirst(Integer index)
            => if (0 <= index < size)
            then list[index]
            else null;
    
    size => list.size();
    
    contains(Object element) => list.contains(element);

    shared actual Integer? lastIndex {
        value size = this.size;
        return size>0 then size-1;
    }
    
    iterator() => CeylonIterator(list.iterator());
    
    shared actual default List<Element> clone()
            => CeylonList(ArrayList(list));
    
    equals(Object that) 
            => (super of List<Element>).equals(that);
    
    hash => (super of List<Element>).hash;
    
}