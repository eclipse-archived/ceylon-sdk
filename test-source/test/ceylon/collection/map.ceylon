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
    assertTrue(!map.defines("fu"), "f");
    
    function toString(Integer i) => i.string;
    
    // clone test
    for (number in 1..100) {
        map.put(number.string, "#" + number.string);
    }
    value clone = map.clone();
    assertEquals(map, clone);
    map.remove("10");
    assertTrue(map.definesEvery((1..9).map(toString)));
    assertTrue(map.definesEvery((11..100).map(toString)));
    assertFalse(map.defines("10"));
    assertTrue(clone.definesEvery((1..100).map(toString)));
    
    clone.removeAll((60..70).map(toString));
    assertTrue(clone.definesEvery((1..59).map(toString)));
    assertTrue(clone.definesEvery((71..100).map(toString)));
    assertFalse(clone.definesAny((60..70).map(toString)));
    assertTrue(map.definesEvery((11..100).map(toString)));
}

shared test void testMap(){
    value treeMap = TreeMap<String,String>((String x, String y)=>x<=>y);
    doTestMap(treeMap);
    treeMap.assertInvariants();
    treeMap.clone().assertInvariants();
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
    value treeMap = TreeMap<Character, Integer> {
        function compare(Character c1, Character c2) => c1 <=> c2;
    };

    assertEquals(treeMap.put('a', 1), null);
    assertEquals(treeMap.put('b', 2), null);
    assertEquals(treeMap.put('c', 3), null);
    treeMap.assertInvariants();

    assertEquals(treeMap.remove('A'), null);
    treeMap.assertInvariants();

    assertEquals(treeMap.remove('W'), null);
    treeMap.assertInvariants();
    assertEquals(treeMap.remove('a'), 1);
    treeMap.assertInvariants();

    assertEquals(treeMap.size, 2);
    assertEquals(treeMap['b'], 2 );
    assertEquals(treeMap['c'], 3 );
    assertEquals(treeMap.remove('a'), null);
    treeMap.assertInvariants();
    assertEquals(treeMap.remove('b'), 2);
    treeMap.assertInvariants();

    assertEquals(treeMap.size, 1);
    assertEquals(treeMap['b'], null );
    assertEquals(treeMap['c'], 3 );
    treeMap.assertInvariants();
    assertEquals(treeMap.put('d', 4), null);
    assertEquals(treeMap['a'], null );
    assertEquals(treeMap['b'], null );
    assertEquals(treeMap['c'], 3 );
    assertEquals(treeMap['d'], 4 );
    assertEquals(treeMap.size, 2);
    assertEquals(treeMap.remove('b'), null);
    assertEquals(treeMap.remove('c'), 3);
    assertEquals(treeMap.remove('d'), 4);
    assertEquals(treeMap['a'], null );
    assertEquals(treeMap['b'], null );
    assertEquals(treeMap['c'], null );
    assertEquals(treeMap['d'], null );
    assertEquals(treeMap.size, 0);

}

test shared void treeMapLowerEntriesTest() {
    value entries = { for (c in 'z'..'a') c -> 0 };
    value map = TreeMap<Character, Integer>((Character x, Character y) => x <=> y, entries);

    assertEquals(map.lowerEntries('0').sequence, []);
    assertEquals(map.lowerEntries('a').sequence, ['a' -> 0]);
    assertEquals(map.lowerEntries('c').sequence, ['c' -> 0, 'b' -> 0, 'a' -> 0]);
}

test shared void treeMapHigherEntriesTest() {
    value entries = { for (c in 'z'..'a') c -> 0 };
    value map = TreeMap<Character, Integer>((Character x, Character y) => x <=> y, entries);

    assertEquals(map.higherEntries('~').sequence, []);
    assertEquals(map.higherEntries('z').sequence, ['z' -> 0]);
    assertEquals(map.higherEntries('x').sequence, ['x' -> 0, 'y' -> 0, 'z' -> 0]);
}

