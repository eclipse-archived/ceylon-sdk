"A [[List]] supporting addition, insertion, removal, and 
 replacement of its elements."
see (`class LinkedList`, `class ArrayList`)
by("Stéphane Épardaud")
shared interface MutableList<Element> 
        satisfies List<Element> & 
                  Cloneable<MutableList<Element>> {
    
    "Add the given [[element]] to the end of this list,
     incrementing the [[length|List.size]] of the list."
    shared formal void add(Element element);
    
    "Add the given [[elements]] to the end of this list,
     increasing the [[length|List.size]] of the list."
    shared formal void addAll({Element*} elements);
    
    "Replace the existing element at the specified [[index]]
     with the given [[element]]."
    throws (`class AssertionException`, 
            "if the given index is out of bounds, that 
             is, if `index<0` or if `index>lastIndex`")
    shared formal void set(Integer index, Element element);
    
    "Insert the given [[element]] at the specified [[index]],
     incrementing the [[length|List.size]] of the list."
    throws (`class AssertionException`, 
            "if the given index is out of bounds, that 
             is, if `index<0` or if `index>lastIndex+1`")
    shared formal void insert(Integer index, Element element);
    
    "Remove the element at the specified [[index]], 
     returning the removed element, or `null` if there was 
     no such element."
    shared formal Element? delete(Integer index);
    
    "Remove all occurrences of the [[given value|element]] 
     from this list."
    shared formal void removeAll(
            "The non-null value to remove"
            Element&Object element);
    
    "Remove the first occurrence of the [[given 
     value|element]] from this list, if any, returning `true` 
     if the value occurs in the list, or `false` otherwise."
    shared formal Boolean removeFirst(
            "The non-null value to remove"
            Element&Object element);
    
    "Remove all null elements from this list, leaving a list
     with no null elements."
    shared formal void prune();
    
    "Replace all occurrences of the [[given value|element]] 
     in this list with the [[given replacement 
     value|replacement]]."
    shared formal void replaceAll(
            "The non-null value to replace"
            Element&Object element,
            "The replacement value"
            Element replacement);
    
    "Replace the first occurrence of the given value in 
     this list, if any, with the given replacement value, 
     returning `true` if the value occurs in the list, or 
     `false` otherwise."
    shared formal Boolean replaceFirst(
            "The non-null value to replace"
            Element&Object element,
            "The replacement value"
            Element replacement);
    
    "Replace all null values in this list with the [[given 
     replacement value|replacement]]."
    shared formal void infill(
            "The replacement value"
            Element replacement);
    
    "Remove every element from this list, leaving an empty 
     list with no elements."
    shared formal void clear();
    
    "Remove the element with index `0` from this list, 
     returning the removed element, or `null` if there was 
     no such element."
    shared default Element? deleteFirst() => delete(0);
    
    "Remove the element with index `size-1` from this list, 
     returning the removed element, or `null` if there was 
     no such element."
    shared default Element? deleteLast() => delete(size-1);
    
    "Remove every element with an index in the spanned
     range `from..to`."
    shared formal void deleteSpan(Integer from, Integer to);
    
    "Remove every element with an index in the segmented
     range `from:length`."
    shared formal void deleteSegment(Integer from, Integer length);
    
}