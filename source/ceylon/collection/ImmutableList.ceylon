"A wrapper class that exposes any [[List]] as
 an immutable list, hiding the underlying `List`
 implementation from clients, and preventing 
 attempts to cast to [[ImmutableList]]."
by ("Gavin King")
shared class ImmutableList<out Element>(List<Element> list) 
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
    
    clone => ImmutableList(list.clone);
    
}