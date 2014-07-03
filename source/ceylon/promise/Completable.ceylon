"Completable provides the base support for promise. This interface satisfies the
 [[Promised]] interface, to be used when a promise is needed instead of a [[Completable]]"
by("Julien Viet")
shared interface Completable<out Value>
        satisfies Promised<Value>
            given Value satisfies Anything[] {

    M rethrow<M>(Throwable e) {
        throw e;
    }
    
    "When completion happens, the provided function will be invoked."
    shared void onComplete(Callable<Anything, Value> onFulfilled, Anything(Throwable) onRejected = rethrow<Anything>) {
        compose(onFulfilled, onRejected);
    }

	"Compose with a function that accepts either a *Value* or a *Throwable*."
    shared Promise<Result> always<Result>(Callable<Result, Value|[Throwable]> callback) {
        return compose(callback, callback);
    }
    
    "Compose and return a [[Promise]]"
    shared Promise<Result> compose<Result>(
        <Callable<<Result|Promise<Result>>, Value>> onFulfilled,
        <<Result|Promise<Result>>(Throwable)> onRejected = rethrow<Result>) {
        
        Callable<Promise<Result>, Value> onFulfilled2;
        if (is Callable<Promise<Result>, Value> onFulfilled) {
            onFulfilled2 = onFulfilled;
        } else if (is Callable<Result, Value> onFulfilled) {
            onFulfilled2 = adaptResult<Result, Value>(onFulfilled);
        } else {
            throw Exception("Does not make sense");
        }
        
        Promise<Result>(Throwable) onRejected2;
        if (is Promise<Result>(Throwable) onRejected) {
            onRejected2 = onRejected;
        } else if (is Result(Throwable) onRejected) {
            onRejected2 = adaptResult<Result, [Throwable]>(onRejected);
        } else {
            throw Exception("Does not make sense");
        }
        
        return handle(onFulfilled2, onRejected2); 
    }

    shared formal Promise<Result> handle<Result>(
            <Callable<Promise<Result>, Value>> onFulfilled,
            <Promise<Result>(Throwable)> onRejected);

}
