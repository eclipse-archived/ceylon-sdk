import ceylon.collection { ... }
import ceylon.test { ... }

void testMap(){
    MutableMap<String,String> map = HashMap<String,String>();
    assertEquals("{}", map.string);
    assertEquals(0, map.size);
    assertTrue(!map.defines("fu"), "a");

    map.put("fu", "bar");
    assertEquals("{fu->bar}", map.string);
    assertEquals(1, map.size);
    assertTrue(map.defines("fu"), "b");

    map.put("fu", "gee");
    assertEquals("{fu->gee}", map.string);
    assertEquals(1, map.size);
    assertTrue(map.defines("fu"), "c");

    map.put("stef", "epardaud");
    assertEquals(2, map.size);
    assertTrue(map.defines("fu"), "d");
    assertTrue(map.defines("stef"), "e");
    

    assertEquals("epardaud", map["stef"]);
    assertEquals("gee", map["fu"]);
    assertEquals(null, map["bar"]);
    
    map.clear();
    assertEquals("{}", map.string);
    assertEquals(0, map.size);
    assertTrue(!map.defines("fu"), "f");
}

void testMapRemove(){
    MutableMap<String,String> map = HashMap<String,String>();
    map.put("a", "b");
    map.put("c", "d");
    assertEquals(2, map.size);
    
    map.remove("a");
    assertEquals(1, map.size);
    assertEquals("d", map["c"]);
    assertEquals(null, map["a"]);

    map.remove("c");
    assertEquals(0, map.size);
    assertEquals(null, map["c"]);
    assertEquals(null, map["a"]);
}

void testMap2(){
    MutableMap<String,String|Integer> map = HashMap<String,String|Integer>();
    map.put("gravatar_id", "a38479e9dc888f68fb6911d4ce05d7cc");
    map.put("url", "https://api.github.com/users/ceylon");
    map.put("avatar_url", "https://secure.gravatar.com/avatar/a38479e9dc888f68fb6911d4ce05d7cc?d=https://a248.e.akamai.net/assets.github.com%2Fimages%2Fgravatars%2Fgravatar-orgs.png");
    map.put("id", 579261);
    map.put("login", "ceylon");
    assertEquals(5, map.size);
    assertEquals(5, map.keys.size);
    assertEquals(5, map.values.size);
}
