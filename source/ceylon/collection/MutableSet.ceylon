"A [[Set]] supporting addition of new elements and removal of 
 existing elements."
by("Stéphane Épardaud")
see (`class HashSet`)
shared interface MutableSet<Element>
        satisfies Set<Element> &
                  Cloneable<MutableSet<Element>>
        given Element satisfies Object {
    
    "Add an element to this set, returning true if the element
     was already a member of the set, or false otherwise."
    shared formal Boolean add(Element element);

    "Add the given elements to this set, returning true if any 
     of the given elements was not already element a member of
     the set."
    shared formal Boolean addAll({Element*} elements);
    
    "Remove an element from this set, returning true if the
     element was previously a member of the set."
    shared formal Boolean remove(Element element);
    
    "Remove every element from this set, leaving an empty set."
    shared formal void clear();
}