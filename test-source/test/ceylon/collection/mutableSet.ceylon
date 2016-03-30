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

    shared actual formal MutableSet<T> createSet<T>({T*} elements) given T satisfies Comparable<T>;

    test shared void doPoorHashTests() {
        class PoorHash(Integer h, Integer id) satisfies Comparable<PoorHash>{
            shared actual Integer hash {
                return h;
            }
            shared actual Boolean equals(Object that) {
                if (is PoorHash that) {
                    return id == that.id;
                }
                return false;
            }
            shared actual Comparison compare(PoorHash other) => this.id <=> other.id;
        }
        value set = createSet<PoorHash> {};
        set.add(PoorHash(1, 1));
        set.add(PoorHash(1, 2));
        set.add(PoorHash(1, 3));
        set.add(PoorHash(1, 4));

        set.add(PoorHash(1, 5));
        set.add(PoorHash(1, 6));
        set.add(PoorHash(1, 7));
        set.add(PoorHash(1, 8));

        set.add(PoorHash(1, 9));
        set.add(PoorHash(1, 10));
        set.add(PoorHash(1, 11));
        set.add(PoorHash(1, 12));

        set.add(PoorHash(1, 13));
        set.add(PoorHash(1, 14));
        set.add(PoorHash(1 ,15));
        set.add(PoorHash(1, 16));
        assertEquals(set.size, 16);

        set.add(PoorHash(1, 1));
        set.add(PoorHash(1, 2));
        set.add(PoorHash(1, 3));
        set.add(PoorHash(1, 4));

        set.add(PoorHash(1, 5));
        set.add(PoorHash(1, 6));
        set.add(PoorHash(1, 7));
        set.add(PoorHash(1, 8));

        set.add(PoorHash(1, 9));
        set.add(PoorHash(1, 10));
        set.add(PoorHash(1, 11));
        set.add(PoorHash(1, 12));

        set.add(PoorHash(1, 13));
        set.add(PoorHash(1, 14));
        set.add(PoorHash(1 ,15));
        set.add(PoorHash(1, 16));
        assertEquals(set.size, 16);
    }

    test shared void doSetTests() {
        value set = createSet<String> {};
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
    
    "This function is called by [[testRepeat]]."
    shared actual default void testRepeatFunction(List<String?>(Integer)({String?*}) cycle) {
        assertEquals(cycle(createIterable {})(0), []);
        assertEquals(cycle(createIterable {})(1), []);
        assertEquals(cycle(createIterable {})(-1), []);
        assertEquals(cycle(createIterable {"a"})(1), ["a"]);
        assertEquals(cycle(createIterable {"a", "b", "c"})(1), createIterable({"a", "b", "c"}).sequence());
        assertEquals(cycle(createIterable {"a"})(2), ["a", "a"]);
        assertEquals(cycle(createIterable {"a", "b", "c"})(3), ["a", "b", "c","a", "b", "c","a", "b", "c"]);
    }

}
