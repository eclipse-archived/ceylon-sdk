"Mutable set"
by("Stéphane Épardaud")
shared interface MutableSet<Element>
    satisfies Set<Element>
        given Element satisfies Object {
    
    "Adds an element to this set, if not already present. 
         
         Returns true if the element was added, false if it was already part of the Set."
    shared formal Boolean add(Element element);

    "Adds the elements to this set, unless already present. 
         
         Returns true if any element was added, false if they were all already part of the Set."
    shared formal Boolean addAll({Element*} elements);
    
    "Removes an element from this set, if present.
         
         Returns true if the element was removed, false if it was not part of the Set."
    shared formal Boolean remove(Element element);
    
    "Removes every element."
    shared formal void clear();
}