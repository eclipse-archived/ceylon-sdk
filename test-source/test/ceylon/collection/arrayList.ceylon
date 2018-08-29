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
    
    test shared void testRemoveWhere() {
        """Executes the given `mutate()` function for each of the following inputs:

           0..10
           null,0..10
           0,null,1..10
           0..10,null

           The `expected` parameter should contain the expected outcome for the first input in the above list. The
           expected outcome is automatically updated to contain the null at the correct position for the other inputs.
           For the third input with null at index 1, the `expectedNullIndexThatWasAtIndexOne` indicates the index where
           in the output the null value is expected to be.
           """
        void testWith(void mutate(ArrayList<Integer?> a), List<Integer> expected, Integer expectedNullIndexThatWasAtIndexOne) {
            for (Anything(ArrayList<Integer?>, Integer) nullInjector in [
                        (ArrayList<Integer?> i, Integer nullIndex) => null,
                        (ArrayList<Integer?> i, Integer nullIndex) => i.insert(0, null),
                        (ArrayList<Integer?> i, Integer nullIndex) => i.insert(nullIndex, null),
                        (ArrayList<Integer?> i, Integer nullIndex) => i.add(null)
            ]) {
                value actual = ArrayList<Integer?> { elements = 0..10; };
                nullInjector(actual, 1);
                mutate(actual);
                value expectedCopy = ArrayList<Integer?> { elements = expected; };
                nullInjector(expectedCopy, expectedNullIndexThatWasAtIndexOne);
                assertEquals(actual, expectedCopy);
            }
        }
        testWith((x) => x.removeWhere((x) => x < 5), 5..10, 0);
        testWith((x) => x.removeWhere((x) => x > 5), 0..5, 1);
        testWith((x) => x.removeWhere((x) => x < 15), [], 0);
        testWith((x) => x.removeWhere((x) => x > 15), 0..10, 1);
        testWith((x) => x.removeWhere((x) => x > 3 && x < 7), (0..3).append(7..10), 1);
    }
}