"A wrapper class that exposes any [[List]] as unmodifiable, 
 hiding the underlying `List` implementation from clients, 
 and preventing attempts to narrow to [[MutableList]]."
by ("Gavin King")
serializable class UnmodifiableList<out Element>(List<Element> list) 
        satisfies List<Element> {

    getFromFirst(Integer index) => list.getFromFirst(index);
    
    size => list.size;
    lastIndex => list.lastIndex;
    
    first => list.first;
    rest => UnmodifiableList(list.rest);
    
    iterator() => list.iterator();
    
    reversed => UnmodifiableList(list.reversed);
    
    measure(Integer from, Integer length)
            => list.measure(from, length);
    span(Integer from, Integer to)
            => list.span(from, to);
    spanFrom(Integer from)
            => list.spanFrom(from);
    spanTo(Integer to)
            => list.spanTo(to);
    
    equals(Object that) => list==that;
    hash => list.hash;
    
    clone() => UnmodifiableList(list.clone());
    
    each(void step(Element element)) => list.each(step);
    
}

"Wrap the given [[List]], preventing attempts to narrow the
 returned `List` to [[MutableList]]."
shared List<Element> unmodifiableList<Element>(List<Element> list)
        => UnmodifiableList(list);
