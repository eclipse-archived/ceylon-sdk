import ceylon.language.meta {
    type
}
import ceylon.test {
    test,
    assertEquals,
    assertNotEquals
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

}