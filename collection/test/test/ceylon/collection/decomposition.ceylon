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

void testList(){
    MutableList<String> l = LinkedList<String>();
    assertEquals("[]", l.string);
    assertEquals(0, l.size);
    assertTrue(!l.contains("fu"));
    
    l.add("fu");
    assertEquals("[fu]", l.string);
    assertEquals(1, l.size);
    assertEquals("fu", l[0]);
    assertTrue(l.contains("fu"));

    l.add("bar");
    assertEquals("[fu, bar]", l.string);
    assertEquals(2, l.size);
    assertTrue(l.contains("fu"));
    assertTrue(l.contains("bar"));
    assertTrue(!l.contains("stef"));
    assertEquals("fu", l[0]);
    assertEquals("bar", l[1]);

    l.setItem(0, "foo");
    assertEquals("[foo, bar]", l.string);
    assertEquals(2, l.size);
    assertTrue(l.contains("foo"));
    assertTrue(l.contains("bar"));
    assertTrue(!l.contains("fu"));
    assertEquals("foo", l[0]);
    assertEquals("bar", l[1]);

    l.setItem(5, "empty");
    assertEquals("[foo, bar, empty, empty, empty, empty]", l.string);
    assertEquals(6, l.size);
    assertTrue(l.contains("foo"));
    assertTrue(l.contains("bar"));
    assertTrue(l.contains("empty"));
    assertTrue(!l.contains("fu"));
    assertEquals("foo", l[0]);
    assertEquals("bar", l[1]);
    assertEquals("empty", l[5]);

    l.insert(1, "stef");
    assertEquals("[foo, stef, bar, empty, empty, empty, empty]", l.string);
    assertEquals(7, l.size);
    assertTrue(l.contains("foo"));
    assertTrue(l.contains("stef"));
    assertTrue(l.contains("bar"));
    assertTrue(l.contains("empty"));
    assertTrue(!l.contains("fu"));
    assertEquals("foo", l[0]);
    assertEquals("stef", l[1]);
    assertEquals("bar", l[2]);
    assertEquals("empty", l[6]);

    l.insert(0, "first");
    assertEquals("[first, foo, stef, bar, empty, empty, empty, empty]", l.string);
    assertEquals(8, l.size);
    assertTrue(l.contains("first"));
    assertTrue(l.contains("foo"));
    assertTrue(l.contains("stef"));
    assertTrue(l.contains("bar"));
    assertTrue(l.contains("empty"));
    assertTrue(!l.contains("fu"));
    assertEquals("first", l[0]);
    assertEquals("foo", l[1]);
    assertEquals("stef", l[2]);
    assertEquals("bar", l[3]);
    assertEquals("empty", l[7]);

    l.insert(10, "last");
    assertEquals("[first, foo, stef, bar, empty, empty, empty, empty, last, last, last]", l.string);
    assertEquals(11, l.size);
    assertTrue(l.contains("first"));
    assertTrue(l.contains("foo"));
    assertTrue(l.contains("stef"));
    assertTrue(l.contains("bar"));
    assertTrue(l.contains("empty"));
    assertTrue(l.contains("last"));
    assertTrue(!l.contains("fu"));
    assertEquals("first", l[0]);
    assertEquals("foo", l[1]);
    assertEquals("stef", l[2]);
    assertEquals("bar", l[3]);
    assertEquals("empty", l[7]);
    assertEquals("last", l[10]);
    
    l.remove(0);
    assertEquals("[foo, stef, bar, empty, empty, empty, empty, last, last, last]", l.string);
    assertEquals(10, l.size);
    assertTrue(!l.contains("first"));
    assertTrue(l.contains("foo"));
    assertTrue(l.contains("stef"));
    assertTrue(l.contains("bar"));
    assertTrue(l.contains("empty"));
    assertTrue(l.contains("last"));
    assertTrue(!l.contains("fu"));
    assertEquals("foo", l[0]);
    assertEquals("stef", l[1]);
    assertEquals("bar", l[2]);
    assertEquals("empty", l[6]);
    assertEquals("last", l[9]);

    l.remove(1);
    assertEquals("[foo, bar, empty, empty, empty, empty, last, last, last]", l.string);
    assertEquals(9, l.size);
    assertTrue(!l.contains("first"));
    assertTrue(l.contains("foo"));
    assertTrue(!l.contains("stef"));
    assertTrue(l.contains("bar"));
    assertTrue(l.contains("empty"));
    assertTrue(l.contains("last"));
    assertTrue(!l.contains("fu"));
    assertEquals("foo", l[0]);
    assertEquals("bar", l[1]);
    assertEquals("empty", l[5]);
    assertEquals("last", l[8]);

    l.clear();
    assertEquals("[]", l.string);
    assertEquals(0, l.size);
    assertTrue(!l.contains("foo"));
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

void testSet2(){
    MutableSet<String> set = HashSet<String>();
    set.add("gravatar_id");
    set.add("url");
    set.add("avatar_url");
    set.add("id");
    set.add("login");
    assertEquals(5, set.size);
}

class CollectionSuite() extends Suite("ceylon.collection") {
    shared actual Iterable<Entry<String, Callable<Void>>> suite = {
        "Set" -> testSet,
        "Map" -> testMap,
        "List" -> testList,
        "Map2" -> testMap2,
        "Set2" -> testSet2
    };
}

shared void run(){
    CollectionSuite().run();
}
