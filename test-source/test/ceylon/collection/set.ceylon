import ceylon.collection {
    ...
}
import ceylon.test {
    ...
}

shared interface SetTests satisfies IterableTests {
    shared formal Set<T> createSet<T>({T*} elements) given T satisfies Comparable<T>;

    test shared void testEquals() {
        {[{String*}, [String*]]+} positiveEqualExamples = {
            [{}, []],
            [{"a"}, ["a"]],
            [["A"], ["A"]],
            [{"a", "b", "c", "something"}, ["a", "b", "c", "something"]],
            [{"a", "b", "c", "something"}, ["a", "b", "something", "c"]],
            [{"a", "b", "c"}, ["c", "b", "a"]]
        };

        {[{String*}, {String*}]+} negativeEqualExamples = {
            [{}, [""]],
            [{""}, []],
            [{}, ["a", "b", "c"]],
            [{"M"}, ["m"]],
            [{"b", "c", "d"}, ["c", "d"]]
        };

        for (example in positiveEqualExamples) {
            assertEquals(createSet(example.first), createSet(example.last));
        }
        for (example in negativeEqualExamples) {
            assertNotEquals(createSet(example.first), createSet(example.last));
        }
    }

    test shared actual void testString() {
        assertEquals(createSet({}).string, "{}");
        assertEquals(createSet({"ABC"}).string, "{ ABC }");

        variable value string = createSet({"A", "B", "C", "D"}).string;

        assertTrue(string.contains(" A"));
        string = string.replace(" A", "");
        assertTrue(string.contains(" B"));
        string = string.replace(" B", "");
        assertTrue(string.contains(" C"));
        string = string.replace(" C", "");
        assertTrue(string.contains(" D"));
        string = string.replace(" D", "");

        assertEquals(string, "{,,, }");
    }

    test shared void testUnion() {
        assertEquals(createSet{}.union(createSet{}), createSet{});
        assertEquals(createSet{}.union(createSet{"A"}), createSet{"A"});
        assertEquals(createSet{"A"}.union(createSet{}), createSet{"A"});
        assertEquals(createSet{"A"}.union(createSet{"B"}), createSet{"A", "B"});
        assertEquals(createSet{"A"}.union(createSet{"A", "B", "C", "D"}), createSet{"A", "B", "C", "D"});
        assertEquals(createSet{"A", "B"}.union(createSet{"C", "D"}), createSet{"A", "B", "C", "D"});
        assertEquals(createSet{"A", "B", "C"}.union(createSet{"D"}), createSet{"A", "B", "C", "D"});
        assertEquals(createSet{"A", "B", "C", "D"}.union(createSet{"A", "B", "C"}), createSet{"A", "B", "C", "D"});
    }

    test shared void testExclusiveUnion() {
        assertEquals(createSet{}.exclusiveUnion(createSet{}), createSet{});
        assertEquals(createSet{}.exclusiveUnion(createSet{"A"}), createSet{"A"});
        assertEquals(createSet{"A"}.exclusiveUnion(createSet{}), createSet{"A"});
        assertEquals(createSet{"A"}.exclusiveUnion(createSet{"B"}), createSet{"A", "B"});
        assertEquals(createSet{"A"}.exclusiveUnion(createSet{"A", "B", "C", "D"}), createSet{"B", "C", "D"});
        assertEquals(createSet{"A", "B"}.exclusiveUnion(createSet{"C", "D"}), createSet{"A", "B", "C", "D"});
        assertEquals(createSet{"A", "B", "C"}.exclusiveUnion(createSet{"D"}), createSet{"A", "B", "C", "D"});
        assertEquals(createSet{"A", "B", "C", "D"}.exclusiveUnion(createSet{"A", "B", "C"}), createSet{"D"});
        assertEquals(createSet{"A", "B", "C"}.exclusiveUnion(createSet{"D", "C", "B", "Z"}), createSet{"A", "D", "Z", "D"});
    }

    test shared void testIntersection() {
        assertEquals(createSet{}.intersection(createSet{}), createSet{});
        assertEquals(createSet{}.intersection(createSet{"A"}), createSet{});
        assertEquals(createSet{"A"}.intersection(createSet{}), createSet{});
        assertEquals(createSet{"A", "B", "C"}.intersection(createSet{}), createSet{});
        assertEquals(createSet{"A"}.intersection(createSet{"B"}), createSet{});
        assertEquals(createSet{"A"}.intersection(createSet{"B", "C", "D"}), createSet{});
        assertEquals(createSet{"A"}.intersection(createSet{"A"}), createSet{"A"});
        assertEquals(createSet{"A", "B", "C"}.intersection(createSet{"A"}), createSet{"A"});
        assertEquals(createSet{"A", "B", "C"}.intersection(createSet{"B"}), createSet{"B"});
        assertEquals(createSet{"A"}.intersection(createSet{"A", "B", "C", "D"}), createSet{"A"});
        assertEquals(createSet{"A", "B", "C"}.intersection(createSet{"A", "B", "C"}), createSet{"A", "B", "C"});
        assertEquals(createSet{"A", "B", "C"}.intersection(createSet{"B", "C", "A"}), createSet{"A", "B", "C"});
        assertEquals(createSet{"A", "B", "C"}.intersection(createSet{"Z", "X", "A", "M", "B"}), createSet{"A", "B"});
    }

    test shared void testClone() {
        value set = HashSet {"foo", "bar"};
        assertEquals(set, set.clone());
        assertEquals(set.clone().size, 2);
        assertEquals(set.clone().string, "{ foo, bar }");
        assertEquals([for (s in set.clone()) s], ["foo", "bar"]);
        value linkedSet = HashSet<String>(Stability.linked);
        linkedSet.add("foo");
        linkedSet.add("bar");
        linkedSet.add("baz");
        assertEquals([for (s in linkedSet.clone()) s], ["foo", "bar", "baz"]);
    }

}

test shared void testSetLinkedStabilityEach() {
    value a = ArrayList<Integer>();
    value s = HashSet { 1, 3, 2 };
    s.each((v) => a.add(v));
    assert (a == [1,3,2]);
}
