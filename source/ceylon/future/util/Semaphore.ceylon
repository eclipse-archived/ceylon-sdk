import java.lang {
    JavaInterruptedException=InterruptedException,
    Thread
}
import java.util.concurrent {
    JavaSemaphore=Semaphore,
    TimeUnit {
        ms=\iMILLISECONDS
    }
}

"A classic unbounded counting semaphore, with support for several acquisition
 styles:
 1. Block until permits are granted ([[acquire]] with `timeout = 0`).
 2. 1, but raise an exception if a timeout is exceeded ([[acquire]] with
    `timeout > 0`).
 3. Non-blocking attempt to get permits with Boolean success ([[tryAcquire]]
    with `timeout = 0`).
 4. 3, but block for a limited time before returning the success Boolean
    ([[tryAcquire]] with `timeout > 0`).

 A `try` block will use the first acquisition style by default. To use the
 second style, set [[defaultTimeout]] to a value greater than zero."
aliased ("Mutex", "Lock", "Sync")
shared class Semaphore(permits, fair = false, defaultTimeout = 0)
        satisfies Obtainable {
    "The initial number of permits in the pool."
    shared Integer permits;
    "If true, permits will be allocated FIFO."
    shared Boolean fair;
    "The default acquisition timeout. Primarily intended to allow timeouts when
     used with a `try` block."
    shared Integer defaultTimeout;
    assert (defaultTimeout >= 0);
    
    value provider = JavaSemaphore(permits, fair);
    
    "Remove permits from the permit pool. This will block."
    throws (`class AcquireTimeoutException`, "If [[timeout]] is greater than
                                              zero and it elapses before the
                                              permits are acquired")
    throws (`class InterruptedException`,
        "If the thread is interrupted during the acquire")
    shared void acquire(permits = 1, timeout = defaultTimeout) {
        "The number of permits to remove."
        Integer permits;
        "If equal to 0, block until the permits are removed. Otherwise wait for
         at most [[timeout]] milliseconds before throwing an exception."
        Integer timeout;
        assert (permits >= 0);
        assert (timeout >= 0);
        try {
            if (timeout == 0) {
                provider.acquire(permits);
            } else {
                if (!provider.tryAcquire(permits, timeout, ms)) {
                    throw AcquireTimeoutException("timeout of ``timeout`` ms exeeded");
                }
            }
        } catch (JavaInterruptedException e) {
            Thread.currentThread().interrupt();
            throw InterruptedException("Interrupted during acquire", e);
        }
    }
    
    "Attempt to remove permits from the permit pool, returning a [[Boolean]] to
      indicate success or failure. This may block, but not by default."
    throws (`class InterruptedException`, "If [[timeout]] is greater than zero
                                           and the thread is interrupted during
                                           the acquire")
    shared Boolean tryAcquire(permits = 1, timeout = defaultTimeout) {
        "The number of permits to remove."
        Integer permits;
        "If equal to 0:
         - return [[true]] immediately if the [[permits]] were acquired.
         - return [[false]] immediately if the [[permits]] were not acquired.
         
         Otherwise wait for at most [[timeout]] milliseconds and:
         - return [[true]] if the [[permits]] were acquired.
         - return [[false]] if the [[permits]] were not acquired."
        Integer timeout;
        assert (permits >= 0);
        assert (timeout >= 0);
        if (timeout == 0) {
            // No exception to catch
            return provider.tryAcquire(permits);
        } else {
            try {
                return provider.tryAcquire(permits, timeout, ms);
            } catch (JavaInterruptedException e) {
                Thread.currentThread().interrupt();
                throw InterruptedException("Interrupted during tryAcquire", e);
            }
        }
    }
    
    shared actual void obtain() => acquire();
    
    "Add permits to the permit pool. This will never block."
    // Can't call it release due to conflict with Obtainable.release
    aliased ("release")
    shared void drop(permits = 1) {
        "The number of permits to add."
        Integer permits;
        assert (permits >= 0);
        provider.release(permits);
    }
    
    shared actual void release(Throwable? error) => drop();
}
