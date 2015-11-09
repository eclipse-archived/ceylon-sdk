"Allows one or more threads to be held as waiters until a [[certain number of
 calls|initalCount]] to [[ratchet]] have been made. Once the internal counter
 becomes zero, all waiters are released and any new waiters will not block.
 
 The latch is resettable, which will cause (after the [[reset]] call returns)
 all new threads to wait again, until [[the same number of calls|initalCount]]
 to [[ratchet]] have been made again.
 
 Supports multiple waiting styles, aligned with [[Semaphore]]'s acquisition
 styles."
aliased ("Event")
shared class Latch(initalCount = 1) {
    "The number of times [[ratchet]] has to be called before all calls to
     [[wait]]/[[tryWait]] cease to block. Calling [[reset]] will restore the
     internal counter to this value."
    shared Integer initalCount;
    assert (initalCount > 0);
    
    // Begin counters, counterMutex must be held!
    variable Integer count = initalCount;
    "Adding reset exposes us to some rare issues with intereaved waits and
     `count = 0` releases. To prevent this, track the waiters in cohorts. We
     only need to keep track of the latest, the waiters will hold a reference
     to their cohort throughout their wait call."
    class Cohort() {
        shared variable Integer waiting = 0;
        shared Semaphore zeroSync = Semaphore(0);
    }
    variable Cohort currentCohort = Cohort();
    // End counters
    
    value counterMutex = Semaphore(1);
    
    "Restore the internal [[ratchet]] counter to [[initalCount]]."
    shared void reset() {
        try (counterMutex) {
            count = initalCount;
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
                currentCohort.zeroSync.drop(currentCohort.waiting);
                currentCohort = Cohort();
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
        Cohort myCohort;
        try (counterMutex) {
            myCohort = currentCohort;
            if (count == 0) {
                return;
            } else {
                myCohort.waiting++;
            }
        }
        try {
            myCohort.zeroSync.acquire(1, timeout);
        } finally {
            try (counterMutex) {
                myCohort.waiting--;
            }
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
        Cohort myCohort;
        try (counterMutex) {
            myCohort = currentCohort;
            if (count == 0) {
                return true;
            } else {
                myCohort.waiting++;
            }
        }
        try {
            return myCohort.zeroSync.tryAcquire(1, timeout);
        } finally {
            try (counterMutex) {
                myCohort.waiting--;
            }
        }
    }
}
