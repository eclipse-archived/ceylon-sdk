"This module contains functionality for non-blocking atomic operations.
 
 This functionality is useful only for backends where:
 
 1. the current thread of execution may be preempted by another
 2. the preempted thread shares memory space with the other thread
 
 Since the JavaScript backend does not have these two attributes, this module
 is not applicable to it.
 
 The only element is the [[AtomicReference]] class."
by ("Alex Szczuczko")
license ("Apache Software License")
native ("jvm") module ceylon.concurrency.atomic "1.2.2" {
    import java.base "7";
}