test shared void treeMapRangeTest() {
    value entries = { for (c in 'z'..'a') c -> 0 };
    value map = TreeMap<Character, Integer>((Character x, Character y) => x <=> y, entries);

    assertEquals(map['A'..'Z'].sequence, []);
    assertEquals(map['c'..'f'].sequence, ['c' -> 0, 'd' -> 0, 'e' -> 0, 'f' -> 0]);
    assertEquals(map['y':10].sequence, ['y' -> 0, 'z' -> 0]);
}

test shared void treeMapSegmentTest() {
    value entries = { for (c in 'z'..'a') c -> 0 };
    value map = TreeMap<Character, Integer>((Character x, Character y) => x <=> y, entries);

    assertEquals(map['a':0].sequence, []);
    //assertEquals(map['A':2].sequence, []);
    assertEquals(map['c':4].sequence, ['c' -> 0, 'd' -> 0, 'e' -> 0, 'f' -> 0]);
    assertEquals(map['y':10].sequence, ['y' -> 0, 'z' -> 0]);
}

test shared void treeMapRemoveTest() {

    value entries = { for (c in 'z'..'a') c -> 0 };
    variable value map = TreeMap<Character, Integer>((Character x, Character y) => x <=> y, entries);

    function asEntry(Character c) => c -> 0;

    // simplest-case, remove red leaf without rotation or repainting
    map.remove('a');
    map.assertInvariants();
    assertTrue(map.containsEvery(('b'..'z').map(asEntry)));

    map = TreeMap<Character, Integer>((Character x, Character y) => x <=> y, entries);

    // remove black node with single, red child - no rotation, should just repaint the child black
    map.remove('b');
    map.assertInvariants();
    assertTrue(map.containsEvery(('a'..'a').map(asEntry)));
    assertTrue(map.containsEvery(('c'..'z').map(asEntry)));

    map = TreeMap<Character, Integer>((Character x, Character y) => x <=> y, entries);

    // remove black leaf node whose parent is red, causing a rotation to the right
    map.remove('d');
    map.assertInvariants();
    assertTrue(map.containsEvery(('a'..'c').map(asEntry)));
    assertTrue(map.containsEvery(('e'..'z').map(asEntry)));

    map = TreeMap<Character, Integer>((Character x, Character y) => x <=> y, entries);

    // remove black node with 2 children, left being red, right being black, requiring simple rotation
    map.remove('e');
    map.assertInvariants();
    assertTrue(map.containsEvery(('a'..'d').map(asEntry)));
    assertTrue(map.containsEvery(('f'..'z').map(asEntry)));

    map = TreeMap<Character, Integer>((Character x, Character y) => x <=> y, entries);

    // remove childless black node with red sibling, black parent, red grandparent
    map.remove('f');
    map.assertInvariants();
    assertFalse(map.get('d') is Null);
    assertTrue(map.containsEvery(('a'..'e').map(asEntry)));
    assertTrue(map.containsEvery(('g'..'z').map(asEntry)));

    // remove leaf node whose sibling and parent are black, causing the whole tree to rebalance
    map.remove('v');
    map.assertInvariants();
    assertTrue(map.containsEvery((('a'..'e').map(asEntry))));
    assertTrue(map.containsEvery(('g'..'u').map(asEntry)));
    assertTrue(map.containsEvery(('w'..'z').map(asEntry)));
}

test shared void testMapClone() {
    value map = HashMap {1->"foo", 2->"bar"};
    assertEquals(map, map.clone());
    assertEquals(map.clone().size, 2);
    assertEquals(map.clone().string, "{ 1->foo, 2->bar }");
    value tree = TreeMap { function compare(Integer x, Integer y) => x<=>y; 1->"foo", 2->"bar" };
    assertEquals(tree, tree.clone());
    assertEquals(tree.clone().size, 2);
    assertEquals(tree.clone().string, "{ 1->foo, 2->bar }");
}

