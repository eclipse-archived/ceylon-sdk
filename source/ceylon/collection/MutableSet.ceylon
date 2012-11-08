doc "Mutable set"
by "Stéphane Épardaud"
shared interface MutableSet<Element>
    satisfies Set<Element>
        given Element satisfies Object {
    
    doc "Adds an element to this set, if not already present"
    shared formal void add(Element element);

    doc "Adds the elements to this set, unless already present"
    shared formal void addAll(Element... elements);
    
    doc "Removes an element from this set, if present"
    shared formal void remove(Element element);
    
    doc "Removes every element"
    shared formal void clear();
}