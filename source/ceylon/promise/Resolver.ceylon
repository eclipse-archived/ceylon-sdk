"Something that can go through a transition and is meant to 
 be be fulfilled or rejected."
by("Julien Viet")
shared interface Resolver<in Value> {

    "Fulfills the promise with a value or a promise to the 
     value."
    shared formal void fulfill(Value|Promise<Value> val);
    
    "Rejects the promise with a reason."
    shared formal void reject(Throwable reason);

    "Either fulfill or reject the promise"
    shared void resolve(Value|Promise<Value>|Throwable val) {
      if (is Value|Promise<Value> val) {
        fulfill(val);
      } else {
        assert(is Throwable val);
        reject(val);
      }
    }
}
