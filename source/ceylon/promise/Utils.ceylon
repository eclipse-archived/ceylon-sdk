Promise<Result>(Throwable) adaptOnRejected<Result>(<Result|Promise<Result>>(Throwable) onRejected) {
    if (is Promise<Result>(Throwable) onRejected) {
        return onRejected;
    } else {
        assert (is Result(Throwable) onRejected);
        return adaptResult<Result,[Throwable]>(onRejected);
    }
}

Callable<Promise<Result>,Value> adaptOnFulfilled<Result,Value>(Callable<Result|Promise<Result>,Value> onFulfilled)
        given Value satisfies Anything[] {
    if (is Callable<Promise<Result>,Value> onFulfilled) {
        return onFulfilled;
    } else {
        assert (is Callable<Result,Value> onFulfilled);
        return adaptResult<Result,Value>(onFulfilled);
    }
}

"Adapt an instance of `Callable<Result,Value>` to 
 `Callable<Promise<Result>,Value>`"
by("Julien Viet")
Callable<Promise<Result>,Value> adaptResult<Result,Value>(Callable<Result,Value> a) 
        given Value satisfies Anything[] {
    value b = unflatten(a);
    function c(Value d) {
        value deferred = Deferred<Result>();
        deferred.fulfill(b(d));
        return deferred.promise;	
    }
    return flatten(c);
}

by("Julien Viet")
Promise<T> adaptValue<T>(T|Promise<T> val) {
    if (is T val) {
        object adapter extends Promise<T>() {
            shared actual Promise<Result> handle<Result>(
                Promise<Result>(T) onFulfilled,
                Promise<Result>(Throwable) onRejected) {
                try {
                    return onFulfilled(val);
                } catch(Throwable e) {
                    return adaptReason<Result>(e);
                }
            }
        }
        return adapter;
    } else {
        return val;
    }
}

by("Julien Viet")
Promise<T> adaptReason<T>(Throwable reason) {
    object adapted extends Promise<T>() {
        shared actual Promise<Result> handle<Result>(
            Promise<Result>(T) onFulfilled,
            Promise<Result>(Throwable) onRejected) {
            try {
                return onRejected(reason);
            } catch(Throwable e) {
                return adaptReason<Result>(e);
            }
        }
    }
    return adapted;
}

Nothing rethrow(Throwable e) {
    throw e;
}
