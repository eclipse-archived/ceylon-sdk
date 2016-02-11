"A [[Set]] supporting addition of new elements and removal 
 of existing elements."
by("Stéphane Épardaud")
see (`class HashSet`)
shared interface MutableSet<Element>
        satisfies Set<Element> &
                  SetMutator<Element>
        given Element satisfies Object {
    
    shared actual formal MutableSet<Element> clone();
    
}

"Protocol for mutation of a [[MutableSet]]."
see (`interface MutableSet`)
shared interface SetMutator<in Element>
        satisfies Set<Object>
        given Element satisfies Object {
    
    "Add the given [[element]] to this set, returning `true`
     if the element was _not_ already a member of this set, 
     or `false` otherwise."
    shared formal Boolean add(Element element);
    
    "Add the given [[elements]] to this set, returning `true`
     if any of the given elements was _not_ already a member
     of this set, or `false` otherwise."
    shared default Boolean addAll({Element*} elements) {
         variable value result = false;
         for (element in elements) {
             if (add(element)) {
                 result = true;
             }
         }
         return result;
     }
    
    "Remove an [[element]] from this set, returning `true`
     if the element was previously a member of the set."
    shared formal Boolean remove(Element element);
    
    "Remove the given [[elements]] from this set, returning 
     `true` if at least one element was previously a member 
     of the set."
    shared default Boolean removeAll({Element*} elements) {
        variable value result = false;
        for (element in elements) {
            if (remove(element)) {
                result = true;
            }
        }
        return result;
    }
    
    "Remove every element from this set, leaving an empty
     set with no elements."
    shared formal void clear();
    
    shared formal actual SetMutator<Element> clone();
    
}