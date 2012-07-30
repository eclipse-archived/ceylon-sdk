import ceylon.collection { ... }
import com.redhat.ceylon.sdk.test { ... }

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

