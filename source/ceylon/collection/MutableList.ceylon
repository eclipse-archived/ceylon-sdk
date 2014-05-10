"A [[List]] supporting addition, insertion, removal, and
 replacement of its elements."
see (`class LinkedList`, `class ArrayList`)
by("Stéphane Épardaud")
shared interface MutableList<Element>
        satisfies List<Element> &
                  ListMutator<Element> {

    "Remove the element at the specified [[index]],
     returning the removed element, if any, or `null` if
     there was no such element."
    shared actual formal Element? delete(Integer index);

    "Remove the element with index `0` from this list,
     returning the removed element, or `null` if there was
     no such element."
    shared actual default Element? deleteFirst() => delete(0);

    "Remove the element with index `size-1` from this list,
     returning the removed element, or `null` if there was
     no such element."
    shared actual default Element? deleteLast() => delete(size-1);

    shared actual formal MutableList<Element> clone();

}

"Protocol for mutation of a [[MutableList]]."
see (`interface MutableList`)
shared interface ListMutator<in Element>
        satisfies List<Anything> {

    "Add the given [[element]] to the end of this list,
     incrementing the [[length|List.size]] of the list."
    shared formal void add(Element element);

    "Add the given [[elements]] to the end of this list,
     increasing the [[length|List.size]] of the list."
    shared formal void addAll({Element*} elements);

    "Replace the existing element at the specified [[index]]
     with the given [[element]]."
    throws (`class AssertionError`,
            "if the given index is out of bounds, that
             is, if `index<0` or if `index>lastIndex`")
    shared formal void set(Integer index, Element element);

    "Insert the given [[element]] at the specified [[index]],
     incrementing the [[length|List.size]] of the list."
    throws (`class AssertionError`,
            "if the given index is out of bounds, that
             is, if `index<0` or if `index>lastIndex+1`")
    shared formal void insert(Integer index, Element element);

    "Remove the element at the specified [[index]],
     returning the removed element, if any, or `null` if
     there was no such element."
    shared formal Anything delete(Integer index);

    "Remove all occurrences of the given [[value|element]]
     from this list.

     To remove just one occurrence of the given value, use
     [[removeFirst]] or [[removeLast]]."
    shared formal void remove(
            "The non-null value to remove"
            Element&Object element);

    "Remove all occurrences of every one of the given
     [[values|elements]] from this list."
    shared formal void removeAll(
            "The non-null values to remove"
            {Element&Object*} elements);

    "Remove the first occurrence of the given
     [[value|element]] from this list, if any, returning
     `true` if the value occurs in the list, or `false`
     otherwise."
    shared formal Boolean removeFirst(
            "The non-null value to remove"
            Element&Object element);

    "Remove the last occurrence of the given
     [[value|element]] from this list, if any, returning
     `true` if the value occurs in the list, or `false`
     otherwise."
    shared formal Boolean removeLast(
            "The non-null value to remove"
            Element&Object element);

    "Remove all null elements from this list, leaving a list
     with no null elements."
    shared formal void prune();

    "Replace all occurrences of the given [[value|element]]
     in this list with the given [[replacement
     value|replacement]].

     To replace just one occurrence of the given value, use
     [[replaceFirst]] or [[replaceLast]]."
    shared formal void replace(
            "The non-null value to replace"
            Element&Object element,
            "The replacement value"
            Element replacement);

    "Replace the first occurrence of the given
     [[value|element]] in this list, if any, with the given
     [[replacement value|replacement]], returning `true` if
     the value occurs in the list, or `false` otherwise."
    shared formal Boolean replaceFirst(
            "The non-null value to replace"
            Element&Object element,
            "The replacement value"
            Element replacement);

    "Replace the last occurrence of the given
     [[value|element]] in this list, if any, with the given
     [[replacement value|replacement]], returning `true` if
     the value occurs in the list, or `false` otherwise."
    shared formal Boolean replaceLast(
            "The non-null value to replace"
            Element&Object element,
            "The replacement value"
            Element replacement);

    "Replace all null values in this list with the given
     [[replacement value|replacement]]."
    shared formal void infill(
            "The replacement value"
            Element replacement);

    "Remove every element from this list, leaving an empty
     list with no elements."
    shared formal void clear();

    "Remove the element with index `0` from this list,
     returning the removed element, or `null` if there was
     no such element."
    shared formal Anything deleteFirst();

    "Remove the element with index `size-1` from this list,
     returning the removed element, or `null` if there was
     no such element."
    shared formal Anything deleteLast();

    "Remove every element with an index in the spanned range
     `from..to`."
    shared formal void deleteSpan(Integer from, Integer to);

    "Remove every element with an index in the segmented
     range `from:length`."
    shared formal void deleteSegment(Integer from, Integer length);

    "Truncate this list to the given [[size]] by removing
     elements from the end of the list, if necessary,
     to leave a list with at most the given size."
    throws (`class AssertionError`, "if `size<0`")
    shared formal void truncate(Integer size);

}

"Converts the indexes of a segment to those of an equivalent 
 span."
[Integer, Integer] segmentToSpan(Integer from, Integer length)
        => length <= 0 then [-1, -1] else [from, from+length-1];

"Converts the indexes of a span to those of an equivalent 
 segment which may be reversed (the span might have 
 `from > to` to express that the elements of the segment 
 should be reversed). The returned tuple is of this form:
 
     [start, length, reversed]"
[Integer, Integer, Boolean] spanToSegment
        (Integer from, Integer to, Integer size) {
    if (size == 0 || from < 0 && to < 0) {
        return [0, 0, false];
    }
    value reversed = from > to;
    value start = largest(0, reversed then to else from);
    value end = smallest(size-1, reversed then from else to);
    return [start, 1 + end - start, reversed];
}

Integer largest(Integer x, Integer y) => x>y then x else y;
Integer smallest(Integer x, Integer y) => x<y then x else y;
