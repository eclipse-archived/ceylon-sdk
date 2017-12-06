/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
"Completion provides base support for promises and their composition. This interface
 satisfies the [[Promised]] interface, to be used when a [[Promise]] is needed"
by("Julien Viet")
shared interface Completion<out Element, out T>
    satisfies Promised<T>
        given T satisfies Element[] {
    
    "Compose and return a [[Promise]] with map functions"
    shared formal Promise<Result> map<Result>(
      "A function that is called when fulfilled."
      Result(*T) onFulfilled,
      "A function that is called when rejected."
      Result(Throwable) onRejected = rethrow);
    
    "Compose and return a [[Promise]]"
    shared formal Promise<Result> flatMap<Result>(
      "A function that is called when fulfilled."
      Promise<Result>(*T) onFulfilled,
      "A function that is called when rejected."
      Promise<Result>(Throwable) onRejected = rethrow);
    
    "When completion happens, the provided function will be 
     invoked."
    shared default void completed(
      "A function that is called when fulfilled."
      Anything(*T) onFulfilled, 
      "A function that is called when rejected."
      Anything(Throwable) onRejected = rethrow)
        => map(onFulfilled, onRejected);

    "Combine the current completion with a provided promise and 
     return a new completion object that
     
     - fulfills when both the current completion and the other 
       promise are fulfilled, and
     - rejects when either the current completion or the other 
       promise is rejected.
     
     The `Completion`'s promise will be
     
     - fulfilled with a tuple of values of the original 
       promise (it is important to notice that tuple 
       elements are in reverse order of the and chain), or
     - rejected with the reason of the rejected promise.
    
     The `Completion` object allows for promise chaining as a 
     fluent API:
     
         Promise<String> p1 = ...
         Promise<Integer> p2 = ...
         Promise<Boolean> p3 = ...
         p1.and(p2, p3)
           .compose((Boolean b, Integer i, String s) 
                     => doSomething(b, i, s));"
    shared formal 
    Completion<Element|Other,Tuple<Element|Other,Other,T>> 
            and<Other>(Promise<Other> other);

}