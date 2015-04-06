import ceylon.language.meta {
    type
}
import ceylon.test {
    test,
    assertEquals,
    assertNotEquals,
    assertNull,
    assertTrue,
    assertFalse
}

shared interface ListTests satisfies RangedTests & CorrespondenceTests & InsertionOrderIterableWithNullsTests {

    shared formal List<String?> createList({String?*} strings);

    test shared void testEquals() {
        {[{String?*}, [String?*]]+} positiveEqualExamples = {
            [{}, []],
            [{"a"}, ["a"]],
            [["A"], ["A"]],
            [{null}, [null]],
            [{"c", null}, ["c", null]],
            [{"a", "b", "c", "something"}, ["a", "b", "c", "something"]],
            [["A", "B", "F"], ["A", "B", "F"]]
        };

        {[{String?*}, {String?*}]+} negativeEqualExamples = {
            [{}, [null]],
            [{null}, []],
            [{null}, ["a"]],
            [{"a", null}, [null, "a"]],
            [{"M"}, ["m"]],
            [{"b", "c", "d"}, ["c", "d"]],
            [{"a", "b", "c"}, ["c", "b", "a"]]
        };

        for (example in positiveEqualExamples) {
            assertEquals(createList(example.first), createList(example.last));
            assertEquals(createList(example.first), example.last);

        }
        for (example in negativeEqualExamples) {
            assertNotEquals(createList(example.first), createList(example.last));
            assertNotEquals(createList(example.first), example.last);
        }
    }

    test shared void testReversed() {
        assertEquals(createList({}).reversed, []);
        assertEquals(createList({"A"}).reversed, ["A"]);
        assertEquals(createList({"A", "B", "A", "C"}).reversed, ["C", "A", "B", "A"]);
    }
    
    test shared void testFirstIndexWhere() {
        assertEquals(createList({"A", "B", "C"}).firstIndexWhere("B".equals), 1, "firstIndexWhere(\"B\".equals)");
        assertEquals(createList({"A", "B", "C"}).firstIndexWhere("X".equals), null, "firstIndexWhere(\"X\".equals)");
        assertEquals(createList({"a", "b", "C"}).firstIndexWhere(shuffle(String.any)(Character.uppercase)), 2, "shuffle(String.any)(Character.uppercase))");
    }
    
    test shared void testOccurrences() {
        assertEquals(createList({"A", "B", "C", "B"}).firstOccurrence("B"), 1);
        assertEquals(createList({"A", "B", "C", "B"}).firstOccurrence("A"), 0);
        assertNull(createList({"A", "B", "C", "B"}).firstOccurrence("D"));
        assertEquals(createList({"A", "B", "C", "B"}).lastOccurrence("B"), 3);
        assertEquals(createList({"A", "B", "C", "B"}).lastOccurrence("A"), 0);
        assertNull(createList({"A", "B", "C", "B"}).lastOccurrence("D"));
        assertTrue(createList({"A", "B", "C", "B"}).occurs("B"));
        assertFalse(createList({"A", "B", "C", "B"}).occurs("D"));
        assertEquals(createList({"A", "B", "C", "B"}).occurrences("B").sequence(), [1,3]);
        assertEquals(createList({"A", "B", "C", "B"}).occurrences("A").sequence(), [0]);
        assertEquals(createList({"A", "B", "C", "B"}).occurrences("D").sequence(), []);
    }

}