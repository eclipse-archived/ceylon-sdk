import ceylon.future.util {
    Semaphore,
    AcquireTimeoutException
}
import ceylon.test {
    test,
    assertFalse,
    assertTrue,
    assertThatException
}

shared class SemaphoreTests() {
    test
    shared void testAcquire() {
        value semaphore = Semaphore(1);
        semaphore.acquire();
        assertThatException(() => semaphore.acquire(1, 1))
            .hasType(`AcquireTimeoutException`);
    }
    
    test
    shared void testTryAcquire() {
        value semaphore = Semaphore(2);
        assertTrue(semaphore.tryAcquire());
        assertTrue(semaphore.tryAcquire());
        assertFalse(semaphore.tryAcquire());
    }
    
    test
    shared void testTryAcquireTimeout() {
        value semaphore = Semaphore(0);
        assertFalse(semaphore.tryAcquire(1, 1));
    }
    
    test
    shared void testDrop() {
        value semaphore = Semaphore(0);
        assertFalse(semaphore.tryAcquire());
        semaphore.drop(1);
        assertTrue(semaphore.tryAcquire());
        assertFalse(semaphore.tryAcquire());
        semaphore.drop();
        semaphore.drop();
        assertTrue(semaphore.tryAcquire());
        assertTrue(semaphore.tryAcquire());
        assertFalse(semaphore.tryAcquire());
        semaphore.drop(2);
        assertTrue(semaphore.tryAcquire());
        assertTrue(semaphore.tryAcquire());
        assertFalse(semaphore.tryAcquire());
    }
    
    test
    shared void testObtainable() {
        value semaphore = Semaphore(1);
        try (semaphore) {
            assertFalse(semaphore.tryAcquire());
        }
        assertTrue(semaphore.tryAcquire());
    }
}
