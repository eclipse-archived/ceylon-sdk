import ceylon.future.util {
    Latch,
    AcquireTimeoutException
}
import ceylon.promise {
    Promise,
    ExecutionContext
}

"Wraps a [[Promise]] that will be completed by another thread."
see (`function submit`)
shared class Future<Value>(delegate)
        extends Promise<Value>() {
    "The concurrently completed [[Promise]]."
    Promise<Value> delegate;
    
    /*
     * Delegation
     */
    
    shared actual ExecutionContext context => delegate.context;
    
    shared actual Promise<Result> map<Result>(
        Result onFulfilled(Value val),
        Result onRejected(Throwable reason))
            => delegate.map(onFulfilled, onRejected);
    
    shared actual Promise<Result> flatMap<Result>(
        Promise<Result> onFulfilled(Value val),
        Promise<Result> onRejected(Throwable reason))
            => delegate.flatMap(onFulfilled, onRejected);
    
    /*
     * New functionality
     */
    
    value completion = Latch();
    
    variable Boolean _done = false;
    "[[true]] if the [[delegate]] is completed."
    shared Boolean done => _done;
    
    variable Value? resultValue = null;
    variable Throwable? resultException = null;
    
    delegate.completed {
        void onFulfilled(Value val) {
            resultValue = val;
            _done = true;
            completion.ratchet();
        }
        void onRejected(Throwable reason) {
            resultException = reason;
            _done = true;
            completion.ratchet();
        }
    };
    
    "Get the fulfilled value of the [[delegate]]. Blocks until the [[delegate]]
     is completed."
    throws (`class AcquireTimeoutException`,
        "If [[timeout]] elapses before the [[delegate]] is completed")
    throws (`class Throwable`,
        "From the [[delegate]] if it is rejected")
    shared Value result(timeout = 0) {
        "The maximum milliseconds to allow before throwing a
         [[AcquireTimeoutException]]. Must be at least 1 to have effect."
        Integer timeout;
        
        completion.wait(timeout);
        if (exists e = resultException) {
            throw e;
        } else {
            // Don't use `exists v` since Value could include Null
            assert (is Value v = resultValue);
            return v;
        }
    }
    
    "Get the rejected value of the [[delegate]], or [[null]] if not rejected.
     Blocks until the [[delegate]] is completed."
    throws (`class AcquireTimeoutException`,
        "If [[timeout]] elapses before the [[delegate]] is completed")
    shared Throwable? exception(timeout = 0) {
        "The maximum milliseconds to allow before throwing a
         [[AcquireTimeoutException]]. Must be at least 1 to have effect."
        Integer timeout;
        
        completion.wait(timeout);
        return resultException;
    }
}
