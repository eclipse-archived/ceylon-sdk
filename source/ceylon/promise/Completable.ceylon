"Completable provides the base support for promises. This 
 interface satisfies the [[Promised]] interface, to be used 
 when a [[Promise]] is needed."
by("Julien Viet")
shared interface Completable<out Value> 
        satisfies Promised<Value>
        given Value satisfies Anything[] {
    
    "When completion happens, the provided function will be 
     invoked."
    shared void done(
        "A function that is called when fulfilled."
        Anything(*Value) onFulfilled, 
        "A function that is called when rejected."
        Anything(Throwable) onRejected = rethrow)
            => map(onFulfilled, onRejected);
    
    "Compose and return a [[Promise]] with map functions"
    shared formal Promise<Result> map<Result>(
        "A function that is called when fulfilled."
        Result(*Value) onFulfilled,
        "A function that is called when rejected."
        Result(Throwable) onRejected = rethrow);
    
    "Compose and return a [[Promise]]"
    shared formal Promise<Result> flatMap<Result>(
        "A function that is called when fulfilled."
        Promise<Result>(*Value) onFulfilled,
        "A function that is called when rejected."
        Promise<Result>(Throwable) onRejected = rethrow);
    
    "Callback when the promise is completed with a function that accepts
     either a [[Value]] or a [[Throwable]]."
    shared Promise<Result> onComplete<Result>(
      "A function that accepts either the promised value
       or a [[Throwable]]."
      Result(*Value|[Throwable]) callback) 
        => map(callback, callback);
    
}
