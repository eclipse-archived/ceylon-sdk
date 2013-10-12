"A [[List]] supporting addition, insertion, removal, and 
 mutation of its elements."
see (`interface MutableMap`, `interface MutableSet`)
by("Stéphane Épardaud")
shared interface MutableList<Element> satisfies List<Element> {

    "Set the item at the given index in this list. The list 
     is expanded if `index > size`."
    shared formal void set(Integer index, Element val);
    
    "Add the given item to the end of this list."
    shared formal void add(Element val);

    "Add the given items to the end of this list."
    shared formal void addAll({Element*} values);

    "Insert the given item at the specified index. The list 
     is expanded if `index > size`."
    shared formal void insert(Integer index, Element val);

    "Remove the item at the specified index, returning the
     removed item, or null if there was no such item."
    shared formal Element? remove(Integer index);

    "Remove all occurrences of the given value from this
     list."
    shared formal void removeElement(Element val);

    "Remove every item from this list, leaving an empty list."
    shared formal void clear();
    
    "Remove the item with index `0` from this list, returning 
     the removed item, or null if there was no such item."
    shared default Element? removeFirst() => remove(0);
    
    "Remove the item with index `size-1` from this list, 
     returning the removed item, or null if there was no such 
     item."
    shared default Element? removeLast() => remove(size-1);
}