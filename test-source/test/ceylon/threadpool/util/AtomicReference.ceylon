import ceylon.threadpool.util {
    AtomicReference
}
import ceylon.test {
    test,
    assertFalse,
    assertTrue,
    assertEquals
}

shared class AtomicReferenceTests() {
    test
    shared void testGetSet() {
        value ref = AtomicReference<Float>(runtime.maxFloatValue);
        assertEquals(ref.current, runtime.maxFloatValue);
        ref.current = 0.0;
        assertEquals(ref.current, 0.0);
    }
    
    test
    shared void testSwap() {
        value ref = AtomicReference<Boolean>(false);
        assertFalse(ref.swap(true, false));
        assertFalse(ref.swap(true, true));
        assertTrue(ref.swap(false, false));
        assertTrue(ref.swap(false, true));
        assertFalse(ref.swap(false, true));
        assertFalse(ref.swap(false, false));
        assertTrue(ref.swap(true, false));
    }
    
    test
    shared void testReplace() {
        value ref = AtomicReference<Integer>(runtime.maxIntegerValue);
        assertEquals(ref.replace(0), runtime.maxIntegerValue);
        assertEquals(ref.replace(123), 0);
    }
    
    test
    shared void testUpdate() {
        value ref = AtomicReference<String>("I don't need a tie for gravitas");
        assertEquals(ref.update((p) => p.lowercased), "I don't need a tie for gravitas");
        assertEquals(ref.update((p) => p.uppercased), "i don't need a tie for gravitas");
        assertEquals(ref.update((p) => ""), "I DON'T NEED A TIE FOR GRAVITAS");
    }
}
