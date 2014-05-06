import ceylon.test {
    test,
    assertTrue,
    assertFalse
}

shared interface CategoryTests {

    shared formal Category<String> createCategory({String*} strings);

    test shared void testContains() {
        variable Category<String> category = createCategory {};
        assertFalse(category.contains(""));
        assertFalse(category.contains("A"));
        assertFalse(category.contains("Anything"));

        category = createCategory {"A"};
        assertTrue(category.contains("A"));
        assertFalse(category.contains(""));
        assertFalse(category.contains("B"));

        category = createCategory {"A", "B", "C", "HELLO"};
        assertTrue(category.contains("A"));
        assertTrue(category.contains("B"));
        assertTrue(category.contains("C"));
        assertTrue(category.contains("HELLO"));
        assertFalse(category.contains(""));
        assertFalse(category.contains("D"));
    }

    test shared void testContainsEvery() {
        variable Category<String> category = createCategory {};
        assertTrue(category.containsEvery{});
        assertFalse(category.containsEvery{""});
        assertFalse(category.containsEvery(["0"]));

        category = createCategory {"A"};
        assertTrue(category.containsEvery{"A"});
        assertTrue(category.containsEvery{"A", "A", "A"});
        assertFalse(category.containsEvery{""});
        assertFalse(category.containsEvery{"A", "B"});
        assertFalse(category.containsEvery{"B", "A"});
        assertFalse(category.containsEvery{"A", "A", "B", "A"});

        category = createCategory {"A", "B", "C", "HELLO"};
        assertTrue(category.containsEvery{"A", "B", "C", "HELLO"});
        assertTrue(category.containsEvery{"A", "B", "C", "HELLO", "B", "C", "A"});
        assertTrue(category.containsEvery{"C", "HELLO", "A", "B"});
        assertFalse(category.containsEvery{""});
        assertFalse(category.containsEvery{"D"});
        assertFalse(category.containsEvery{"A", "B", "D"});
        assertFalse(category.containsEvery{"A", "B", "C", "D"});
        assertFalse(category.containsEvery{"A", "B", "C", "HELLO", "D"});
    }

    test shared void testContainsAny() {
        variable Category<String> category = createCategory {};
        assertFalse(category.containsAny{});
        assertFalse(category.containsAny{""});
        assertFalse(category.containsAny(["0"]));
        assertFalse(category.containsAny(["0", "1", "2"]));

        category = createCategory {"A"};
        assertTrue(category.containsAny{"A"});
        assertTrue(category.containsAny{"A", "B"});
        assertTrue(category.containsAny{"B", "A"});
        assertFalse(category.containsAny{""});
        assertFalse(category.containsAny{"a", "b", "D"});
        assertFalse(category.containsAny{"b", "a"});

        category = createCategory {"A", "B", "C", "HELLO"};
        assertTrue(category.containsAny{"A", "B", "C", "HELLO"});
        assertTrue(category.containsAny{"A", "B", "C", "HELLO", "B", "C", "A"});
        assertTrue(category.containsAny{"C", "HELLO", "A", "B"});
        assertTrue(category.containsAny{"Z", "HELLO", "M", "T"});
        assertFalse(category.containsAny{"Z"});
        assertFalse(category.containsAny{"Z", "M"});
        assertFalse(category.containsAny{"Z", "T", "NOT"});
        assertFalse(category.containsAny{""});
    }

}
