import ceylon.collection { ... }
import ceylon.test { ... }

test void testSet() {
    MutableSet<String> set = HashSet<String>();
    assertEquals("()", set.string);
    assertEquals(0, set.size);

    assertEquals(true, set.add("fu"));
    assertEquals("(fu)", set.string);
    assertTrue(set.contains("fu"));
    assertEquals(1, set.size);

    assertEquals(false, set.add("fu"));
    assertEquals("(fu)", set.string);
    assertTrue(set.contains("fu"));
    assertEquals(1, set.size);

    set.add("stef");
    assertTrue(set.contains("fu"));
    assertTrue(set.contains("stef"));
    assertEquals(2, set.size);
    
    assertTrue(!set.contains("bar"));
    
    set.clear();
    assertEquals("()", set.string);
    assertEquals(0, set.size);
    assertTrue(!set.contains("fu"));
    
    // equality
    assertEquals(HashSet{"a", "b", "c"}, HashSet{"c", "a", "b"});
    assertNotEquals(HashSet{"a", "b", "c"}, HashSet{"c", "a"});
    assertNotEquals(HashSet{"a", "b", "c"}, HashSet{});
    assertEquals(HashSet{}, HashSet{});
    
    // unions and shit
    assertEquals(HashSet{"a", 2}, HashSet{"a", "a"}.union(HashSet{2, "a"}));
    assertEquals(HashSet{"b", 2}, HashSet{"a", "b"}.exclusiveUnion(HashSet{2, "a"}));
    assertEquals(HashSet{"a"}, HashSet{"a", "b"}.intersection(HashSet{2, "a"}));
}

test void testSetRemove() {
    MutableSet<String> set = HashSet<String>();
    set.add("a");
    set.add("b");
    assertEquals(2, set.size);
    
    assertEquals(true, set.remove("a"));
    assertEquals(1, set.size);
    assertFalse(set.contains("a"));
    assertTrue(set.contains("b"));

    assertEquals(true, set.remove("b"));
    assertEquals(0, set.size);
    assertFalse(set.contains("a"));
    assertFalse(set.contains("b"));

    assertEquals(false, set.remove("b"));
}

test void testSetConstructor() {
    Set<String> set = HashSet{"a", "b"};
    assertEquals(2, set.size);
    assertTrue(set.contains("a"));
    assertTrue(set.contains("b"));
}

test void testSet2() {
    MutableSet<String> set = HashSet<String>();
    set.add("gravatar_id");
    set.add("url");
    set.add("avatar_url");
    set.add("id");
    set.add("login");
    assertEquals(5, set.size);
}
