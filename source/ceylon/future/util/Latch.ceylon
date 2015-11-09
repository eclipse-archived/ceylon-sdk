shared class Latch(initalCount = 1) {
    "The number of times [[ratchet]] has to be called before all calls to
     [[wait]]/[[tryWait]] cease to block. Calling [[reset]] will restore the
     internal counter to this value."
    shared Integer initalCount;
    assert (initalCount > 0);
    
    variable Integer waiting = 0;
    variable Integer count = initalCount;
    
    value counterMutex = Semaphore(1);
    value zeroSync = Semaphore(0);
    
    "Restore the internal [[ratchet]] counter to [[initalCount]]."
    shared void reset() {
        try (counterMutex) {
            count = initalCount;
            // Do not change waiting
        }
    }
    
    "If the internal counter is:
     - greater than `1` then: the internal counter is decremented
     - `1` then: the internal counter is set to `0`. All waiting threads are
       released. Any future threads will not wait until [[reset]] is called.
     - `0` then: nothing happens"
    shared void ratchet() {
        try (counterMutex) {
            if (count > 0) {
                count--;
            }
            if (count == 0) {
                zeroSync.drop(waiting);
                waiting = 0;
            }
        }
    }
    
    void removeWaiting() {
        try (counterMutex) {
            // ratchet may have already reset waiting, but could also be here
            // due to a timeout.
            if (waiting > 0) {
                waiting--;
            }
        }
    }
    
    "Block until the internal counter is `0`. If it is already `0`, return
     immediately."
    throws (`class AcquireTimeoutException`, "If [[timeout]] is greater than
                                              zero and it elapses before the
                                              counter becomes `0`")
    throws (`class InterruptedException`,
        "If the thread is interrupted while waiting")
    shared void wait(timeout = 0) {
        "If equal to 0, block until the internal counter is `0`. Otherwise wait
         for at most [[timeout]] milliseconds before throwing an exception."
        Integer timeout;
        try (counterMutex) {
            if (count == 0) {
                return;
            } else {
                waiting++;
            }
        }
        try {
            zeroSync.acquire(1, timeout);
        } finally {
            removeWaiting();
        }
    }
    
    "Check if the internal counter is `0`, returning a [[Boolean]] to
      indicate success or failure. This may block."
    throws (`class InterruptedException`,
        "If the thread is interrupted while waiting")
    shared Boolean tryWait(timeout = 0) {
        "If equal to 0:
         - return [[true]] immediately if the counter is `0`.
         - return [[false]] immediately if the counter is not `0`.
         
         Otherwise wait for at most [[timeout]] milliseconds and:
         - return [[true]] if the counter became `0`.
         - return [[false]] if the counter did not become `0`"
        Integer timeout;
        try (counterMutex) {
            if (count == 0) {
                return true;
            } else {
                waiting++;
            }
        }
        try {
            return zeroSync.tryAcquire(1, timeout);
        } finally {
            removeWaiting();
        }
    }
}
