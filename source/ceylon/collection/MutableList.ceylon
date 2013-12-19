"A [[List]] supporting addition, insertion, removal, and 
 mutation of its elements."
see (`interface MutableMap`, `interface MutableSet`)
by("Stéphane Épardaud")
shared interface MutableList<Element> 
        satisfies List<Element> & 
                  Cloneable<MutableList<Element>> {
    
    "Add the given item to the end of this list."
    shared formal void add(Element val);
    
    "Add the given items to the end of this list."
    shared formal void addAll({Element*} values);
    
    "Replace the existing element at the specified index 
     with the given element."
    throws (`class AssertionException`, 
    "if the given index is out of bounds, that is, 
     if `index<0` or if `index>lastIndex`")
    shared formal void set(Integer index, Element val);
    
    "Insert the given item at the specified index."
    throws (`class AssertionException`, 
    "if the given index is out of bounds, that is, 
     if `index<0` or if `index>lastIndex+1`")
    shared formal void insert(Integer index, Element val);
    
    "Remove the item at the specified index, returning the
     removed item, or null if there was no such item."
    shared formal Element? remove(Integer index);
    
    "Remove all occurrences of the given value in this
     list."
    shared formal void removeElement(
            "The non-null value to remove"
            Element&Object val);
    
    "Remove all null values from this list."
    shared formal void prune();
    
    "Replace all occurrences of the given value in this
     list with the given replacement value."
    shared formal void replaceElement(
            "The non-null value to replace"
            Element&Object val,
            "The replacement value"
            Element newVal);
    
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