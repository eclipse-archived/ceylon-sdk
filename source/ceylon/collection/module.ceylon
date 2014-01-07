"Library providing general-purpose mutable lists, 
 sets, and maps.
 
 The following interfaces define abstract mutable 
 collection types:
 
 - [[MutableList]] is a mutable [[List]],
 - [[MutableSet]] is a mutable [[Set]], and
 - [[MutableMap]] is a mutable [[Map]].
 
 These concrete implementations are provided:
 
 - [[ArrayList]] is a `MutableList` implemented 
   using an [[Array]].
 - [[LinkedList]] is a `MutableList` implemented 
   using a singly-linked list.
 - [[HashSet]] is a hash set implemented using an
   [[Array]] of singly-linked lists.
 - [[HashMap]] is a hash map implemented using an
   [[Array]] of singly-linked lists of [[Entry]]s.
 
 The classes [[ImmutableList]], [[ImmutableSet]],
 and [[ImmutableMap]] may be used to hide these
 mutable list, set, and map implementations from 
 clients. 
 
 In addition, dedicated [[Stack]] and [[Queue]]
 interfaces are defined, representing specialized
 kinds of lists.
 
 Finally, [[IdentitySet]] and [[IdentityMap]] are
 provided."

by("Stéphane Épardaud")
license("Apache Software License")
module ceylon.collection "1.0.0" {
}
