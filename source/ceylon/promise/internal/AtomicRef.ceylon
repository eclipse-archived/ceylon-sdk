import java.util.concurrent.atomic {
  AtomicReference
}

native
shared class AtomicRef<Value>(Value val) {
    native shared Value get();
    native shared void set(Value val);
    native shared Boolean compareAndSet(Value expect, Value update);
}

native("jvm")
shared class AtomicRef<Value>(Value val) {
  
  AtomicReference<Value> state = AtomicReference<Value>(val);
  
  native("jvm") shared Value get() => state.get();
  
  native("jvm") shared void set(Value val) {
    state.set(val);
  }

  native("jvm") shared Boolean compareAndSet(Value expect, Value update) => state.compareAndSet(expect, update);
  
}

native("js")
shared class AtomicRef<Value>(Value val) {
    
    variable Value state = val;
    
    native("js") shared Value get() => state;
    
    native("js") shared void set(Value val) {
        state = val;
    }
    
    native("js") shared Boolean compareAndSet(Value expect, Value update) {
        if (exists expect) {
            if (exists s = state, expect == s) {
                state = update;
                return true;
            }
        } else if (is Null s = state) {
            state = update;
            return true;
        }
        return false;
    }
}