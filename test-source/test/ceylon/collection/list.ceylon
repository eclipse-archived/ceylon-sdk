import ceylon.test {
    test,
    assertEquals,
    assertNotEquals,
    assertNull
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
    
    test shared void testIndexWhere() {
        assertEquals(createList({"A", "B", "C", "B"}).firstIndexWhere("B".equals), 1);
        assertEquals(createList({"A", "B", "C", "B"}).firstIndexWhere("A".equals), 0);
        assertNull(createList({"A", "B", "C", "B"}).firstIndexWhere("D".equals));
        assertEquals(createList({"A", "B", "C", "B"}).lastIndexWhere("B".equals), 3);
        assertEquals(createList({"A", "B", "C", "B"}).lastIndexWhere("A".equals), 0);
        assertNull(createList({"A", "B", "C", "B"}).lastIndexWhere("D".equals));
        assertEquals(createList({"A", "B", "C", "B"}).indexesWhere("B".equals).sequence(), [1,3]);
        assertEquals(createList({"A", "B", "C", "B"}).indexesWhere("A".equals).sequence(), [0]);
        assertEquals(createList({"A", "B", "C", "B"}).indexesWhere("D".equals).sequence(), []);
    }

}
