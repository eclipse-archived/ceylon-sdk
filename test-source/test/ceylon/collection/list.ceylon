import ceylon.collection { ... }
import ceylon.test { ... }

void doListTests(MutableList<String> l) {
    assertEquals("{}", l.string);
    assertEquals(0, l.size);
    assertTrue(!l.contains("fu"));
    l.add("fu");
    assertEquals("{ fu }", l.string);
    assertEquals(1, l.size);
    assertEquals("fu", l[0]);
    assertTrue(l.contains("fu"));
    l.add("bar");
    assertEquals("{ fu, bar }", l.string);
    assertEquals(2, l.size);
    assertTrue(l.contains("fu"));
    assertTrue(l.contains("bar"));
    assertTrue(!l.contains("stef"));
    assertEquals("fu", l[0]);
    assertEquals("bar", l[1]);
    l.set(0, "foo");
    assertEquals("{ foo, bar }", l.string);
    assertEquals(2, l.size);
    assertTrue(l.contains("foo"));
    assertTrue(l.contains("bar"));
    assertTrue(!l.contains("fu"));
    assertEquals("foo", l[0]);
    assertEquals("bar", l[1]); //l.set(5, "empty");
    l.addAll { for (i in 0:4) "empty" };
    assertEquals("{ foo, bar, empty, empty, empty, empty }", l.string);
    assertEquals(6, l.size);
    assertTrue(l.contains("foo"));
    assertTrue(l.contains("bar"));
    assertTrue(l.contains("empty"));
    assertTrue(!l.contains("fu"));
    assertEquals("foo", l[0]);
    assertEquals("bar", l[1]);
    assertEquals("empty", l[5]);
    l.insert(1, "stef");
    assertEquals("{ foo, stef, bar, empty, empty, empty, empty }", l.string);
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
    assertEquals("{ first, foo, stef, bar, empty, empty, empty, empty }", l.string);
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
    l.insert(8, "last");
    assertEquals("{ first, foo, stef, bar, empty, empty, empty, empty, last }", l.string);
    assertEquals(9, l.size);
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
    assertEquals("last", l[8]);
    l.delete(0);
    assertEquals("{ foo, stef, bar, empty, empty, empty, empty, last }", l.string);
    assertEquals(8, l.size);
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
    assertEquals("last", l[7]);
    l.delete(1);
    assertEquals("{ foo, bar, empty, empty, empty, empty, last }", l.string);
    assertEquals(7, l.size);
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
    assertEquals("last", l[6]);
    l.delete(5);
    assertEquals(6, l.size);
    assertEquals("{ foo, bar, empty, empty, empty, last }", l.string);
    l.add("end");
    assertEquals("{ foo, bar, empty, empty, empty, last, end }", l.string);
    assertEquals(7, l.size);
    l.remove("empty");
    assertEquals("{ foo, bar, last, end }", l.string);
    assertEquals(4, l.size);
    l.truncate(3);
    assertEquals("{ foo, bar, last }", l.string);
    assertEquals(3, l.size);
    l.clear();
    assertEquals("{}", l.string);
    assertEquals(0, l.size);
    assertTrue(l.empty);
    assertTrue(!l.contains("foo")); // equality tests
}

shared test void testList(){
    doListTests(ArrayList<String>());
    doListTests(LinkedList<String>());
    assertEquals(LinkedList{"a", "b"}, LinkedList{"a", "b"});
    assertNotEquals(LinkedList{"a", "b"}, LinkedList{"b", "a"});
    assertNotEquals(LinkedList{"a", "b"}, LinkedList{"a", "b", "c"});
    assertNotEquals(LinkedList{"a", "b", "c"}, LinkedList{"a", "b"});
    assertEquals(LinkedList{}, LinkedList{}); // rest
    assertEquals(LinkedList{"b", "c"}, LinkedList{"a", "b", "c"}.rest); // reversed
    assertEquals(LinkedList{"c", "b", "a"}, LinkedList{"a", "b", "c"}.reversed); // span
    assertEquals(LinkedList{}, LinkedList{"a", "b", "c"}.spanFrom(3));
    assertEquals(LinkedList{"c"}, LinkedList{"a", "b", "c"}.spanFrom(2));
    assertEquals(LinkedList{"b", "c"}, LinkedList{"a", "b", "c"}.spanFrom(1));
    assertEquals(LinkedList{"a"}, LinkedList{"a", "b", "c"}.spanTo(0));
    assertEquals(LinkedList{"a", "b"}, LinkedList{"a", "b", "c"}.spanTo(1));
    assertEquals(LinkedList{"a", "b", "c"}, LinkedList{"a", "b", "c"}.spanTo(20));
    assertEquals(LinkedList{"b", "c"}, LinkedList{"a", "b", "c", "d"}.span(1, 2));
    assertEquals(LinkedList{"b", "c", "d"}, LinkedList{"a", "b", "c", "d"}.span(1, 20)); // segment
    assertEquals(LinkedList{}, LinkedList{"a", "b", "c"}.segment(0, 0));
    assertEquals(LinkedList{"a", "b"}, LinkedList{"a", "b", "c"}.segment(0, 2));
    assertEquals(LinkedList{"b", "c"}, LinkedList{"a", "b", "c"}.segment(1, 20));
}

shared test void testListConstructor(){
    List<String> list = LinkedList{"a", "b"};
    assertEquals(2, list.size);
    assertEquals("a", list[0]);
    assertEquals("b", list[1]);
}

"See [ceylon/ceylon-sdk#183](https://github.com/ceylon/ceylon-sdk/issues/183)."
shared test void testLinkedListIssue183(){
    LinkedList<Integer> l = LinkedList<Integer>();
    l.add(1);
    l.add(2);
    l.add(3);
    l.deleteLast();
    l.add(4);
    l.deleteLast(); // in #183, this call crashes
    assertEquals(l.size, 2);
    assertEquals(l, LinkedList{1, 2});
}

"See [comment on ceylon/ceylon-sdk#183](https://github.com/ceylon/ceylon-sdk/issues/183#issuecomment-32129109)"
shared test void testLinkedListOtherIssue183(){
    LinkedList<Integer> l = LinkedList<Integer>();
    l.add(0);
    l.add(1);
    assertEquals(l.delete(1), 1);
    assertEquals(l, LinkedList{0});
}
