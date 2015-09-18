"Something that can go through a transition and is meant to 
 be be completed, i.e either fulfilled or rejected."
by("Julien Viet")
shared interface Completable<in Value> {

    "Fulfills the promise with a value or a promise to the 
     value."
    shared formal void fulfill(Value|Promise<Value> val);
    
    "Rejects the promise with a reason."
    shared formal void reject(Throwable reason);

    "Complete the promise: either fulfill or reject it"
    shared void complete(Value|Promise<Value>|Throwable val) {
        if (is Value|Promise<Value> val) {
            fulfill(val);
        } else {
            reject(val);
        }
    }
}
