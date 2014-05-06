import ceylon.collection {
    ...
}
import ceylon.test {
    ...
}

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
    assertEquals(map.put("a", "A"), null);
    assertEquals(map.put("b", "B"), null);
    assertEquals(map.put("c", "C"), null);
    assertEquals(map.remove("A"), null);
    assertEquals(map.remove("WHATEVER"), null);
    assertEquals(map.remove("a"), "A");
    assertEquals(map.size, 2);
    assertEquals(map["b"], "B" );
    assertEquals(map["c"], "C" );
    assertEquals(map.remove("a"), null);
    assertEquals(map.remove("b"), "B");
    assertEquals(map.size, 1);
    assertEquals(map["b"], null );
    assertEquals(map["c"], "C" );
    assertEquals(map.put("d", "D"), null);
    assertEquals(map["a"], null );
    assertEquals(map["b"], null );
    assertEquals(map["c"], "C" );
    assertEquals(map["d"], "D" );
    assertEquals(map.size, 2);
    assertEquals(map.remove("b"), null);
    assertEquals(map.remove("c"), "C");
    assertEquals(map.remove("d"), "D");
    assertEquals(map["a"], null );
    assertEquals(map["b"], null );
    assertEquals(map["c"], null );
    assertEquals(map["d"], null );
    assertEquals(map.size, 0);
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

shared test void testMapDefines() {
    value entries = {
        "ceylon.math" -> 0,
        "ceylon.net" -> 0,
        "ceylon.process" -> 0,
        "ceylon.unicode" -> 0,
        "com.redhat.ceylon.test" -> 0,
        "test.ceylon.dbc" -> 0,
        "test.ceylon.file" -> 0,
        "test.ceylon.interop.java" -> 0,
        "test.ceylon.io" -> 0,
        "test.ceylon.math" -> 0,
        "test.ceylon.net" -> 0,
        "test.ceylon.process" -> 0,
        "test.ceylon.test" -> 0
    };
    value map = HashMap { entries = entries; };
    for (entry in entries) {
        assert(map.defines(entry.key));
    }
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
