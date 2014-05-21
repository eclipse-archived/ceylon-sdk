import ceylon.language.meta {
    type
}
import ceylon.test {
    test,
    assertEquals,
    assertTrue,
    assertNotEquals,
    assertFalse
}

shared interface ListTests satisfies RangedTests & CorrespondenceTests {

    shared formal List<String?> createList({String?*} strings);
    
    test shared void testShorterThan() {
        assertFalse(createList({}).shorterThan(0));
        assertFalse(createList({}).shorterThan(-1));
        assertTrue(createList({}).shorterThan(1));
        assertFalse(createList({"a"}).shorterThan(0));
        assertFalse(createList({"a"}).shorterThan(1));
        assertTrue(createList({"a"}).shorterThan(2));
        value longList = createList((1..100).map(Object.string));
        assertFalse(longList.shorterThan(99));
        assertFalse(longList.shorterThan(100));
        assertTrue(longList.shorterThan(101));
        assertTrue(longList.shorterThan(1000));
    }
    
    test shared void testLongerThan() {
        assertFalse(createList({}).longerThan(0));
        assertFalse(createList({}).longerThan(1));
        assertTrue(createList({}).longerThan(-1));
        assertTrue(createList({"a"}).longerThan(0));
        assertFalse(createList({"a"}).longerThan(1));
        assertFalse(createList({"a"}).longerThan(2));
        value longList = createList((1..100).map(Object.string));
        assertTrue(longList.longerThan(99));
        assertFalse(longList.longerThan(100));
        assertFalse(longList.longerThan(1000));
    }

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

    test shared void testFirst() {
        assertEquals(createList({}).first, null);
        assertEquals(createList({"A"}).first, "A");
        assertEquals(createList({"A", "B"}).first, "A");
        assertEquals(createList({"Z", "B", "C", "D"}).first, "Z");
    }

    test shared void testLast() {
        assertEquals(createList({}).last, null);
        assertEquals(createList({"A"}).last, "A");
        assertEquals(createList({"A", "B"}).last, "B");
        assertEquals(createList({"Z", "B", "C", "D"}).last, "D");
    }

    test shared void testRest() {
        assertEquals(createList({}).rest, []);
        assertEquals(createList({"A"}).rest, []);
        assertEquals(createList({"A", "B"}).rest, ["B"]);
        assertEquals(createList({"A", "B", "C", "D"}).rest, ["B", "C", "D"]);
    }

}