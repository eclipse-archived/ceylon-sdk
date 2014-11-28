by("Julien Viet")
shared interface Context {
  
  shared Callable<Promise<Result>,Value> adaptResult<Result,Value>(Callable<Result,Value> a) 
      given Value satisfies Anything[] {
    value b = unflatten(a);
    function c(Value d) {
      value deferred = Deferred<Result>(this);
      deferred.fulfill(b(d));
      return deferred.promise;	
    }
    return flatten(c);
  }
  
  shared Promise<T> adaptValue<T>(T val) {
    object adapter extends Promise<T>() {

      shared actual Context context => outer;
      
      shared actual Promise<Result> compose<Result>(Result(T) onFulfilled, Result(Throwable) onRejected) {
        try {
          return adaptValue(onFulfilled(val));
        } catch(Throwable e) {
          return adaptReason<Result>(e);
        }
      }
      shared actual Promise<Result> flatMap<Result>(
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
  }
  
  by("Julien Viet")
  shared Promise<T> adaptReason<T>(Throwable reason) {
    object adapted extends Promise<T>() {
      
      shared actual Context context => outer;
      
      shared actual Promise<Result> compose<Result>(Result(T) onFulfilled, Result(Throwable) onRejected) {
        try {
          return adaptValue(onRejected(reason));
        } catch(Throwable e) {
          return adaptReason<Result>(e);
        }
      }
      
      shared actual Promise<Result> flatMap<Result>(
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

  shared formal void run(void task());
  
  shared formal Context childContext();
  
}