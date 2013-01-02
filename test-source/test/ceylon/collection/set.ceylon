import ceylon.collection { ... }
import ceylon.test { ... }

void testSet(){
    MutableSet<String> set = HashSet<String>();
    assertEquals("()", set.string);
    assertEquals(0, set.size);

    set.add("fu");
    assertEquals("(fu)", set.string);
    assertTrue(set.contains("fu"));
    assertEquals(1, set.size);

    set.add("fu");
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
}

void testSetRemove(){
    MutableSet<String> set = HashSet<String>();
    set.add("a");
    set.add("b");
    assertEquals(2, set.size);
    
    set.remove("a");
    assertEquals(1, set.size);
    assertFalse(set.contains("a"));
    assertTrue(set.contains("b"));

    set.remove("b");
    assertEquals(0, set.size);
    assertFalse(set.contains("a"));
    assertFalse(set.contains("b"));
}

void testSet2(){
    MutableSet<String> set = HashSet<String>();
    set.add("gravatar_id");
    set.add("url");
    set.add("avatar_url");
    set.add("id");
    set.add("login");
    assertEquals(5, set.size);
}
