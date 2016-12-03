import ceylon.interop.java {
    CeylonIterator
}

import java.util {
    JList=List,
    ArrayList
}

"A Ceylon [[List]] that wraps a [[java.util::List]].

 If the given [[list]] contains null elements, an optional
 [[Element]] type must be explicitly specified, for example:

     CeylonList<String?>(javaStringList)

 If a non-optional `Element` type is specified, an
 [[AssertionError]] will occur whenever a null value is
 encountered while iterating the list."
shared class CeylonList<out Element>(list)
        extends CeylonCollection<Element>(list)
        satisfies List<Element> {

    JList<out Element> list;

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