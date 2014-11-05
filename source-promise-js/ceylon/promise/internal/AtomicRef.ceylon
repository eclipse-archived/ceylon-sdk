shared class AtomicRef<Value>(Value val) {
  
  variable Value state = val;
  
  shared Value get() => state;
  
  shared void set(Value val) {
    state = val;
  }
  
  shared Boolean compareAndSet(Value expect, Value update) {
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