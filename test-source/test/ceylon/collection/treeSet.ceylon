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

    shared actual MutableSet<String> createSet({String*} strings) => TreeSet {
        function compare (String x, String y) => x <=> y;
        elements = strings;
    };

    createCategory = createSet;
    createIterable = createSet;
    
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