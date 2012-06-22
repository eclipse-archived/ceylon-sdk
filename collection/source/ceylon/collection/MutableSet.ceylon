doc "Mutable set"
by "Stéphane Épardaud"
shared interface MutableSet<Element>
    satisfies Set<Element>
        given Element satisfies Object {
    
    doc "Adds an element to this set, if not already present"
    shared formal void add(Element element);

    doc "Adds every element from the given collection to this set, unless already present"
    shared formal void addAll(Collection<Element> collection);
    
    doc "Removes an element from this set, if present"
    shared formal void remove(Element element);
    
    doc "Removes every element"
    shared formal void clear();
}