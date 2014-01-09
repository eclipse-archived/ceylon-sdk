import ceylon.collection { ... }
import ceylon.test { ... }

void doTestMap(MutableMap<String,String> map) {
    assertEquals("{}", map.string);
    assertEquals(0, map.size);
    assertTrue(!map.defines("fu"), "a");
    assertEquals(null, map.put("fu", "bar"));
    assertEquals("{ fu->bar }", map.string);
    assertEquals(1, map.size);
    assertTrue(map.defines("fu"), "b");
    assertEquals("bar", map.put("fu", "gee"));
    assertEquals("{ fu->gee }", map.string);
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
    assertTrue(!map.defines("fu"), "f"); // equality
}

shared test void testMap(){
    doTestMap(TreeMap<String,String>((String x, String y)=>x<=>y));
    doTestMap(HashMap<String,String>());
}

shared test void testMapEquality() {
    assertEquals(HashMap{}, HashMap{});
    assertEquals(HashMap{"a"->1, "b"->2}, HashMap{"b"->2, "a"->1});
    assertNotEquals(HashMap{"a"->1, "b"->2}, HashMap{"b"->2, "a"->2});
    assertNotEquals(HashMap{"a"->1, "b"->2}, HashMap{"b"->2});
    assertNotEquals(HashMap{"a"->1, "b"->2}, HashMap{});
    
    assertEquals(naturalOrderTreeMap{"a"->1, "b"->2}, naturalOrderTreeMap{"b"->2, "a"->1});
    assertNotEquals(naturalOrderTreeMap{"a"->1, "b"->2}, naturalOrderTreeMap{"b"->2, "a"->2});
    assertNotEquals(naturalOrderTreeMap{"a"->1, "b"->2}, naturalOrderTreeMap{"b"->2});
    assertNotEquals(naturalOrderTreeMap{"a"->1, "b"->2}, naturalOrderTreeMap{});
    assertEquals(naturalOrderTreeMap{}, naturalOrderTreeMap{});
    
    assertEquals(naturalOrderTreeMap{}, HashMap{});
    assertEquals(naturalOrderTreeMap{"a"->1, "b"->2}, HashMap{"b"->2, "a"->1});
}

void doTestMapRemove(MutableMap<String,String> map) {
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

shared test void testMapRemove(){
    doTestMapRemove(HashMap<String,String>());
    doTestMapRemove(TreeMap<String,String>((String x, String y)=>x<=>y));
}

shared test void testMapConstructor(){
    Map<String,String> map = HashMap{"a"->"b", "c"->"d"};
    assertEquals(2, map.size);
    assertEquals("b", map["a"]);
    assertEquals("d", map["c"]);
}

shared test void testMap2(){
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

shared test void testTreeMap() {
    value treeMap = TreeMap<Integer, String> { 
        function compare(Integer x, Integer y) => x<=>y;  
        200->"", 10->"wwwww", 5->"ddddd"
    };
    treeMap.assertInvariants();
    //for (e in treeMap) {
    //    print(e);
    //}
    //print(treeMap);
    assert (treeMap.size==3);
    treeMap.put(1, "hello");
    treeMap.put(2, "world");
    treeMap.put(3, "goodbye");
    treeMap.put(-1, "gavin");
    treeMap.put(2, "everyone");
    treeMap.put(5, "stuff");
    treeMap.put(0, "nothing");
    treeMap.assertInvariants();
    //for (e in treeMap) {
    //    print(e);
    //}
    print(treeMap);
    print(treeMap.higherEntries(4));
    print(treeMap.lowerEntries(4));
    print(treeMap[2..4]);
    print(treeMap[2:4]);
    assert (treeMap.size==8);
    treeMap.remove(5);
    treeMap.remove(-1);
    treeMap.remove(0);
    treeMap.assertInvariants();
    assert (treeMap.size==5);
    treeMap.remove(200);
    treeMap.remove(10);
    treeMap.remove(5);
    treeMap.assertInvariants();
    //for (e in treeMap) {
    //    print(e);
    //}
    //print(treeMap);
    assert (treeMap.size==3);
    
}
