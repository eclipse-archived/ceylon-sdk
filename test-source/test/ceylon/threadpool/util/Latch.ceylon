import ceylon.threadpool.util {
    Latch,
    AcquireTimeoutException
}
import ceylon.test {
    test,
    assertFalse,
    assertTrue,
    assertThatException
}

shared class LatchTests() {
    test
    shared void testWait() {
        value latch = Latch();
        assertThatException(() => latch.wait(1))
            .hasType(`AcquireTimeoutException`);
        latch.ratchet();
        latch.wait(1);
    }
    
    test
    shared void testTryWaitNoTimeout() {
        value latch = Latch();
        assertFalse(latch.tryWait());
        latch.ratchet();
        assertTrue(latch.tryWait());
        assertTrue(latch.tryWait());
    }
    
    test
    shared void testTryWaitTimeout() {
        value latch = Latch();
        assertFalse(latch.tryWait(1));
        assertFalse(latch.tryWait(1));
        latch.ratchet();
        assertTrue(latch.tryWait(1));
    }
    
    test
    shared void testReset() {
        value latch = Latch();
        latch.ratchet();
        assertTrue(latch.tryWait());
        latch.reset();
        assertFalse(latch.tryWait());
        assertFalse(latch.tryWait());
    }
}
