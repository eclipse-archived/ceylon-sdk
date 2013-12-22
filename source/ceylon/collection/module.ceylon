"Library providing general-purpose mutable lists, 
 sets, and maps.
 
 The following interfaces define abstract mutable 
 collection types:
 
 - [[MutableList]]
 - [[MutableSet]]
 - [[MutableMap]]
 
 These concrete implementations are provided:
 
 - [[ArrayList]] is a `MutableList` implemented 
   using an [[Array]].
 - [[LinkedList]] is a `MutableList` implemented 
   using a singly-linked list.
 - [[HashSet]] is a hash set implemented using an
   [[Array]] of singly-linked lists.
 - [[HashMap]] is a hash map implemented using an
   [[Array]] of singly-linked lists of [[Entry]]s.
 
 In addition, dedicated [[Stack]] and [[Queue]]
 interfaces are defined."

by("Stéphane Épardaud")
license("Apache Software License")
module ceylon.collection "1.0.0" {
}
