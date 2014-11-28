"""The execution context"""
by("Julien Viet")
shared interface ExecutionContext {
  
  """Create a new deferred running on this context"""
  shared Deferred<Value> deferred<Value>() {
    return Deferred<Value>(this);
  }
  
  """Create a new fulfilled promise running on this context"""
  shared Promise<T> fulfilledPromise<T>(T val) {
    object adapter extends Promise<T>() {

      shared actual ExecutionContext context => outer;
      
      shared actual Promise<Result> compose<Result>(Result(T) onFulfilled, Result(Throwable) onRejected) {
        try {
          return fulfilledPromise(onFulfilled(val));
        } catch(Throwable e) {
          return rejectedPromise<Result>(e);
        }
      }
      shared actual Promise<Result> flatMap<Result>(
        Promise<Result>(T) onFulfilled,
        Promise<Result>(Throwable) onRejected) {
        try {
          return onFulfilled(val);
        } catch(Throwable e) {
          return rejectedPromise<Result>(e);
        }
      }
    }
    return adapter;
  }
  
  """Create a new rejected promise running on this context"""
  shared Promise<T> rejectedPromise<T>(Throwable reason) {
    object adapted extends Promise<T>() {
      
      shared actual ExecutionContext context => outer;
      
      shared actual Promise<Result> compose<Result>(Result(T) onFulfilled, Result(Throwable) onRejected) {
        try {
          return fulfilledPromise(onRejected(reason));
        } catch(Throwable e) {
          return rejectedPromise<Result>(e);
        }
      }
      
      shared actual Promise<Result> flatMap<Result>(
        Promise<Result>(T) onFulfilled,
        Promise<Result>(Throwable) onRejected) {
        try {
          return onRejected(reason);
        } catch(Throwable e) {
          return rejectedPromise<Result>(e);
        }
      }
    }
    return adapted;
  }

  shared formal void run(void task());
  
  shared formal ExecutionContext childContext();
  
}