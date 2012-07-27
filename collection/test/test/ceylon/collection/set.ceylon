import ceylon.collection { ... }
import com.redhat.ceylon.sdk.test { ... }

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

void testSet2(){
    MutableSet<String> set = HashSet<String>();
    set.add("gravatar_id");
    set.add("url");
    set.add("avatar_url");
    set.add("id");
    set.add("login");
    assertEquals(5, set.size);
}
