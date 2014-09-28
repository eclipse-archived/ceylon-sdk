"Something that can go through a transition and is meant to 
 be be fulfilled or rejected."
by("Julien Viet")
shared interface Resolver<in Value> {

    "Fulfills the promise with a value or a promise to the 
     value."
    shared formal void fulfill(Promisable<Value> val);
    
    "Rejects the promise with a reason."
    shared formal void reject(Throwable reason);

}
