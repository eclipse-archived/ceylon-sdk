import ceylon.language.meta.model {
    ...
}
import ceylon.test {
    ...
}

test
shared void testFail() {
    assertThatException(()=>fail()).
            hasType(`AssertionException`).
            hasMessage("assertion failed");
    
    assertThatException(()=>fail("woops!")).
            hasType(`AssertionException`).
            hasMessage("woops!");
}

test
shared void testAssertNull() {
    assertNull(null);
    assertNull(null, "");
    
    assertThatException(()=>assertNull(true)).
            hasType(`AssertionException`).
            hasMessage("assertion failed: expected null, but was true");
    
    assertThatException(()=>assertNull(true, "woops!")).
            hasType(`AssertionException`).
            hasMessage("woops!");
}

test
shared void testAssertNotNull() {
    assertNotNull(true);
    assertNotNull(true, "");
    
    assertThatException(()=>assertNotNull(null)).
            hasType(`AssertionException`).
            hasMessage("assertion failed: expected not null");
    
    assertThatException(()=>assertNotNull(null, "woops!")).
            hasType(`AssertionException`).
            hasMessage("woops!");
}

test
shared void testAssertTrue() {
    assertTrue(true);
    assertTrue(true, "");
    
    assertThatException(()=>assertTrue(false)).
            hasType(`AssertionException`).
            hasMessage("assertion failed: expected true");
    
    assertThatException(()=>assertTrue(false, "woops!")).
            hasType(`AssertionException`).
            hasMessage("woops!");
}

test
shared void testAssertFalse() {
    assertFalse(false);
    assertFalse(false, "");
    
    assertThatException(()=>assertFalse(true)).
            hasType(`AssertionException`).
            hasMessage("assertion failed: expected false");
    
    assertThatException(()=>assertFalse(true, "woops!")).
            hasType(`AssertionException`).
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
    assertEquals({1, 2, 3}, {1, 2, 3});
    
    assertThatException(()=>assertEquals(true, false, "wops")).
            hasType(`AssertionComparisonException`).
            hasMessage("wops: true != false");
    
    assertThatException(()=>assertEquals(1, 2)).
            hasType(`AssertionComparisonException`).
            hasMessage("assertion failed: 1 != 2");
    
    assertThatException(()=>assertEquals(1.1, 2.2)).
            hasType(`AssertionComparisonException`).
            hasMessage("assertion failed: 1.1 != 2.2");
    
    assertThatException(()=>assertEquals('f', 'b')).
            hasType(`AssertionComparisonException`).
            hasMessage("assertion failed: f != b");
    
    assertThatException(()=>assertEquals("foo", "bar")).
            hasType(`AssertionComparisonException`).
            hasMessage("assertion failed: foo != bar");
    
    assertThatException(()=>assertEquals([1, 2, 3], [3, 2, 1])).
            hasType(`AssertionComparisonException`).
            hasMessage("assertion failed: [1, 2, 3] != [3, 2, 1]");
    
    assertThatException(()=>assertEquals({1, 2, 3}, {3, 2, 1})).
            hasType(`AssertionComparisonException`).
            hasMessage("assertion failed: [1, 2, 3] != [3, 2, 1]");
}

test
shared void testAssertEqualsCompare() {
    assertEquals(1, 2, "never false", (Object? o1, Object? o2) => true);
    
    assertThatException(()=>assertEquals(1, 1, "never true", (Object? o1, Object? o2) => false)).
            hasType(`AssertionComparisonException`);
}

test
shared void testAssertEqualsException() {
    try {
        assertEquals(true, false);
        assert(false);
    }
    catch(AssertionComparisonException e) {
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
            hasType(`AssertionComparisonException`).
            hasMessage("assertion failed: true == true");
    
    assertThatException(()=>assertNotEquals(true, true, "wops")).
            hasType(`AssertionComparisonException`).
            hasMessage("wops: true == true");
}

test
shared void testAssertThatException() {
    assertThatException(OverflowException()).
            hasType(`OverflowException`).
            hasMessage("Numeric overflow").
            hasMessage((String m)=>m.startsWith("Numeric")).
            hasNoCause();
    
    try {
        assertThatException(OverflowException()).hasType(`InitializationException`);
        assert(false);
    }
    catch(AssertionException e) {
        assert(e.message.startsWith("assertion failed: expected exception with type "));
    }
    
    try {
        assertThatException(OverflowException()).hasType((ClassModel<Exception, Nothing> t)=>false);
        assert(false);
    }
    catch(AssertionException e) {
        assert(e.message.startsWith("assertion failed: expected exception with different type than "));
    }
    
    try {
        assertThatException(OverflowException()).hasMessage("wops!");
        assert(false);
    }
    catch(AssertionException e) {
        assert(e.message == "assertion failed: expected exception with message wops!, but has Numeric overflow");
    }
    
    try {
        assertThatException(OverflowException()).hasMessage((String m)=>m.contains("wops!"));
        assert(false);
    }
    catch(AssertionException e) {
        assert(e.message == "assertion failed: expected different exception message than Numeric overflow");
    }
    
    try {
        assertThatException(Exception("", OverflowException())).hasNoCause();
        assert(false);
    }
    catch(AssertionException e) {
        assert(e.message == "assertion failed: expected exception without cause, but has ceylon.language.OverflowException \"Numeric overflow\"");
    }
    
    try {
        assertThatException(()=>true);
        assert(false);
    }
    catch(AssertionException e) {
        assert(e.message == "assertion failed: expected exception will be thrown");
    }
}