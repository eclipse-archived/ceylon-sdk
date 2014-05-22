import ceylon.collection {
    MutableSet,
    TreeSet,
    naturalOrderTreeSet
}
import ceylon.test {
    test,
    assertEquals,
    assertNotEquals,
    assertTrue
}

shared class TreeSetTest() satisfies MutableSetTests {

    shared actual MutableSet<String> createSet({String*} strings) => TreeSet {
        function compare (String x, String y) => x <=> y;
        elements = strings;
    };

    createCategory = createSet;
    
    shared actual {String*} createIterable({String?*} strings) => createSet(strings.coalesced);

    test shared void elementsAreKeptInOrder() {
        value set = createSet { "A", "B", "C" };
        assertEquals(set.first, "A");
        assertEquals(set.rest.first, "B");
        assertEquals(set.rest.rest.first, "C");
    }
    
    test shared actual void testIterator() {
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
    
    test shared actual void testFirst() {
        assertEquals(createIterable({}).first, null);
        assertEquals(createIterable({"A"}).first, "A");
        assertEquals(createIterable({"A", "B"}).first, "A");
        assertEquals(createIterable({"Z", "B", "C", "D"}).first, "B");
    }
    
    test shared actual void testLast() {
        assertEquals(createIterable({}).last, null);
        assertEquals(createIterable({"A"}).last, "A");
        assertEquals(createIterable({"A", "B"}).last, "B");
        assertEquals(createIterable({"Z", "B", "C", "D"}).last, "Z");
    }
    
    test shared actual void testRest() {
        assertEquals(createIterable({}).rest.sequence, []);
        assertEquals(createIterable({"A"}).rest.sequence, []);
        assertEquals(createIterable({"A", "B"}).rest.sequence, ["B"]);
        assertEquals(createIterable({"A", "B", "C", "D"}).rest.sequence, ["B", "C", "D"]);
    }
    
    test shared void iteratorReturnsElementsInOrder() {
        value set = TreeSet((Integer x, Integer y) => y <=> x);
        set.add(10);
        set.add(20);
        set.add(15);
        set.add(25);
        set.add(0);
        value iterator = set.iterator();
        assertEquals(iterator.next(), 25);
        assertEquals(iterator.next(), 20);
        assertEquals(iterator.next(), 15);
        assertEquals(iterator.next(), 10);
        assertEquals(iterator.next(), 0);
        assertTrue(iterator.next() is Finished);
    }

    test shared void naturalOrderTreeMapFunctionTest() {
        assertEquals(naturalOrderTreeSet{}, createSet {});
        assertEquals(naturalOrderTreeSet{"A"}, createSet {"A"});
        assertEquals(naturalOrderTreeSet{"A", "B"}, createSet {"A", "B"});
        assertNotEquals(naturalOrderTreeSet{"Z"}, createSet {"A"});
    }

    test shared void treeSetRemoveTest() {
        value intSet = naturalOrderTreeSet { 1, 2, 3, 4, 5, 6, 7 };
        intSet.remove(1);
        assertEquals(intSet, naturalOrderTreeSet { 2, 3, 4, 5, 6, 7 });
        assertEquals(intSet.size, 6);
        intSet.remove(5);
        assertEquals(intSet, naturalOrderTreeSet { 2, 3, 4, 6, 7 });
        assertEquals(intSet.size, 5);
    }


}