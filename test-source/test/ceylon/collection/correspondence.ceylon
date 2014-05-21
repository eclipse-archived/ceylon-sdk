import ceylon.test {
    test,
    assertTrue,
    assertFalse,
    assertEquals
}

shared interface CorrespondenceTests {
    
    shared formal Correspondence<Integer, String?> createCorrespondence({String*} strings);
    
    test shared void testDefines() {
        assertFalse(createCorrespondence({}).defines(0));
        assertFalse(createCorrespondence({}).defines(-1));
        assertFalse(createCorrespondence({}).defines(1));
        assertTrue(createCorrespondence({"a"}).defines(0));
        assertFalse(createCorrespondence({"a"}).defines(-1));
        assertFalse(createCorrespondence({"a"}).defines(1));
        value longList = createCorrespondence((1..100).map(Object.string));
        assertFalse(longList.defines(-1));
        for (i in 0:100) {
            assertTrue(longList.defines(i), "Should define ``i``");
        }
        assertFalse(longList.defines(100));
    }
    
    test shared void testGet() {
        assertEquals(createCorrespondence({}).get(-1), null);
        assertEquals(createCorrespondence({}).get(0), null);
        assertEquals(createCorrespondence({}).get(1), null);
        assertEquals(createCorrespondence({"a"}).get(-1), null);
        assertEquals(createCorrespondence({"a"}).get(0), "a");
        assertEquals(createCorrespondence({"a"}).get(1), null);
        assertEquals(createCorrespondence({}).get(0), null);
        value longList = createCorrespondence((1..100).map(Object.string));
        assertEquals(longList.get(-1), null);
        for (i in 0:100) {
            assertEquals(longList.get(i), (i + 1).string);
        }
        assertEquals(longList.get(100), null);
    }
    
    test shared void testKeys() {
        variable value keys = createCorrespondence({}).keys;
        for (k in 0..10) {
            assertFalse(k in keys, "Should not contain key ``k``");
        }
        keys = createCorrespondence({"a"}).keys;
        assertTrue(0 in keys);
        for (k in 1..10) {
            assertFalse(k in keys, "Should not contain key ``k``");
        }
        keys = createCorrespondence((1..11).map(Object.string)).keys;
        for (k in 0..10) {
            assertTrue(k in keys, "Should contain key ``k``");
        }
        assertFalse(-1 in keys);
        assertFalse(-10 in keys);
        assertFalse(11 in keys);
        assertFalse(100 in keys);
    }
    
}