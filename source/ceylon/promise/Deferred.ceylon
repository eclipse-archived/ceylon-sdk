/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
import ceylon.promise.internal { AtomicRef }

"The deferred class is the primary implementation of the 
 [[Promise]] interface.
  
 The promise is accessible using the `promise` attribute of 
 the deferred.
  
 The deferred can either be fulfilled or rejected via the 
 [[Completable.fulfill]] or [[Completable.reject]] methods. Both 
 methods accept an argument or a promise to the argument, 
 allowing the deferred to react on a promise."
by("Julien Viet")
shared class Deferred<Value>(context = globalExecutionContext) 
        satisfies Completable<Value> 
                & Promised<Value> {
    
    abstract class State() of ListenerState | PromiseState {}
    
    class PromiseState(shared Promise<Value> promise)
            extends State() {}
    
    class ListenerState(onFulfilled, onRejected,
            ListenerState? previous = null)
            extends State() {
        
        Anything(Value) onFulfilled;
        Anything(Throwable) onRejected;
        
        shared void update(Promise<Value> promise) {
            if (exists previous) {
                previous.update(promise);
            }
            promise.map(onFulfilled, onRejected);
        }
    }
    
    "The current context"
    ExecutionContext context;
    
    "The current state"
    value state = AtomicRef<State?>(null);
    
    "The promise of this deferred."
    shared actual object promise 
            extends Promise<Value>() {
        
        context => outer.context;

        shared actual Promise<Result> map<Result>(
                Result(Value) onFulfilled,
                Result(Throwable) onRejected) {
          
          ExecutionListener[] listeners = currentExecutionListeners.get();
          Anything(Anything())[] wrappers;
          if (!listeners.empty) {
              wrappers = [ *
                  listeners.map((ExecutionListener listener) => listener.onChild())
              ];
          } else {
              wrappers =[];
          }
          
          value childContext = context.childContext();
          value deferred = Deferred<Result>(childContext);
          void callback<T>(Result(T) on, T val) {
            
              variable Anything() task 
                    = () {
                  Result t;
                  try {
                      t = on(val);
                  } catch (Throwable e) {
                      deferred.reject(e);
                      return;
                  }
                  deferred.fulfill(t);
              };
              
              if (!listeners.empty) {
                  for (wrapper in wrappers) {
                      Anything() f = task;
                      task = void() {
                        wrapper(f);
                      };
                  }
              }
            
              context.run(task);
          }
          
          foobar {
            void onFulfilledCallback(Value val)
                    => callback(onFulfilled, val);
            void onRejectedCallback(Throwable reason)
                    => callback(onRejected, reason);
          };
          
          // 
          return deferred.promise;
        }

        shared actual Promise<Result> flatMap<Result>(
                Promise<Result>(Value) onFulfilled, 
                Promise<Result>(Throwable) onRejected) {
            
            ExecutionListener[] listeners = currentExecutionListeners.get();
            Anything(Anything())[] wrappers;
            if (!listeners.empty) {
              wrappers = [ *
                  listeners.map((ExecutionListener listener) => listener.onChild())
              ];
            } else {
              wrappers =[];
            }

            value childContext = context.childContext();
            value deferred = Deferred<Result>(childContext);
            void callback<T>(Promise<Result>(T) on, T val) {
              
                variable Anything() task = void () {
                    Promise<Result> t;
                    try {
                        t = on(val);
                    } catch (Throwable e) {
                        deferred.reject(e);
                        return;
                    }
                    deferred.fulfill(t);
                };
              
                if (!listeners.empty) {
                    for (wrapper in wrappers) {
                        Anything() f = task;
                        task = void() {
                           wrapper(f);
                        };
                    }
                }

                context.run(task);
            }
            
            foobar {
              void onFulfilledCallback(Value val)
                      => callback(onFulfilled, val);
              void onRejectedCallback(Throwable reason)
                      => callback(onRejected, reason);
            };
            
            // 
            return deferred.promise;
        }

        void foobar(void onFulfilledCallback(Value val), 
            void onRejectedCallback(Throwable reason)) {
            while (true) {
                value current = state.get();
                switch (current)
                case (Null) {
                    State next = ListenerState(onFulfilledCallback, 
                        onRejectedCallback);
                    if (state.compareAndSet(current, next)) {
                        break;
                    }
                }
                case (ListenerState) {
                    State next = ListenerState(onFulfilledCallback, 
                        onRejectedCallback, current);
                    if (state.compareAndSet(current, next)) {
                        break;
                    }
                }
                case (PromiseState) {
                    current.promise.map(onFulfilledCallback, 
                        onRejectedCallback);
                    break;
                }
            }
        }
        
    }
        
    void update(Promise<Value> promise) {
        while (true) {
            value current = state.get();    
            switch (current) 
            case (Null) {
                PromiseState next = PromiseState(promise);	
                if (state.compareAndSet(current, next)) {
                    break;  	
                }
            }
            case (ListenerState) {
                PromiseState next = PromiseState(promise);	
                if (state.compareAndSet(current, next)) {
                    current.update(promise);
                    break;  	
                }
            }
            case (PromiseState) {
                break;
            }
        }
    }

    shared actual void fulfill(Value|Promise<Value> val) {
        if (is Promise<Value> val) {
            update(val);        
        } else {
            update(context.fulfilledPromise<Value>(val));       
        }
    }

    reject(Throwable reason) 
            => update(context.rejectedPromise<Value>(reason));
    
}
