import ceylon.language.meta.model {
    ...
}
import ceylon.test {
    ...
}

test
shared void testFail() {
    assertThatException(()=>fail()).
            hasType(`AssertionError`).
            hasMessage("assertion failed");
    
    assertThatException(()=>fail("woops!")).
            hasType(`AssertionError`).
            hasMessage("woops!");
}

test
shared void testAssertNull() {
    assertNull(null);
    assertNull(null, "");
    
    assertThatException(()=>assertNull(true)).
            hasType(`AssertionError`).
            hasMessage("assertion failed: expected null, but was true");
    
    assertThatException(()=>assertNull(true, "woops!")).
            hasType(`AssertionError`).
            hasMessage("woops!");
}

test
shared void testAssertNotNull() {
    assertNotNull(true);
    assertNotNull(true, "");
    
    assertThatException(()=>assertNotNull(null)).
            hasType(`AssertionError`).
            hasMessage("assertion failed: expected not null");
    
    assertThatException(()=>assertNotNull(null, "woops!")).
            hasType(`AssertionError`).
            hasMessage("woops!");
}

test
shared void testAssertTrue() {
    assertTrue(true);
    assertTrue(true, "");
    
    assertThatException(()=>assertTrue(false)).
            hasType(`AssertionError`).
            hasMessage("assertion failed: expected true");
    
    assertThatException(()=>assertTrue(false, "woops!")).
            hasType(`AssertionError`).
            hasMessage("woops!");
}

test
shared void testAssertFalse() {
    assertFalse(false);
    assertFalse(false, "");
    
    assertThatException(()=>assertFalse(true)).
            hasType(`AssertionError`).
            hasMessage("assertion failed: expected false");
    
    assertThatException(()=>assertFalse(true, "woops!")).
            hasType(`AssertionError`).
            hasMessage("woops!");
}

test
shared void testAssertEquals() {
    assertEquals(null, null);
    assertEquals(true, true);
    assertEquals(1, 1);
    assertEquals(1.0, 1.0);
    assertEquals('f', 'f');
    assertEquals("foo", "foo");
    assertEquals([1, 2, 3], [1, 2, 3]);
    
    assertThatException(()=>assertEquals(true, false, "wops")).
            hasType(`AssertionComparisonError`).
            hasMessage("wops: expected <false> but was <true>");
    
    assertThatException(()=>assertEquals(1, 2)).
            hasType(`AssertionComparisonError`).
            hasMessage("assertion failed: expected <2> but was <1>");
    
    assertThatException(()=>assertEquals(1.1, 2.2)).
            hasType(`AssertionComparisonError`).
            hasMessage("assertion failed: expected <2.2> but was <1.1>");
    
    assertThatException(()=>assertEquals('f', 'b')).
            hasType(`AssertionComparisonError`).
            hasMessage("assertion failed: expected <b> but was <f>");
    
    assertThatException(()=>assertEquals("foo", "bar")).
            hasType(`AssertionComparisonError`).
            hasMessage("assertion failed: expected <bar> but was <foo>");
    
    assertThatException(()=>assertEquals([1, 2, 3], [3, 2, 1])).
            hasType(`AssertionComparisonError`).
            hasMessage("assertion failed: expected <[3, 2, 1]> but was <[1, 2, 3]>");
    
    assertThatException(()=>assertEquals({1, 2, 3}, [])).
            hasType(`AssertionComparisonError`).
            hasMessage("assertion failed: expected <[]> but was <{ 1, 2, 3 }>");
}

test
shared void testAssertEqualsCompare() {
    assertEquals(1, 2, "never false", (Anything o1, Anything o2) => true);
    
    assertThatException(()=>assertEquals(1, 1, "never true", (Anything o1, Anything o2) => false)).
            hasType(`AssertionComparisonError`);
}

test
shared void testAssertEqualsException() {
    try {
        assertEquals(true, false);
        assert(false);
    }
    catch(AssertionComparisonError e) {
        assert(e.actualValue == "true");
        assert(e.expectedValue == "false");
    }
}

test
shared void testAssertNotEquals() {
    assertNotEquals(null, true);
    assertNotEquals(true, false);
    assertNotEquals(1, 2);
    assertNotEquals(1.0, 2.0);
    assertNotEquals('f', 'b');
    assertNotEquals("foo", "bar");
    assertNotEquals([1, 2, 3], [3, 2, 1]);
    assertNotEquals({1, 2, 3}, {3, 2, 1});
    
    assertThatException(()=>assertNotEquals(true, true)).
            hasType(`AssertionError`).
            hasMessage("assertion failed: expected not equals <true>");
    
    assertThatException(()=>assertNotEquals(true, true, "wops")).
            hasType(`AssertionError`).
            hasMessage("wops: expected not equals <true>");
}

test
shared void testAssertThatException() {
    assertThatException(OverflowException()).
            hasType(`OverflowException`).
            hasMessage("Numeric overflow").
            hasMessage((String m)=>m.startsWith("Numeric")).
            hasNoCause();
    
    try {
        assertThatException(OverflowException()).hasType(`InitializationError`);
        assert(false);
    }
    catch(AssertionError e) {
        assert(e.message.startsWith("assertion failed: expected exception with type "));
    }
    
    try {
        assertThatException(OverflowException()).hasType((ClassModel<Throwable, Nothing> t)=>false);
        assert(false);
    }
    catch(AssertionError e) {
        assert(e.message.startsWith("assertion failed: expected exception with different type than "));
    }
    
    try {
        assertThatException(OverflowException()).hasMessage("wops!");
        assert(false);
    }
    catch(AssertionError e) {
        assert(e.message == "assertion failed: expected exception with message wops!, but has Numeric overflow");
    }
    
    try {
        assertThatException(OverflowException()).hasMessage((String m)=>m.contains("wops!"));
        assert(false);
    }
    catch(AssertionError e) {
        assert(e.message == "assertion failed: expected different exception message than Numeric overflow");
    }
    
    try {
        assertThatException(Exception("", OverflowException())).hasNoCause();
        assert(false);
    }
    catch(AssertionError e) {
        assert(e.message == "assertion failed: expected exception without cause, but has ceylon.language.OverflowException \"Numeric overflow\"" ||
               e.message == "assertion failed: expected exception without cause, but has ceylon.language::OverflowException \"Numeric overflow\"");
    }
    
    try {
        assertThatException(()=>true);
        assert(false);
    }
    catch(AssertionError e) {
        assert(e.message == "assertion failed: expected exception will be thrown");
    }
}
