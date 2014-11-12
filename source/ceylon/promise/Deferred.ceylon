"The deferred class is the primary implementation of the 
 [[Promise]] interface.
  
 The promise is accessible using the `promise` attribute of 
 the deferred.
  
 The deferred can either be fulfilled or rejected via the 
 [[Resolver.fulfill]] or [[Resolver.reject]] methods. Both 
 methods accept an argument or a promise to the argument, 
 allowing the deferred to react on a promise."
by("Julien Viet")
shared class Deferred<Value>() satisfies Resolver<Value> & Promised<Value> {
    
    abstract class State() of ListenerState | PromiseState {}
    
    class PromiseState(shared Promise<Value> promise)  extends State() {}
    
    class ListenerState(onFulfilled, onRejected,
            ListenerState? previous = null)
            extends State() {
        
        Anything(Value) onFulfilled;
        Anything(Throwable) onRejected;
        
        shared void update(Promise<Value> promise) {
            if (exists previous) {
                previous.update(promise);
            }
            promise.compose(onFulfilled, onRejected);
        }
    }
    
    "The current state"
    value state = AtomicRef<State?>(null);
    
    "The promise of this deferred."
    shared actual object promise 
            extends Promise<Value>() {
        
        shared actual Promise<Result> handle<Result>(
                Promise<Result>(Value) onFulfilled, 
                Promise<Result>(Throwable) onRejected) {
                
            value deferred = Deferred<Result>();
            void callback<T>(Promise<Result>(T) on, T val) {
                try {
                    deferred.fulfill(on(val));
                } catch (Throwable e) {
                    deferred.reject(e);
                }
            }
            
            void onFulfilledCallback(Value val)  => callback(onFulfilled, val);
            
            void onRejectedCallback(Throwable reason)  => callback(onRejected, reason);
            
            // 
            while (true) {
                value current = state.get();
                switch (current)
                case (is Null) {
                    State next = ListenerState(onFulfilledCallback, onRejectedCallback);
                    if (state.compareAndSet(current, next)) {
                        break;
                    }
                }
                case (is ListenerState) {
                    State next = ListenerState(onFulfilledCallback, onRejectedCallback, current);
                    if (state.compareAndSet(current, next)) {
                        break;
                    }
                }
                case (is PromiseState) {
                    current.promise.compose(onFulfilledCallback, onRejectedCallback);
                    break;
                }
            }
            return deferred.promise;
        }
    }
        
    void update(Promise<Value> promise) {
        while (true) {
            value current = state.get();    
            switch (current) 
            case (is Null) {
                PromiseState next = PromiseState(promise);	
                if (state.compareAndSet(current, next)) {
                    break;  	
                }
            }
            case (is ListenerState) {
                PromiseState next = PromiseState(promise);	
                if (state.compareAndSet(current, next)) {
                    current.update(promise);
                    break;  	
                }
            }
            case (is PromiseState) {
                break;
            }
        }
    }

    fulfill(Promisable<Value> val)  => update(adaptValue<Value>(val));

    reject(Throwable reason) => update(adaptReason<Value>(reason));
    
}
