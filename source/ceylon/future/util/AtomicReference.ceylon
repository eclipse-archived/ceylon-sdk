import java.util.concurrent.atomic {
    JavaAtomicReference=AtomicReference
}

"Provides atomic/optimistic access to an [[object|current]], when
 [[full locking|Semaphore]] is not desired."
shared class AtomicReference<Value>(initial) {
    Value initial;
    
    // Can't access volatile yet in Ceylon
    value provider = JavaAtomicReference<Value>(initial);
    
    "Atomic getter/setter for the wrapped object."
    shared Value current => provider.get();
    assign current => provider.set(current);
    
    "Optimistically attempt to set [[a new value|update]] for [[current]],
     given a [[precondition|expect]] that must equal the current value.
     
     If the precondition fails, [[current]] will be unchanged and this function
     will return [[false]]. Otherwise, [[current]] will become [[update]] and
     this function will return [[true]]."
    shared Boolean swap(Value expect, Value update) {
        return provider.compareAndSet(expect, update);
    }
    
    "Atomically set [[current]] to [[a new value|update]], and return the value
     that it was.
     
     This may use optimistic locking, and so could return after an
     unpredictable amount of time if there is contention between threads."
    shared Value replace(Value update) {
        return provider.getAndSet(update);
    }
    
    "Atomically apply [[a function|updater]] to the value of [[current]] and
     store the result. The previous value is returned.
     
     This uses optimistic locking, and so will return after an unpredictable
     amount of time if there is contention between threads. The [[updater]]
     function will be called once for each attempt."
    shared Value update(Value(Value) updater) {
        variable Value previous = current;
        variable Value next = updater(previous);
        while (!swap(previous, next)) {
            previous = current;
            next = updater(previous);
        }
        return previous;
    }
}
