"A module that provides Promise for the Ceylon language.

 The modules provides:

 - the [[Completable]] interface forming the ground of promise, implemented primarily by the [[Promise]] interface.
 - the [[Promise]] interface, a promise is a [[Completable]] for a single value.
 - the [[Deferred]] type providing support for the [[Promise]] interface.
 - the [[Term]] interface for combining promises into a conjonction promise.

 # Goal
 
 If a function cannot return a value or throw an exception without blocking, it can return a promise instead.
 A promise is an object that represents the return value or the thrown exception that the function may eventually
 provide. A promise can also be used as a proxy for a remote object to overcome latency.
 
 # Usage
 
 ## Promise
 
 The [[Promise]] interface expose the `onComplete` method allowing interested parties to be notified when the promise makes
 a transition to the *fulfilled* or the *rejected* status:
 
     Promise<String> promise = getPromise();
     promise.onComplete(
         (String s) => print(\"The promise is fulfilled with \" + s),
         (Throwable e) => print(\"The promise is rejected with \" + e.message));
 
 The first function is called the `onFulfilled` callback and the second function is called the `onRejected` callback. The 
 `onRejected` function is optional. 
 
 ## Deferred
 
 A [[Deferred]] object provides an implementation of the [[Promise]] interface and can be transitionned to a fulfillment
 or a reject resolution. It should remain private to the part of the code using it and only its promise should be visible.

 The [[Promise]] of a deferred can be retrieved with its `promise` field.
 
     value deferred = Deferred<String>();
     return deferred.promise;
 
 The [[Deferred]] object implements the [[Resolver]] interface which provides two methods for resolving the promise:
 
 - `fulfill`: fulfill the promise with a *value*
 - `reject`: rejects the promise with an *reason* of type `Throwable`
 
 For example:
 
     value deferred = Deferred<String>();
     void doOperation() {
       try {
         String val = getValue();
         deferred.fulfill(val);
       }
       catch(Throwable e) {
         deferred.reject(e);
       }
     }
 
 ## Chaining promises
 
 When composition is needed the [[Completable.compose]] method should be used instead of the [[Completable.onComplete]]
 method. 
 
 When invoking the [[Completable.compose]] method the *onFulfilled* and *onRejected* callbacks can return a value. The
 [[Completable.compose] method returns a new promise that will be fulfilled with the value of the callback. This promise will
 be rejected if the callback invocation fails.
 
     Promise<Integer> promiseOfInteger = getPromiseOfInteger();
     Promise<String> promiseOfString = promiseOfInteger.compose((Integer i) => i.string);
     promiseOfString.compose((String s) => print(\"Completed with \" + s));
 
 or shorter
 
     getPromiseOfInteger().compose((Integer i) => i.string).compose((String s) => print(\"Completed with \" + s));
 
 ## Composing promises
 
 Promises can be combined into a single promise that is fulfilled when all the combined promises are fulfilled. If one
 of the promise is rejected then the combined promise is rejected.
 
     Promise<String> promiseOfInteger = getPromiseOfString();
     Promise<Integer> promiseOfString = getPromiseOfInteger();
     promiseOfInteger.and(promiseOfString).compose(
         (Integer i, String s) => print(\"All fulfilled\"),
         (Throwable e) => print(\"One failed\"));
 
 There are noticeable two things here:
 - the order of the arguments in the callback is in reverse order of the chaining.
 - the return type of combined promise is not [[Promise]] but [[Completable]].
 
 ## Always
 
 The `always` method of a promise allows to be notified when the promise is fulfilled or rejected, it takes as argument
 of the callback an alternative of the promise value type and reason type:
 
     promise.always((String|Throwable) p => print(\"done!\");
 
 Always is useful for implementing a finally clause in a chain of promise.
 
 ## Feeding with a promise
 
 Deferred can be transitionned with a promise instead of a value:
 
     Deferred<String> deferred1 = getDeferred1();
     Deferred<String> deferred2 = getDeferred2();
     deferred1.fulfill(deferred2);
 
 Similarly the callback can return a promise instead of a value:
 
     Deferred<String> deferred = Deferred<String>();
     promise.compose((String s) => deferred.promise);
 
 ## Future
 
 Sometimes it is convenient to block until a promise is resolved, for this purpose a promise can be turned
 into a [[Future]] via its future:
 
     Promise<String> promise = getPromise();
     Future<String|Throwable> future = promise.future();
     String|Throwable resolution = future.get(10000);
 
 Keep in mind that this is not the way you should use promises as this defeats the non blocking model. Nevertheless
 can be useful to block (for instance: unit testing purposes).
 
 ## Thread safety
 
 The implementation is thread safe and use non blocking algorithm for maintaining the state of
 a deferred object.
 
 # Differences with the A+ specification:

 - the *then* method is named *compose* in Ceylon
 - the *then must return before onFulfilled or onRejected is called* is not implemented, therefore the invocation
 occurs inside the invocation of then.
 - the *Promise Resolution Procedure* is implemented for objects or promises but not for *thenable* as it requires
 a language with dynamic typing."
by("Julien Viet")
license("ASL2")
module ceylon.promise "1.1.0" {
  import java.base "7";
}
