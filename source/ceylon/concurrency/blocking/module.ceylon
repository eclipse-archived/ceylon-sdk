"This module contains functionality for blocking operations.
 
 This functionality is only useful for backends where there are multiple
 threads of execution. So, this module is not applicable to the JavaScript
 backend (see [[module ceylon.promise]] instead).
 
 The primary class is [[BlockingPromise]]. Typically [[BlockingPromise]]s are
 created by a call to [[submit]], which will start the given callable running
 in a thread pool before returning the [[BlockingPromise]]. You can then call
 [[BlockingPromise.result]] to block until the callable completes.
 
 Basic synchronization classes and a sleep function are also provided."
by ("Alex Szczuczko")
license ("Apache Software License")
native ("jvm") module ceylon.concurrency.blocking "1.2.2" {
    import java.base "7";
    import ceylon.concurrency.atomic "1.2.2";
    shared import ceylon.promise "1.2.1";
}
