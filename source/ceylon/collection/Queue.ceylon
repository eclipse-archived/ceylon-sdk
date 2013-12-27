"Abstract supertype of datastructures that can
 be used as FIFO queues.
 
 A `Queue` has a well-defined [[front]] and
 [[back]]. Elements may be added to the back
 of the queue by [[offer]], and removed from
 the front of the queue by [[accept]].
 
 Note that many `Queue`s are also [[List]]s, but 
 there is no defined relationship between the 
 order of elements in the list and the direction 
 of the queue. In particular, the front of the 
 queue may be first element of the list, or it 
 may be the last element of the list."
see (`class LinkedList`, `class ArrayList`,
     `interface Stack`)
shared interface Queue<Element> {
    
    "Add a new element to the back of the queue."
    shared formal void offer(Element element);
    
    "Remove and return the element at the front 
     of the queue."
    shared formal Element? accept();
    
    "The element currently at the front of the 
     queue, or `null` if the queue is empty."
    shared formal Element? front;
    
    "The element currently at the back of the 
     queue, or `null` if the queue is empty."
    shared formal Element? back;
    
}