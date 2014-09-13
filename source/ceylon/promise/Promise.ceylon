import java.util.concurrent {
    CountDownLatch,
    TimeUnit {
        seconds=MILLISECONDS
    }
}
import java.util.concurrent.atomic {
    AtomicReference
}
 
"A promise represents a value that may not be available yet. The primary method for
  interacting with a promise is its [[compose]] method. A promise is a [[Completable]] element
 restricted to a single value."
by("Julien Viet")
shared abstract class Promise<out Value>() satisfies Term<Value, [Value]> {

    // todo optimize that and instead implement a Promise
    variable Conjunction<Value, Value, []>? c = null;
    
    Conjunction<Value, Value, []> conj() {
        if (exists tmp = c) {
            return tmp;
        } else {
            value d = Deferred<[]>();
            d.fulfill([]);
            return c = Conjunction<Value, Value, []>(this, d.promise);
        }
    }
    
    shared actual Term<Value|Other, Tuple<Value|Other, Other, [Value]>> and<Other>(Promise<Other> other) {
        return conj().and(other);
    }
    
    shared actual Promise<[Value]> promise {
        return conj().promise;
    }

    "Create and return a future for this promise. The future allows to follow the resolution of the
       promise in a *blocking* fashion:
       
       - if this promise is fulfilled then the future will return the value
       - if this promise is rejected then the future will return the reason
       
       This class should be used when a thread needs to block until this promise is resolved only, i.e
       it defeats the purpose of the promise programming model."
    shared Future<Value> future {
        object f satisfies Future<Value> {
            
            CountDownLatch latch = CountDownLatch(1);
            AtomicReference<Value|Throwable> ref = AtomicReference<Value|Throwable>();
            
            void reportReason(Throwable e) {
                ref.set(e);
                latch.countDown(); 
            }
            
            void reportValue(Value t) {
                ref.set(t);
                latch.countDown();
            }
            
            outer.compose(reportValue, reportReason);
            
            shared actual <Value|Throwable>? peek() => ref.get();
            
            shared actual Value|Throwable get(Integer timeOut) {
                if (timeOut < 0) {
                    latch.await();
                } else {
                    if (!latch.await(timeOut, seconds)) {
                        throw Exception("Timed out waiting for :" + outer.string);
                    }
                }
                return ref.get();
            }
        }
        return f;
    }

}
