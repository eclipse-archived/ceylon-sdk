import ceylon.language.meta {
    type
}
import ceylon.test {
    test,
    assertEquals,
    assertTrue,
    assertNotEquals
}

shared interface ListTests satisfies RangedTests {

    shared formal List<String?> createList({String?*} strings);

    test shared void testEquals() {
        {[{String?*}, {String?*}]+} positiveEqualExamples = {
            [{}, {}],
            [{"a"}, {"a"}],
            [{null}, {null}],
            [{"c", null}, {"c", null}],
            [{"a", "b", "c", "something"}, {"a", "b", "c", "something"}]
        };

        {[{String?*}, {String?*}]+} negativeEqualExamples = {
            [{}, {null}],
            [{null}, {}],
            [{null}, {"a"}],
            [{"a", null}, {null, "a"}],
            [{"M"}, {"m"}],
            [{"b", "c", "d"}, {"c", "d"}],
            [{"a", "b", "c"}, {"c", "b", "a"}]
        };

        for (example in positiveEqualExamples) {
            assertEquals(createList(example.first), createList(example.last));
        }
        for (example in negativeEqualExamples) {
            assertNotEquals(createList(example.first), createList(example.last));
        }
    }

    test shared void testIterator() {
        variable value iter = createList({}).iterator();
        assertTrue(iter.next() is Finished);
        assertTrue(iter.next() is Finished);
        iter = createList({"A"}).iterator();
        assertEquals(iter.next(), "A");
        assertTrue(iter.next() is Finished);
        iter = createList({"A", "B", "C"}).iterator();
        assertEquals(iter.next(), "A");
        assertEquals(iter.next(), "B");
        assertEquals(iter.next(), "C");
        assertTrue(iter.next() is Finished);
    }

    test shared void testReversed() {
        assertEquals(createList({}).reversed, []);
        assertEquals(createList({"A"}).reversed, ["A"]);
        assertEquals(createList({"A", "B", "A", "C"}).reversed, ["C", "A", "B", "A"]);
        assertEquals(type(createList({"A"}).reversed), type(createList({"B"})));
    }

}