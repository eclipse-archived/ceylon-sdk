/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
"Support for promises. If an operation cannot return a value 
 immediately without blocking, it may instead return a 
 _promise_ of the value. A promise is an object that 
 represents the return value or the thrown exception that 
 the operation eventually produces. Such an operation is
 sometimes called a _long-running operation_.
 
 This module provides following abstractions:
 
 - The [[Completable]] interface abstracts objects which
   promise one or more values, accommodating the possibility
   of failure.
 - The [[Completion]] interface abstracts `Completable`s that may
   be combined to form a compound promise that produces 
   multiple values.
 - The [[Promise]] class, a `Completable` that produces a 
   single value, or fails.
 - The [[Deferred]] class, providing support for operations
   which return instances of the `Promise` interface.
 - The [[ExecutionContext]] class abstracts the concurrency of the runtime
   running the promises. The JVM runtime uses a threadpool, 
   the JavaScript runtime uses the `setTimeout` function. The
   [[defineGlobalExecutionContext]] can be use to change the default context
 
 ## Promises
 
 A [[Promise]] exists in one of three states:
 
 - In the _promised_ state, the operation has not yet 
   terminated.
 - In the _fulfilled_ state, the operation has produced
   a value.
 - In the _rejected_ state, the operation has terminated 
   without producing a value. This situation is represented
   as an [[exception|Throwable]].
 
 The method [[Promise.completed]] allows interested 
 parties to be notified when the promise makes a 
 transition from the _promised_ state to the _fulfilled_ or 
 the _rejected_ state:
 
     Promise<Document> promise = queryDocumentById(id);
     promise.completed {
         (d) => print(\"Got the document: \" + d.title);
         (e) => print(\"Document was not received: \" + e.message);
     };
 
 The first function is called the `onFulfilled` callback and 
 the second function is called the `onRejected` callback. 
 The `onRejected` function is always optional. 
 
 ## Returning promises
 
 A [[Deferred]] object is a factory that provides an 
 instance of the `Promise` class and manages its lifecycle,
 providing operations to force its transition to a 
 _fulfilled_ or _rejected_ state.
 
 The instance of `Deferred` should remain private to the 
 long-running operation, only the `Promise` should be
 exposed to the caller.

 The `Promise` of a deferred can be retrieved from its 
 [[promise|Deferred.promise]] field:
 
     value deferred = Deferred<String>();
     return deferred.promise;
 
 The `Deferred` object implements the [[Completable]] interface 
 which provides two methods for controlling the state of the 
 promise:
 
 - [[fulfill()|Completable.fulfill]] fulfills the promise with 
   a _value_, and
 - [[reject()|Completable.reject]] rejects the promise with a
   _reason_ of type [[Throwable]].
 
 For example:
 
     value deferred = Deferred<String>();
     void doOperation() {
         try {
             String val = getValue();
             deferred.fulfill(val);
         }
         catch (Throwable e) {
             deferred.reject(e);
         }
     }
 
 ## Chaining promises
 
 When chaining is needed the method [[Completion.map]]
 should be used instead of the [[Completion.completed]]
 method. 
 
 When invoking the [[Completion.map]] method the 
 `onFulfilled` and `onRejected` callbacks can return a value. 
 The `map()` method returns a new promise that will be
 fulfilled with the value of the callback. This promise will 
 be rejected if the callback invocation fails.
 
 For example:
 
     Promise<Integer> promiseOfInteger = newPromiseOfInteger();
     Promise<String> promiseOfString = promiseOfInteger.map(Integer.string);
     promiseOfString.map((s) => print(\"Completed with \" + s));
 
 Or, more concisely:
 
     newPromiseOfInteger()
         .map(Integer.string)
         .map((s) => print(\"Completed with \" + s));
 
 ## Composing promises
 
 Promises can be composed into a single promise that is 
 fulfilled when every one of the individual composed 
 promises is fulfilled. If one of the promise is rejected 
 then the composed promise is rejected.
 
     Promise<String> promiseOfString = newPromiseOfString();
     Promise<Integer> promiseOfInteger = newPromiseOfInteger();
     (promiseOfString.and(promiseOfInteger)).completed {
         (i, s) => print(\"All fulfilled\");
         (e) => print(\"One failed\");
     };
 
 Notice that:
 
 - The order of the parameters in the callback is in reverse 
   order in which the corresponding promises are chained.
 - The return type of combined promise is not [[Promise]] 
   but [[Completion]].
 
 ## The `onComplete()` method
 
 The [[onComplete()|Promise.onComplete]] method of a promise 
 allows a single callback to be notified when the promise is 
 fulfilled or rejected.
 
     Promise<Document> promise = queryDocumentById(id);
     promise.onComplete {
         void (Document|Throwable result) {
             switch (result)
             case (Document) { print(\"Fulfilled\"); }
             case (Throwable) { print(\"Rejected\"); }
         };
      };
 
 [[Promise.onComplete]] is most useful for implementing a finally clause 
 in a chain of promises.
 
 ## Feeding with a promise
 
 [[Deferred]] can be transitioned with a promise instead of a 
 value:
 
     Deferred<String> deferred = getDeferred();
     Promise<String> promise = getPromise();
     deferred.fulfill(promise);
 
 Similarly, with [[Promise.flatMap]], a callback may return a promise
 instead of a value:
 
     Deferred<String> deferred = Deferred<String>();
     Promise<String> promise2 = promise.flatMap((s) => deferred.promise);
 
 ## Thread safety
 
 The implementation is thread safe and uses a non blocking 
 algorithm for maintaining the state of a `Deferred` object.
 
 ## Relationship to the A+ specification
 
 This module is loosely based upon the A+ specification,
 with the following differences:
 
 - The `then()` method is split between [[Completion.map]] that returns
   an object and [[Completion.flatMap]] that can return a Promise
 - The _Promise Resolution Procedure_ is implemented for 
   objects or promises but not for _thenables_ since that 
   would require a language with dynamic typing."
by("Julien Viet")
license("Apache Software License")
module ceylon.promise maven:"org.ceylon-lang" "1.3.4-SNAPSHOT" {
  native("jvm") import java.base "7";
}
