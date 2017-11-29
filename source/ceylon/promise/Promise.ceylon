/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
"A promise represents a value that may not be available yet. 
 The primary method for interacting with a promise is its 
 [[map]] method. A promise is a [[Completion]] element
 restricted to a single value."
by("Julien Viet")
shared abstract class Promise<out Value>() 
        satisfies Completion<Value,[Value]> {
    
    "The context of this promise"
    shared formal ExecutionContext context;
    
    // todo optimize that and instead implement a Promise
    variable Conjunction<Value,Value,[]>? conjunction = null;
    
    function conj() {
        if (exists c = conjunction) {
            return c;
        } else {
            value valuePromise = context.fulfilledPromise([]);
            return conjunction = Conjunction(this, valuePromise);
        }
    }
    
    shared formal actual Promise<Result> map<Result>(
      Result onFulfilled(Value val),
      Result onRejected(Throwable reason));

    shared formal actual Promise<Result> flatMap<Result>(
      Promise<Result> onFulfilled(Value val),
      Promise<Result> onRejected(Throwable reason));

    shared actual void completed(
      Anything onFulfilled(Value val), 
      Anything onRejected(Throwable reason)) => map(onFulfilled, onRejected);

    "Callback when the promise is completed with a function that accepts
     either a [[Value]] or a [[Throwable]]."
    shared void onComplete(
      "A function that accepts either the promised value
       or a [[Throwable]] as completion."
      void completed(Value|Throwable completion)) 
        => map(completed, completed);

    shared actual 
    Completion<Value|Other,Tuple<Value|Other,Other,[Value]>> 
            and<Other>(Promise<Other> other) 
            => conj().and(other);
    
    promise => conj().promise;
    
}
