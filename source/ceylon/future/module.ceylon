"This module enables JVM thread concurrency, such that the most common use
 cases can be accomplished in a relatively error-free way. For advanced
 threading, use Java directly.
 
 The primary class is [[BlockingPromise]], which extends the multi-platform
 `Promise` from `ceylon.promise`. Typically [[BlockingPromise]]s are created by
 a call to [[submit]], which will start the given callable running in a thread
 pool before returning the [[BlockingPromise]]. You can then call
 [[BlockingPromise.result]] to block until the callable completes.
 
 Basic synchronization classes and a sleep function are also provided."
by ("Alex Szczuczko")
license ("Apache Software License")
native ("jvm") module ceylon.future "1.2.1" {
    import java.base "7";
    shared import ceylon.promise "1.2.1";
}
