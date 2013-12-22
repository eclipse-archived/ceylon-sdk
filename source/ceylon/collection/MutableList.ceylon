"A [[List]] supporting addition, insertion, removal, and 
 mutation of its elements."
see (`class LinkedList`, `class ArrayList`)
by("Stéphane Épardaud")
shared interface MutableList<Element> 
        satisfies List<Element> & 
                  Cloneable<MutableList<Element>> {
    
    "Add the given item to the end of this list."
    shared formal void add(Element element);
    
    "Add the given items to the end of this list."
    shared formal void addAll({Element*} elements);
    
    "Replace the existing element at the specified index 
     with the given element."
    throws (`class AssertionException`, 
            "if the given index is out of bounds, that 
             is, if `index<0` or if `index>lastIndex`")
    shared formal void set(Integer index, Element element);
    
    "Insert the given item at the specified index."
    throws (`class AssertionException`, 
            "if the given index is out of bounds, that 
             is, if `index<0` or if `index>lastIndex+1`")
    shared formal void insert(Integer index, Element element);
    
    "Remove the item at the specified index, returning 
     the removed item, or `null` if there was no such 
     item."
    shared formal Element? delete(Integer index);
    
    "Remove all occurrences of the given value in this
     list."
    shared formal void removeAll(
            "The non-null value to remove"
            Element&Object element);
    
    "Remove the first occurrence of the given value in 
     this list, if any, returning `true` if the value
     occurs in the list, or `false` otherwise."
    shared formal Boolean removeFirst(
        "The non-null value to remove"
        Element&Object element);
    
    "Remove all null values from this list."
    shared formal void prune();
    
    "Replace all occurrences of the given value in this
     list with the given replacement value."
    shared formal void replaceAll(
            "The non-null value to replace"
            Element&Object element,
            "The replacement value"
            Element replacement);
    
    "Replace the first occurrence of the given value in 
     this list, if any, with the given replacement value, 
     returning `true` if the value occurs in the list, 
     or `false` otherwise."
    shared formal Boolean replaceFirst(
        "The non-null value to replace"
        Element&Object element,
        "The replacement value"
        Element replacement);
    
    "Replace all null values in this list with the given 
     value."
    shared formal void infill(
            "The replacement value"
            Element replacement);
    
    "Remove every item from this list, leaving an empty list."
    shared formal void clear();
    
    "Remove the item with index `0` from this list, returning 
     the removed item, or null if there was no such item."
    shared default Element? deleteFirst() => delete(0);
    
    "Remove the item with index `size-1` from this list, 
     returning the removed item, or null if there was no such 
     item."
    shared default Element? deleteLast() => delete(size-1);
    
    shared formal void deleteSpan(Integer from, Integer to);
    
    shared formal void deleteSegment(Integer from, Integer length);
    
}