"A wrapper class that exposes any [[List]] as unmodifiable, 
 hiding the underlying `List` implementation from clients, 
 and preventing attempts to narrow to [[MutableList]]."
by ("Gavin King")
class UnmodifiableList<out Element>(List<Element> list) 
        satisfies List<Element> {

    get(Integer index) => list.get(index);
    
    size => list.size;
    lastIndex => list.lastIndex;
    
    first => list.first;
    rest => list.rest;
    
    iterator() => list.iterator();
    
    reversed => list.reversed;
    
    segment(Integer from, Integer length)
            => list.segment(from, length);
    span(Integer from, Integer to)
            => list.span(from, to);
    spanFrom(Integer from)
            => list.spanFrom(from);
    spanTo(Integer to)
            => list.spanTo(to);
    
    equals(Object that) 
            => list.equals(that);
    hash => list.hash;
    
    clone() => UnmodifiableList(list.clone());
    
}

"Wrap the given [[List]], preventing attempts to narrow the
 returned `List` to [[MutableList]]."
shared List<Element> unmodifiableList<Element>(List<Element> list)
        => UnmodifiableList(list);
