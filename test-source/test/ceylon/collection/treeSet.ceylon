import ceylon.collection {
    MutableSet,
    TreeSet,
    naturalOrderTreeSet
}
import ceylon.test {
    test,
    assertEquals,
    assertNotEquals
}

shared class TreeSetTest() satisfies MutableSetTests & NaturalOrderIterableTests {

    shared actual MutableSet<T> createSet<T>({T*} elts) given T satisfies Comparable<T>
             => TreeSet {
        function compare (T x, T y) => x <=> y;
        elements = elts;
    };

    createCategory = createSet<String>;
    createIterable = createSet<String>;
    
    test shared void elementsAreKeptInOrder() {
        value set = createSet { "A", "B", "C" };
        assertEquals(set.first, "A");
        assertEquals(set.rest.first, "B");
        assertEquals(set.rest.rest.first, "C");
    }

    test shared void naturalOrderTreeMapFunctionTest() {
        assertEquals(naturalOrderTreeSet{}, createSet {});
        assertEquals(naturalOrderTreeSet{"A"}, createSet {"A"});
        assertEquals(naturalOrderTreeSet{"A", "B"}, createSet {"A", "B"});
        assertNotEquals(naturalOrderTreeSet{"Z"}, createSet {"A"});
    }

    test shared void testTreeSetRemove() {
        value intSet = naturalOrderTreeSet { 1, 2, 3, 4, 5, 6, 7 };
        intSet.remove(1);
        assertEquals(intSet, naturalOrderTreeSet { 2, 3, 4, 5, 6, 7 });
        assertEquals(intSet.size, 6);
        intSet.remove(5);
        assertEquals(intSet, naturalOrderTreeSet { 2, 3, 4, 6, 7 });
        assertEquals(intSet.size, 5);
    }
    
    test shared void testTreeSetSpan() {
        value ts = naturalOrderTreeSet { 4, 5, 1, 2, 3 };
        assertEquals(ts[1..3].sequence(),[1,2,3]);
        assertEquals(ts[2..3].sequence(),[2,3]);
        assertEquals(ts[3..1].sequence(),[3,2,1]);
        assertEquals(ts[3..2].sequence(),[3,2]);
    }

}