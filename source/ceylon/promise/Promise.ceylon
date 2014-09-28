import java.util.concurrent {
    CountDownLatch,
    TimeUnit {
        seconds=MILLISECONDS
    }
}
import java.util.concurrent.atomic {
    AtomicReference
}

"A promise represents a value that may not be available yet. 
 The primary method for interacting with a promise is its 
 [[compose]] method. A promise is a [[Completable]] element
 restricted to a single value."
by("Julien Viet")
shared abstract class Promise<out Value>() 
        satisfies Term<Value,[Value]> {
    
    // todo optimize that and instead implement a Promise
    variable Conjunction<Value,Value,[]>? conjunction = null;
    
    function conj() {
        if (exists c = conjunction) {
            return c;
        } else {
            value d = Deferred<[]>();
            d.fulfill([]);
            return conjunction = 
                    Conjunction(this, d.promise);
        }
    }
    
    shared actual 
    Term<Value|Other,Tuple<Value|Other,Other,[Value]>> 
            and<Other>(Promise<Other> other) 
            => conj().and(other);
    
    promise => conj().promise;
    
    "Create and return a future for this promise. The future 
     allows to follow the resolution of the promise in a 
     *blocking* fashion:
     
     - if this promise is fulfilled then the future will 
       return the value, or
     - if this promise is rejected then the future will 
       return the reason.
     
     This class should be used when a thread needs to block 
     until this promise is resolved only, i.e it defeats the 
     purpose of the promise programming model."
    shared Future<Value> future {
        object future satisfies Future<Value> {
            
            value latch = CountDownLatch(1);
            value ref = AtomicReference<Value|Throwable>();
            
            void reportReason(Throwable e) {
                ref.set(e);
                latch.countDown(); 
            }
            
            void reportValue(Value t) {
                ref.set(t);
                latch.countDown();
            }
            
            outer.compose(reportValue, reportReason);
            
            peek() => ref.get();
            
            shared actual Value|Throwable get(Integer timeOut) {
                if (timeOut < 0) {
                    latch.await();
                } else {
                    if (!latch.await(timeOut, seconds)) {
                        throw Exception("Timed out waiting for :" 
                            + outer.string);
                    }
                }
                return ref.get();
            }
            
        }
        return future;
    }
    
}
