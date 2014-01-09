import ceylon.collection { ... }
import ceylon.test { ... }

void doSetTests(MutableSet<String> set) {
    assertEquals("{}", set.string);
    assertEquals(0, set.size);
    assertEquals(true, set.add("fu"));
    assertEquals("{ fu }", set.string);
    assertTrue(set.contains("fu"));
    assertEquals(1, set.size);
    assertEquals(false, set.add("fu"));
    assertEquals("{ fu }", set.string);
    assertTrue(set.contains("fu"));
    assertEquals(1, set.size);
    set.add("stef");
    assertTrue(set.contains("fu"));
    assertTrue(set.contains("stef"));
    assertEquals(2, set.size);
    assertTrue(!set.contains("bar"));
    set.clear();
    assertEquals("{}", set.string);
    assertEquals(0, set.size);
    assertTrue(!set.contains("fu")); // equality
}

shared test void testSet() {
    doSetTests(HashSet<String>(unlinked));
    doSetTests(HashSet<String>());
    doSetTests(TreeSet<String>((String x, String y)=>x<=>y));
    
    assertEquals(HashSet{"a", "b", "c"}, HashSet{"c", "a", "b"});
    assertNotEquals(HashSet{"a", "b", "c"}, HashSet{"c", "a"});
    assertNotEquals(HashSet{"a", "b", "c"}, HashSet{});
    assertEquals(HashSet{}, HashSet{}); // unions and shit
    assertEquals(HashSet{"a", 2}, HashSet{"a", "a"}.union(HashSet{2, "a"}));
    assertEquals(HashSet{"b", 2}, HashSet{"a", "b"}.exclusiveUnion(HashSet{2, "a"}));
    assertEquals(HashSet{"a"}, HashSet{"a", "b"}.intersection(HashSet{2, "a"}));
    
    assertEquals(naturalOrderTreeSet{"a", "b", "c"}, naturalOrderTreeSet{"c", "a", "b"});
    assertNotEquals(naturalOrderTreeSet{"a", "b", "c"}, naturalOrderTreeSet{"c", "a"});
    assertNotEquals(naturalOrderTreeSet{"a", "b", "c"}, naturalOrderTreeSet{});
    assertEquals(naturalOrderTreeSet{}, naturalOrderTreeSet{}); // unions and shit
    assertEquals(naturalOrderTreeSet{"a"}, naturalOrderTreeSet{"a", "b"}.intersection(HashSet{2, "a"}));

    assertEquals(HashSet{"a", "b", "c"}, naturalOrderTreeSet{"c", "a", "b"});
    assertEquals(HashSet{}, naturalOrderTreeSet{}); // unions and shit
    
    value set1 = HashSet<String>();
    set1.add("hello");
    set1.add("world");
    set1.add("goodbye");
    set1.add("world");
    set1.add("12345");
    set1.add("!@#$%");
    set1.add("abcde");
    value set2 = HashSet<String>(unlinked);
    set2.add("hello");
    set2.add("world");
    set2.add("goodbye");
    set2.add("world");
    set2.add("12345");
    set2.add("!@#$%");
    set2.add("abcde");
    print (set1.string);
    print (set2.string);
    assert (set1.string=="{ hello, world, goodbye, 12345, !@#$%, abcde }");
    //the actual order is irrelevant:
    assert (set2.string=="{ goodbye, world, hello, abcde, 12345, !@#$% }");
}

shared test void testSetRemove() {
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

shared test void testSetConstructor() {
    Set<String> set = HashSet{"a", "b"};
    assertEquals(2, set.size);
    assertTrue(set.contains("a"));
    assertTrue(set.contains("b"));
}

shared test void testSet2() {
    MutableSet<String> set = HashSet<String>();
    set.add("gravatar_id");
    set.add("url");
    set.add("avatar_url");
    set.add("id");
    set.add("login");
    assertEquals(5, set.size);
}
