import ceylon.collection {
    ArrayList
}
import ceylon.test {
    test,
    assertEquals,
    assertTrue
}

shared class ArrayListTest() extends MutableListTests() {

    createList({String?*} strings) => ArrayList<String?>{ elements = strings; };

    test shared void testChangingCapacity() {
        value list = ArrayList { initialCapacity = 2; growthFactor = 1.5; elements = { "a", "b" }; };
        assertEquals(list.capacity, 2);
        assertEquals(list.size, 2);

        // cause array to grow
        list.add("c");

        assertEquals(list, ArrayList { "a", "b", "c" });
        assertEquals(list.capacity, 4);
        assertEquals(list.size, 3);

        // grow again, but delete something first
        list.delete(0);
        list.addAll {"e", "f", "g", "h"};

        assertEquals(list, ArrayList { "b", "c", "e", "f", "g", "h" });
        assertEquals(list.capacity, 9);
        assertEquals(list.size, 6);
    }

    test shared void testBuildingFromArrayList() {
        value list = ArrayList {
            initialCapacity = 32;
            growthFactor = 1.5;
            elements = ArrayList{ elements = "a".repeat(50); };
        };
        assertEquals(list.capacity, 50);
        assertEquals(list.size, 50);
        assertTrue(list.every((Character c) => c == 'a'));
    }

    test shared void testReversedWithNoNullsAllowed() {
        value list = ArrayList { 1, 2, 3 };
        assertEquals(list.reversed, [3, 2, 1]);
        assertEquals(list, [1, 2, 3]);
        list.clear();
        assertEquals(list.reversed, []);
        assertEquals(list, []);
    }

}