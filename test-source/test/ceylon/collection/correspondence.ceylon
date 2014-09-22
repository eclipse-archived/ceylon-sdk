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
    
    test shared void testDefinesAny() {
        assertFalse(createCorrespondence({}).definesAny {});
        assertFalse(createCorrespondence({}).definesAny{0});
        assertFalse(createCorrespondence({}).definesAny{1});
        assertTrue(createCorrespondence({"a"}).definesAny{0});
        assertFalse(createCorrespondence({"a"}).definesAny{1});
        value longList = createCorrespondence((1..10).map(Object.string));
        assertFalse(longList.definesAny{-1});
        for (i in 0:10) {
            assertTrue(longList.definesAny(0..i), "Should defineAny ``0..i``");
        }
        assertFalse(longList.definesAny(10..20));
    }
    
    test shared void testDefinesEvery() {
        assertTrue(createCorrespondence({}).definesEvery {});
        assertFalse(createCorrespondence({}).definesEvery{0});
        assertFalse(createCorrespondence({}).definesEvery{1});
        assertTrue(createCorrespondence({"a"}).definesEvery{0});
        assertFalse(createCorrespondence({"a"}).definesEvery{1});
        value longList = createCorrespondence((1..10).map(Object.string));
        assertFalse(longList.definesEvery{-1});
        for (i in 0:10) {
            assertTrue(longList.definesEvery(0:i), "Should defineEvery ``0..i``");
        }
        assertFalse(longList.definesEvery(0..10));
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
    
    test shared void testItems() {
        assertTrue(createCorrespondence({}).getAll{}.empty);
        assertTrue(createCorrespondence({"a"}).getAll{}.empty);
        assertEquals(createCorrespondence({}).getAll{0}.sequence(), [null]);
        assertEquals(createCorrespondence({}).getAll{1}.sequence(), [null]);
        assertEquals(createCorrespondence({}).getAll{-1}.sequence(), [null]);
        assertEquals(createCorrespondence({"a"}).getAll{0}.sequence(), ["a"]);
        assertEquals(createCorrespondence({"a"}).getAll{0, 1}.sequence(), ["a", null]);
        assertEquals(createCorrespondence({"a"}).getAll{-1, 1}.sequence(), [null, null]);
        assertEquals(createCorrespondence({"a"}).getAll{-10, 0, 1}.sequence(), [null, "a", null]);
        assertEquals(createCorrespondence({"a", "b", "c"}).getAll{0, 1}.sequence(), ["a", "b"]);
        assertEquals(createCorrespondence((0:10).map(Object.string)).getAll(0:10).sequence(), (0:10).map(Object.string).sequence());
    }
    
}
