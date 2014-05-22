import ceylon.test {
    test,
    assertTrue,
    assertFalse,
    assertEquals
}

shared interface IterableTests satisfies CategoryTests {
    
    shared formal {String?*} createIterable({String?*} strings);
    
    test shared void testShorterThan() {
        assertFalse(createIterable({}).shorterThan(0));
        assertFalse(createIterable({}).shorterThan(-1));
        assertTrue(createIterable({}).shorterThan(1));
        assertFalse(createIterable({"a"}).shorterThan(0));
        assertFalse(createIterable({"a"}).shorterThan(1));
        assertTrue(createIterable({"a"}).shorterThan(2));
        value longList = createIterable((1..100).map(Object.string));
        assertFalse(longList.shorterThan(99));
        assertFalse(longList.shorterThan(100));
        assertTrue(longList.shorterThan(101));
        assertTrue(longList.shorterThan(1000));
    }
    
    test shared void testLongerThan() {
        assertFalse(createIterable({}).longerThan(0));
        assertFalse(createIterable({}).longerThan(1));
        assertTrue(createIterable({}).longerThan(-1));
        assertTrue(createIterable({"a"}).longerThan(0));
        assertFalse(createIterable({"a"}).longerThan(1));
        assertFalse(createIterable({"a"}).longerThan(2));
        value longList = createIterable((1..100).map(Object.string));
        assertTrue(longList.longerThan(99));
        assertFalse(longList.longerThan(100));
        assertFalse(longList.longerThan(1000));
    }

    test shared default void testIterator() {
        variable value iter = createIterable({}).iterator();
        assertTrue(iter.next() is Finished);
        assertTrue(iter.next() is Finished);
        iter = createIterable({"A"}).iterator();
        assertEquals(iter.next(), "A");
        assertTrue(iter.next() is Finished);
        iter = createIterable({"A", "B", "C"}).iterator();
        assertEquals(iter.next(), "A");
        assertEquals(iter.next(), "B");
        assertEquals(iter.next(), "C");
        assertTrue(iter.next() is Finished);
    }
    
    test shared default void testFirst() {
        assertEquals(createIterable({}).first, null);
        assertEquals(createIterable({"A"}).first, "A");
        assertEquals(createIterable({"A", "B"}).first, "A");
        assertEquals(createIterable({"Z", "B", "C", "D"}).first, "Z");
    }
    
    test shared default void testLast() {
        assertEquals(createIterable({}).last, null);
        assertEquals(createIterable({"A"}).last, "A");
        assertEquals(createIterable({"A", "B"}).last, "B");
        assertEquals(createIterable({"Z", "B", "C", "D"}).last, "D");
    }
    
    test shared default void testRest() {
        assertEquals(createIterable({}).rest.sequence, []);
        assertEquals(createIterable({"A"}).rest.sequence, []);
        assertEquals(createIterable({"A", "B"}).rest.sequence, ["B"]);
        assertEquals(createIterable({"A", "B", "C", "D"}).rest.sequence, ["B", "C", "D"]);
    }
    
}