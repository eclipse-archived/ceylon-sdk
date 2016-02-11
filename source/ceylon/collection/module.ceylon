"Library providing general-purpose mutable lists, sets, and 
 maps.
 
 The following interfaces define abstract mutable collection 
 types:
 
 - [[MutableList]] is a mutable [[List]],
 - [[MutableSet]] is a mutable [[Set]], and
 - [[MutableMap]] is a mutable [[Map]].
 
 These interfaces define abstract sorted collection types:
 
 - [[SortedSet]] is a sorted [[Set]], and
 - [[SortedMap]] is a sorted [[Map]].
 
 In addition, dedicated [[Stack]] and [[Queue]] interfaces 
 are defined, representing specialized kinds of lists.
 
 These concrete implementations are provided:
 
 - [[ArrayList]] is a `MutableList` implemented using an
   [[Array]].
 - [[LinkedList]] is a `MutableList` implemented using a
   singly-linked list.
 - [[PriorityQueue]] is a `Queue` implemented using an
   [[Array]] where the front of the queue is the smallest element
 - [[HashSet]] is a mutable hash set implemented using an 
   [[Array]] of singly-linked lists.
 - [[HashMap]] is a mutable hash map implemented using an 
   [[Array]] of singly-linked lists of [[Entry]]s.
 - [[TreeSet]] is a mutable `SortedSet` implemented using a 
   red/black binary tree.
 - [[TreeMap]] is a mutable `SortedMap` implemented using a 
   red/black binary tree.
 
 The functions [[unmodifiableList]], [[unmodifiableSet]],
 and [[unmodifiableMap]] may be used to hide these mutable 
 list, set, and map implementations from clients.
 
 [[SingletonMap]] and [[SingletonSet]] are immutable 
 collections with exactly one element.
 
 Finally, [[IdentitySet]] and [[IdentityMap]] are mutable
 collections based on [[identity|Identifiable]] instead of 
 value equality."

by("Stéphane Épardaud")
license("Apache Software License")
module ceylon.collection "1.2.1" {
}
