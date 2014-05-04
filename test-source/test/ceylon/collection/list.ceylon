import ceylon.collection {
    ...
}
import ceylon.language.meta {
    type
}
import ceylon.test {
    ...
}

shared abstract class MutableListTests() {

    shared formal MutableList<String?> createList({String?*} strings);

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

    test shared void doListTests() {
        value list = createList({});
        assertEquals("{}", list.string);
        assertEquals(0, list.size);
        assertTrue(!list.contains("fu"));
        list.add("fu");
        assertEquals("{ fu }", list.string);
        assertEquals(1, list.size);
        assertEquals("fu", list[0]);
        assertTrue(list.contains("fu"));
        list.add("bar");
        assertEquals("{ fu, bar }", list.string);
        assertEquals(2, list.size);
        assertTrue(list.contains("fu"));
        assertTrue(list.contains("bar"));
        assertTrue(!list.contains("stef"));
        assertEquals("fu", list[0]);
        assertEquals("bar", list[1]);
        list.set(0, "foo");
        assertEquals("{ foo, bar }", list.string);
        assertEquals(2, list.size);
        assertTrue(list.contains("foo"));
        assertTrue(list.contains("bar"));
        assertTrue(!list.contains("fu"));
        assertEquals("foo", list[0]);
        assertEquals("bar", list[1]);
        list.addAll { for (i in 0:4) "empty" };
        assertEquals("{ foo, bar, empty, empty, empty, empty }", list.string);
        assertEquals(6, list.size);
        assertTrue(list.contains("foo"));
        assertTrue(list.contains("bar"));
        assertTrue(list.contains("empty"));
        assertTrue(!list.contains("fu"));
        assertEquals("foo", list[0]);
        assertEquals("bar", list[1]);
        assertEquals("empty", list[5]);
        list.insert(1, "stef");
        assertEquals("{ foo, stef, bar, empty, empty, empty, empty }", list.string);
        assertEquals(7, list.size);
        assertTrue(list.contains("foo"));
        assertTrue(list.contains("stef"));
        assertTrue(list.contains("bar"));
        assertTrue(list.contains("empty"));
        assertTrue(!list.contains("fu"));
        assertEquals("foo", list[0]);
        assertEquals("stef", list[1]);
        assertEquals("bar", list[2]);
        assertEquals("empty", list[6]);
        list.insert(0, "first");
        assertEquals("{ first, foo, stef, bar, empty, empty, empty, empty }", list.string);
        assertEquals(8, list.size);
        assertTrue(list.contains("first"));
        assertTrue(list.contains("foo"));
        assertTrue(list.contains("stef"));
        assertTrue(list.contains("bar"));
        assertTrue(list.contains("empty"));
        assertTrue(!list.contains("fu"));
        assertEquals("first", list[0]);
        assertEquals("foo", list[1]);
        assertEquals("stef", list[2]);
        assertEquals("bar", list[3]);
        assertEquals("empty", list[7]);
        list.insert(8, "last");
        assertEquals("{ first, foo, stef, bar, empty, empty, empty, empty, last }", list.string);
        assertEquals(9, list.size);
        assertTrue(list.contains("first"));
        assertTrue(list.contains("foo"));
        assertTrue(list.contains("stef"));
        assertTrue(list.contains("bar"));
        assertTrue(list.contains("empty"));
        assertTrue(list.contains("last"));
        assertTrue(!list.contains("fu"));
        assertEquals("first", list[0]);
        assertEquals("foo", list[1]);
        assertEquals("stef", list[2]);
        assertEquals("bar", list[3]);
        assertEquals("empty", list[7]);
        assertEquals("last", list[8]);
        list.delete(0);
        assertEquals("{ foo, stef, bar, empty, empty, empty, empty, last }", list.string);
        assertEquals(8, list.size);
        assertTrue(!list.contains("first"));
        assertTrue(list.contains("foo"));
        assertTrue(list.contains("stef"));
        assertTrue(list.contains("bar"));
        assertTrue(list.contains("empty"));
        assertTrue(list.contains("last"));
        assertTrue(!list.contains("fu"));
        assertEquals("foo", list[0]);
        assertEquals("stef", list[1]);
        assertEquals("bar", list[2]);
        assertEquals("empty", list[6]);
        assertEquals("last", list[7]);
        list.delete(1);
        assertEquals("{ foo, bar, empty, empty, empty, empty, last }", list.string);
        assertEquals(7, list.size);
        assertTrue(!list.contains("first"));
        assertTrue(list.contains("foo"));
        assertTrue(!list.contains("stef"));
        assertTrue(list.contains("bar"));
        assertTrue(list.contains("empty"));
        assertTrue(list.contains("last"));
        assertTrue(!list.contains("fu"));
        assertEquals("foo", list[0]);
        assertEquals("bar", list[1]);
        assertEquals("empty", list[5]);
        assertEquals("last", list[6]);
        list.delete(5);
        assertEquals(6, list.size);
        assertEquals("{ foo, bar, empty, empty, empty, last }", list.string);
        list.add("end");
        assertEquals("{ foo, bar, empty, empty, empty, last, end }", list.string);
        assertEquals(7, list.size);
        list.remove("empty");
        assertEquals("{ foo, bar, last, end }", list.string);
        assertEquals(4, list.size);
        list.truncate(3);
        assertEquals("{ foo, bar, last }", list.string);
        assertEquals(3, list.size);
        list.clear();
        assertEquals("{}", list.string);
        assertEquals(0, list.size);
        assertTrue(list.empty);
        assertTrue(!list.contains("foo"));
        assertTrue(list.first is Null);
        assertTrue(list.last is Null);
        list.add("a");
        assertEquals("a", list.first);
        assertEquals("a", list.last);
        list.add("b");
        assertEquals("a", list.first);
        assertEquals("b", list.last);
    }

    test shared void testEquals() {
        for (example in positiveEqualExamples) {
            assertEquals(createList(example.first), createList(example.last));
        }
        for (example in negativeEqualExamples) {
            assertNotEquals(createList(example.first), createList(example.last));
        }
    }

    test shared void testSpan() {
        variable value list = createList {};
        assertEquals(list.span(0, 1), []);
        assertEquals(list.span(-1, 1), []);
        assertEquals(list.span(-10, -5), []);
        assertEquals(list.span(1, -5), []);

        list = createList {"A", "B", "C", "D", "E"};
        assertEquals(list.span(0, 0), ["A"]);
        assertEquals(list.span(0, 1), ["A", "B"]);
        assertEquals(list.span(1, 2), ["B", "C"]);
        assertEquals(list.span(2, 3), ["C", "D"]);
        assertEquals(list.span(0, 20), ["A", "B", "C", "D", "E"]);
        assertEquals(list.span(3, 20), ["D", "E"]);
        assertEquals(list.span(-10, 0), ["A"]);
        assertEquals(list.span(-3, 1), ["A", "B"]);
        assertEquals(list.span(-10, -2), []);
        assertEquals(list.span(1, -2), []);
    }

    test shared void testDeleteSegment() {
        variable value list =  createList {"A", "B", "C", "D", "E", "F"};
        list.deleteSegment(2, 3);
        assertEquals(list, ["A", "B", "F"]);
        assertEquals(list.size, 3);
        list.deleteSegment(1, 5);
        assertEquals(list, ["A"]);
        assertEquals(list.size, 1);
        list.deleteSegment(1, 5);
        assertEquals(list, ["A"]);
        assertEquals(list.size, 1);
        list.deleteSegment(0, -5);
        assertEquals(list, ["A"]);
        assertEquals(list.size, 1);
        list.deleteSegment(-3, -5);
        assertEquals(list, ["A"]);
        assertEquals(list.size, 1);
        list.deleteSegment(-1, 2);
        assertEquals(list, []);
        assertEquals(list.size, 0);
        list.deleteSegment(0, 2);
        assertEquals(list, []);
        assertEquals(list.size, 0);
    }

    test shared void testDeleteSpan() {
        value list =  createList {"A", "B", "C", "D", "E", "F"};
        list.deleteSpan(2, 4);
        assertEquals(list, ["A", "B", "F"]);
        assertEquals(list.size, 3);
        list.deleteSpan(1, 5);
        assertEquals(list, ["A"]);
        assertEquals(list.size, 1);
        list.deleteSpan(2, 4);
        assertEquals(list, ["A"]);
        assertEquals(list.size, 1);
        list.deleteSpan(-2, -1);
        assertEquals(list, ["A"]);
        assertEquals(list.size, 1);
        list.deleteSpan(-1, -2);
        assertEquals(list, ["A"]);
        assertEquals(list.size, 1);
        list.deleteSpan(-1, 1);
        assertEquals(list, []);
        assertEquals(list.size, 0);
        list.deleteSpan(0, 5);
        assertEquals(list, []);
        assertEquals(list.size, 0);
    }

    test shared void testInfill() {
        variable value list = createList {"A", null, "B", "C", null};
        list.infill("Z");
        assertEquals(list, ["A", "Z", "B", "C", "Z"]);
        list.infill("M");
        assertEquals(list, ["A", "Z", "B", "C", "Z"]);
        list.infill(null);
        assertEquals(list, ["A", "Z", "B", "C", "Z"]);

        list.clear();
        list.infill("A");
        assertEquals(list, []);

        list = createList {null};
        list.infill("A");
        assertEquals(list, ["A"]);

        list = createList {null};
        list.infill(null);
        assertEquals(list, [null]);
    }

    test shared void testReversed() {
        variable value list = createList {};
        assertEquals(list.reversed, []);
        list.add("A");
        assertEquals(list.reversed, ["A"]);
        list.add("B");
        assertEquals(list.reversed, ["B", "A"]);
        assertEquals(list, ["A", "B"]);
        list.add(null);
        assertEquals(list.reversed, [null, "B", "A"]);
        assertEquals(list, ["A", "B", null]);
        list.set(0, "C");
        assertEquals(list.reversed, [null, "B", "C"]);
        assertEquals(list, ["C", "B", null]);
        assertEquals(type(list.reversed), type(list));
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
        value list = createList {};
        assertTrue(list.iterator().next() is Finished);
        list.add("A");
        iter = list.iterator();
        assertEquals(iter.next(), "A");
        assertTrue(iter.next() is Finished);
        list.add(null);
        iter = list.iterator();
        assertEquals(iter.next(), "A");
        assertEquals(iter.next(), null);
        assertTrue(iter.next() is Finished);
    }

}
