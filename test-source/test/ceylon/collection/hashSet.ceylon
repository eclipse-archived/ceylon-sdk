import ceylon.collection {
    HashSet,
    unlinked,
    MutableSet
}
import ceylon.test {
    test,
    assertEquals
}

class HashSetTest() satisfies MutableSetTests {

    shared actual MutableSet<String> createSet({String*} strings) => HashSet { elements = strings; };

    createCategory = createSet;

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

    test shared void unlinkedSet() {

    }

}
