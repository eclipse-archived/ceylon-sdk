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
        value list = ArrayList { initialCapacity = 3; elements = { "a", "b", "c" }; };
        assertEquals(3, list.capacity);

        // cause array to grow
        list.add("d");

        assertEquals(ArrayList { "a", "b", "c", "d" }, list);
        assertTrue(list.capacity > 3);
    }

}