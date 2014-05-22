import ceylon.collection {
    HashSet,
    unlinked,
    MutableSet
}
import ceylon.test {
    test,
    assertEquals,
    assertTrue,
    assertNotEquals
}

class HashSetTest() satisfies MutableSetTests {

    shared actual MutableSet<String> createSet({String*} strings) => HashSet { elements = strings; };

    createCategory = createSet;
    
    shared actual {String*} createIterable({String?*} strings) => createSet(strings.coalesced);

    test shared void elementsAreKeptInOrder() {
        value set = HashSet { "A", "B", "C" };
        assertEquals(set.first, "A");
        assertEquals(set.rest.first, "B");
        assertEquals(set.rest.rest.first, "C");
    }

}

class UnlinkedHashSetTest() satisfies MutableSetTests {

    shared actual MutableSet<String> createSet({String*} strings) => HashSet { stability = unlinked; elements = strings; };

    createCategory = createSet;
    
    shared actual {String*} createIterable({String?*} strings) => createSet(strings.coalesced);

    
    test shared actual void testIterator() {
        variable value iter = createIterable({}).iterator();
        assertTrue(iter.next() is Finished);
        assertTrue(iter.next() is Finished);
        iter = createIterable({"A"}).iterator();
        assertEquals(iter.next(), "A");
        assertTrue(iter.next() is Finished);
        iter = createIterable({"A", "B", "C"}).iterator();
        value items = [iter.next(), iter.next(), iter.next(), iter.next()];
        assertTrue(items.contains("A"));
        assertTrue(items.contains("B"));
        assertTrue(items.contains("C"));
        assertTrue(items.contains(finished));
    }
    
    test shared actual void testFirst() {
        assertEquals(createIterable({}).first, null);
        assertEquals(createIterable({"A"}).first, "A");
        variable value first = createIterable({"A", "B"}).first;
        assert(exists f1 = first);
        assertTrue(["A", "B"].contains(f1));
        first = createIterable({"A", "B", "Z", "M", "F", "John"}).first;
        assert(exists f2 = first);
        assertTrue(["A", "B", "Z", "M", "F", "John"].contains(f2));
    }
    
    test shared actual void testLast() {
        assertEquals(createIterable({}).last, null);
        assertEquals(createIterable({"A"}).last, "A");
        variable value last = createIterable({"A", "B"}).last;
        assert(exists l1 = last);
        assertTrue(["A", "B"].contains(l1));
        last = createIterable({"A", "B", "Z", "M", "F", "John"}).last;
        assert(exists l2 = last);
        assertTrue(["A", "B", "Z", "M", "F", "John"].contains(l2));
    }
    
    test shared actual void testRest() {
        assertEquals(createIterable({}).rest.sequence, []);
        assertEquals(createIterable({"A"}).rest.sequence, []);
        value rest = createIterable({"A", "B"}).rest.sequence;
        assertTrue("A" in rest || "B" in rest);
        assertNotEquals(createIterable({"A", "B"}).first, rest.first);
        
        value set = createSet({"A", "B", "C", "D"});
        assertEquals(set.rest.size, 3);
        value diff = set.complement(createSet(set.rest));
        assertEquals(diff.size, 1);
    }

}
