import ceylon.collection {
    MutableSet
}
import ceylon.test {
    assertTrue,
    assertEquals,
    test,
    assertFalse
}

shared interface MutableSetTests satisfies SetTests {

    shared actual formal MutableSet<String> createSet({String*} strings);

    test shared void doSetTests() {
        value set = createSet {};
        assertEquals("{}", set.string);
        assertEquals(0, set.size);
        assertEquals(true, set.add("fu"));
        assertEquals("{ fu }", set.string);
        assertTrue(set.contains("fu"));
        assertEquals(1, set.size);
        assertEquals(false, set.add("fu"));
        assertEquals("{ fu }", set.string);
        assertTrue(set.contains("fu"));
        assertEquals(1, set.size);
        set.add("stef");
        assertTrue(set.contains("fu"));
        assertTrue(set.contains("stef"));
        assertEquals(2, set.size);
        assertTrue(!set.contains("bar"));
        set.clear();
        assertEquals("{}", set.string);
        assertEquals(0, set.size);
        assertTrue(!set.contains("fu"));
    }

    test shared void testRemove() {
        value set = createSet {"a", "b"};
        assertTrue(set.remove("a"));
        assertEquals(set, createSet {"b"});
        set.add("c");
        assertFalse(set.remove("d"));
        assertEquals(set, createSet {"b", "c"});
        assertTrue(set.remove("b"));
        assertEquals(set, createSet {"c"});
        assertFalse(set.remove("b"));
        assertTrue(set.remove("c"));
        assertEquals(set, createSet {});
        assertFalse(set.remove("c"));
    }

}
