import java.util.concurrent.atomic {
    JavaAtomicReference=AtomicReference
}

"Provides atomic/optimistic access to an [[object|current]]."
shared native class AtomicReference<Value>(initial) {
    Value initial;
    
    "Atomic getter/setter for the wrapped object."
    shared native variable Value current;
    
    "Optimistically attempt to set [[a new value|update]] for [[current]],
     given a [[precondition|expect]] that must equal the current value.
     
     If the precondition fails, [[current]] will be unchanged and this function
     will return [[false]]. Otherwise, [[current]] will become [[update]] and
     this function will return [[true]]."
    shared native Boolean swap(Value expect, Value update);
    
    "Atomically set [[current]] to [[a new value|update]], and return the value
     that it was.
     
     This may use optimistic locking, and so could return after an
     unpredictable amount of time if there is contention between threads."
    shared native Value replace(Value update);
    
    "Atomically apply [[a function|updater]] to the value of [[current]] and
     store the result. The previous value is returned.
     
     This uses optimistic locking, and so will return after an unpredictable
     amount of time if there is contention between threads. The [[updater]]
     function will be called once for each attempt."
    shared native Value update(Value(Value) updater);
}

shared native ("js") class AtomicReference<Value>(initial) {
    Value initial;
    
    "Atomic getter/setter for the wrapped object."
    shared native ("js") variable Value current = initial;
    
    "Optimistically attempt to set [[a new value|update]] for [[current]],
     given a [[precondition|expect]] that must equal the current value.
     
     If the precondition fails, [[current]] will be unchanged and this function
     will return [[false]]. Otherwise, [[current]] will become [[update]] and
     this function will return [[true]]."
    shared native ("js") Boolean swap(Value expect, Value update) {
        if (exists c = current) {
            if (exists e = expect, c == e) {
                current = update;
                return true;
            }
        } else if (!expect exists) {
            current = update;
            return true;
        }
        return false;
    }
    
    "Atomically set [[current]] to [[a new value|update]], and return the value
     that it was.
     
     This may use optimistic locking, and so could return after an
     unpredictable amount of time if there is contention between threads."
    shared native ("js") Value replace(Value update) {
        value old = current;
        current = update;
        return old;
    }
    
    "Atomically apply [[a function|updater]] to the value of [[current]] and
     store the result. The previous value is returned.
     
     This uses optimistic locking, and so will return after an unpredictable
     amount of time if there is contention between threads. The [[updater]]
     function will be called once for each attempt."
    shared native ("js") Value update(Value(Value) updater) {
        value old = current;
        current = updater(current);
        return old;
    }
}

"Provides atomic/optimistic access to an [[object|current]]."
shared native ("jvm") class AtomicReference<Value>(initial) {
    Value initial;
    
    // Can't access volatile yet in Ceylon
    value provider = JavaAtomicReference<Value>(initial);
    
    "Atomic getter/setter for the wrapped object."
    shared native ("jvm") Value current => provider.get();
    native ("jvm") assign current => provider.set(current);
    
    "Optimistically attempt to set [[a new value|update]] for [[current]],
     given a [[precondition|expect]] that must equal the current value.
     
     If the precondition fails, [[current]] will be unchanged and this function
     will return [[false]]. Otherwise, [[current]] will become [[update]] and
     this function will return [[true]]."
    shared native ("jvm") Boolean swap(Value expect, Value update) {
        return provider.compareAndSet(expect, update);
    }
    
    "Atomically set [[current]] to [[a new value|update]], and return the value
     that it was.
     
     This may use optimistic locking, and so could return after an
     unpredictable amount of time if there is contention between threads."
    shared native ("jvm") Value replace(Value update) {
        return provider.getAndSet(update);
    }
    
    "Atomically apply [[a function|updater]] to the value of [[current]] and
     store the result. The previous value is returned.
     
     This uses optimistic locking, and so will return after an unpredictable
     amount of time if there is contention between threads. The [[updater]]
     function will be called once for each attempt."
    shared native ("jvm") Value update(Value(Value) updater) {
        variable Value previous = current;
        variable Value next = updater(previous);
        while (!swap(previous, next)) {
            previous = current;
            next = updater(previous);
        }
        return previous;
    }
}
