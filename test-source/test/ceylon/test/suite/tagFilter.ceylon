import ceylon.test {
    test,
    assertEquals
}

import ceylon.test.engine {
    TagFilter
}

test
shared void shouldFilterByTags() {
    void assertTagFilter(String[] filters, String[] tags, Boolean result) {
        assertEquals(TagFilter(filters).filterTestTags(tags), result);
    }
    
    assertTagFilter { filters = []; tags = []; result = true; };
    assertTagFilter { filters = []; tags = ["a"]; result = true; };
    assertTagFilter { filters = ["a"]; tags = ["a"]; result = true; };
    assertTagFilter { filters = ["a", "b"]; tags = ["b", "c"]; result = true; };
    assertTagFilter { filters = ["a", "b", "c"]; tags = ["b"]; result = true; };
    assertTagFilter { filters = ["a", "b", "c"]; tags = ["c", "d"]; result = true; };
    assertTagFilter { filters = ["!a"]; tags = [""]; result = true; };
    assertTagFilter { filters = ["!a"]; tags = ["b"]; result = true; };
    assertTagFilter { filters = ["!a", "b"]; tags = ["b"]; result = true; };
    assertTagFilter { filters = ["!a", "!b"]; tags = ["c"]; result = true; };
    
    assertTagFilter { filters = ["a"]; tags = []; result = false; };
    assertTagFilter { filters = ["a"]; tags = ["b"]; result = false; };
    assertTagFilter { filters = ["a", "b"]; tags = ["c", "d"]; result = false; };
    assertTagFilter { filters = ["!a"]; tags = ["a"]; result = false; };
    assertTagFilter { filters = ["!b"]; tags = ["a", "b", "c"]; result = false; };
    assertTagFilter { filters = ["!a", "b"]; tags = ["a"]; result = false; };
    assertTagFilter { filters = ["!a", "b"]; tags = ["c"]; result = false; };
    assertTagFilter { filters = ["!a", "!b"]; tags = ["a"]; result = false; };
}
