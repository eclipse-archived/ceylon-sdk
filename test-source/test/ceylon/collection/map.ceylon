import ceylon.collection { ... }
import ceylon.test { ... }

test void testMap(){
    MutableMap<String,String> map = HashMap<String,String>();
    assertEquals("{}", map.string);
    assertEquals(0, map.size);
    assertTrue(!map.defines("fu"), "a");

    assertEquals(null, map.put("fu", "bar"));
    assertEquals("{fu->bar}", map.string);
    assertEquals(1, map.size);
    assertTrue(map.defines("fu"), "b");

    assertEquals("bar", map.put("fu", "gee"));
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
    
    // equality
    assertEquals(HashMap{"a"->1, "b"->2}, HashMap{"b"->2, "a"->1});
    assertNotEquals(HashMap{"a"->1, "b"->2}, HashMap{"b"->2, "a"->2});
    assertNotEquals(HashMap{"a"->1, "b"->2}, HashMap{"b"->2});
    assertNotEquals(HashMap{"a"->1, "b"->2}, HashMap{});
    assertEquals(HashMap{}, HashMap{});
}

test void testMapRemove(){
    MutableMap<String,String> map = HashMap<String,String>();
    map.put("a", "b");
    map.put("c", "d");
    assertEquals(2, map.size);
    
    assertEquals("b", map.remove("a"));
    assertEquals(1, map.size);
    assertEquals("d", map["c"]);
    assertEquals(null, map["a"]);

    assertEquals("d", map.remove("c"));
    assertEquals(0, map.size);
    assertEquals(null, map["c"]);
    assertEquals(null, map["a"]);

    assertEquals(null, map.remove("c"));
}

test void testMapConstructor(){
    Map<String,String> map = HashMap{"a"->"b", "c"->"d"};
    assertEquals(2, map.size);
    assertEquals("b", map["a"]);
    assertEquals("d", map["c"]);
}

test void testMap2(){
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
