import java.util.concurrent.atomic {
  AtomicReference
}

shared class AtomicRef<Value>(Value val) {
  
  AtomicReference<Value> state = AtomicReference<Value>(val);
  
  shared Value get() => state.get();
  
  shared void set(Value val) {
    state.set(val);
  }

  shared Boolean compareAndSet(Value expect, Value update) => state.compareAndSet(expect, update);
  
}