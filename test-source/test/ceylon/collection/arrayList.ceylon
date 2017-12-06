import ceylon.collection {
    ArrayList
}
import ceylon.test {
    test,
    assertEquals,
    assertTrue,
    assertThatException
}

shared class ArrayListTest() satisfies MutableListTests {

    createList({String?*} strings) => ArrayList<String?>{ elements = strings; };
    createIterable({String*} strings) => ArrayList<String>{ elements = strings; };

    createRanged = createList;
    createCorrespondence = createList;
    createIterableWithNulls = createList;
    createCategory = createList;

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
    
    test shared void testConstructors() {
        value list = ArrayList.ofSize(2, false);
        assertEquals(list, Array {false, false});
        value copy = ArrayList.copy(list);
        assertEquals(copy, Array {false, false});
    }
    
    test shared void testSwap() {
        value list = ArrayList { 1, 2, 3 };
        list.swap(0, 2);
        assertEquals(list, [3, 2, 1]);
    }
    
    test shared void testMove() {
        value list = ArrayList { 1, 2, 3 };
        list.move(2, 0);
        assertEquals(list, [3, 1, 2]);
    }
    
    test shared void testCopyTo() {
        value list1 = ArrayList { 1, 2, 3 };
        value list2 = ArrayList { 0, 0, 0 };

        list1.copyTo(list2);
        assertEquals(list2, [1, 2, 3]);

        list1.copyTo(list2, 0, 1, 2);
        assertEquals(list2, [1, 1, 2]);

        assertThatException(() => list1.copyTo(list2, 1, 0, 3));
        assertThatException(() => list1.copyTo(list2, 0, 1, 3));
    }
}