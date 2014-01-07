"Abstract supertype of datastructures that can be 
 used as LIFO stacks.
 
 A `Stack` has a well-defined [[top]]. Elements 
 may be added to the top of the stack by [[push]], 
 and removed from the top of the stack by [[pop]].
 
 Note that many `Stack`s are also [[List]]s, but 
 there is no defined relationship between the 
 order of elements in the list and the direction 
 of the stack. In particular, the top of the stack
 may be first element of the list, or it may be
 the last element of the list."
see (`class LinkedList`, `class ArrayList`,
     `interface Queue`)
shared interface Stack<Element> {
    
    "Push a new element onto the top of the stack."
    shared formal void push(Element element);
    
    "Remove and return the element at the top of 
     the stack."
    shared formal Element? pop();
    
    "The element currently at the top of the stack, 
     or `null` if the stack is empty."
    shared formal Element? top;
    
}