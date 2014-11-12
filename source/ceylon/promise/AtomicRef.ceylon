import java.util.concurrent.atomic {
  AtomicReference
}

class AtomicRef<Value>(Value val) {
  
  AtomicReference<Value> state = AtomicReference<Value>(val);
  
  shared Value get() => state.get();
  
  shared Boolean compareAndSet(Value expect, Value update) => state.compareAndSet(expect, update);
  
}