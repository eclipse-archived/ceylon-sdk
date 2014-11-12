"Completable provides the base support for promises. This 
 interface satisfies the [[Promised]] interface, to be used 
 when a [[Promise]] is needed."
by("Julien Viet")
shared interface Completable<out Value> satisfies Promised<Value>
            given Value satisfies Anything[] {
    
    "When completion happens, the provided function will be 
     invoked."
    shared void onComplete(
        "A function that is called when fulfilled."
        Callable<Anything,Value> onFulfilled, 
        "A function that is called when rejected."
        Anything(Throwable) onRejected = rethrow)
            => compose(onFulfilled, onRejected);
    
    "Compose with a function that accepts either a [[Value]] 
     or a [[Throwable]]."
    shared Promise<Result> always<Result>(
        "A function that accepts either the promised value
         or a [[Throwable]]."
        Callable<Result,Value|[Throwable]> callback) 
            => compose(callback, callback);
    
    "Compose and return a [[Promise]]"
    shared Promise<Result> compose<Result>(
        "A function that is called when fulfilled."
        Callable<Promisable<Result>,Value> onFulfilled,
        "A function that is called when rejected."
        Promisable<Result>(Throwable) onRejected = rethrow)
            => handle(
                adaptOnFulfilled<Result,Value>(onFulfilled),
                adaptOnRejected<Result>(onRejected)
          );

    shared formal Promise<Result> handle<Result>(
            Callable<Promise<Result>,Value> onFulfilled,
            Promise<Result>(Throwable) onRejected);

}
