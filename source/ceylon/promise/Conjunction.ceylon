/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
"Combines two [[promises|Promise]] into a new promise.
 
 The new promise is
 
 - fulfilled when both promises are fulfilled, or
 - rejected when either of the two promises is rejected."
by("Julien Viet")
class Conjunction<out Element, out First, Rest>(first, rest)
        satisfies Completion<Element,Tuple<First|Element,First,Rest>>
        given First satisfies Element
        given Rest satisfies Sequential<Element> {
    
    "The first promise."
    Promise<Rest> rest;
    
    "The second promise."
    Promise<First> first;

    // We use the context of the first
    value deferred 
            = Deferred<Tuple<First|Element,First,Rest>>
                    (first.context);
    promise = deferred.promise;
    
    variable First? firstVal = null;
    variable Rest? restVal = null;

    void check() {
        if (exists first = firstVal, exists rest = restVal) {
            deferred.fulfill(Tuple(first, rest));
        }
    }
    
    void onReject(Throwable e) {
        deferred.reject(e);
    }
    
    void onRestFulfilled(Rest val) {
        restVal = val;
        check();
    }
    rest.map(onRestFulfilled, onReject);
    
    void onFirstFulfilled(First val) {
        firstVal = val;
        check();
    }
    first.map(onFirstFulfilled, onReject);

    shared actual 
    Completion<Element|Other,Tuple<Element|Other,Other,Tuple<First|Element,First,Rest>>> 
            and<Other>(Promise<Other> other) 
            => Conjunction(other, promise);

    shared actual Promise<Result> map<Result>(
            Result(*Tuple<First|Element,First,Rest>) onFulfilled, 
            Result(Throwable) onRejected)
            => promise.map {
        (Tuple<First|Element,First,Rest> args) 
                => unflatten(onFulfilled)(args);
        onRejected;
    };

    shared actual Promise<Result> flatMap<Result>(
            Promise<Result>(*Tuple<First|Element,First,Rest>) onFulfilled,
            Promise<Result>(Throwable) onRejected) 
            => promise.flatMap {
        (Tuple<First|Element,First,Rest> args) 
                => unflatten(onFulfilled)(args);
        onRejected;
    };
    

}
