import ceylon.collection {
    ArrayList
}
import ceylon.test {
    test,
    assertEquals
}

shared class ArrayListTest() extends MutableListTests() {

    createList({String?*} strings) => ArrayList<String?>{ elements = strings; };

    test shared void testChangingCapacity() {
        value list = ArrayList { initialCapacity = 2; growthFactor = 1.5; elements = { "a", "b" }; };
        assertEquals(2, list.capacity);

        // cause array to grow
        list.add("c");

        assertEquals(ArrayList { "a", "b", "c" }, list);
        assertEquals(4, list.capacity);

        // grow again, but delete something first
        list.delete(0);
        list.addAll {"e", "f", "g", "h"};

        assertEquals(ArrayList { "b", "c", "e", "f", "g", "h" }, list);
        assertEquals(9, list.capacity);
    }

}