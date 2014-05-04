import ceylon.collection {
    LinkedList
}
import ceylon.test {
    assertNotEquals,
    test,
    assertEquals
}

shared class LinkedListTest() satisfies MutableListTests {

    createList({String?*} strings) => LinkedList(strings);

    shared test void testLinkedListEquals() {
        assertEquals(LinkedList{"a", "b"}, LinkedList{"a", "b"});
        assertNotEquals(LinkedList{"a", "b"}, LinkedList{"b", "a"});
        assertNotEquals(LinkedList{"a", "b"}, LinkedList{"a", "b", "c"});
        assertNotEquals(LinkedList{"a", "b", "c"}, LinkedList{"a", "b"});
        assertEquals(LinkedList{}, LinkedList{});
    }

    shared test void testLinkedListRest() {
        assertEquals(LinkedList{"b", "c"}, LinkedList{"a", "b", "c"}.rest);
    }

    shared test void testLinkedListReversed() {
        assertEquals(LinkedList{"c", "b", "a"}, LinkedList{"a", "b", "c"}.reversed);
    }

    shared test void testLinkedListSpanFrom() {
        assertEquals(LinkedList{}, LinkedList{"a", "b", "c"}.spanFrom(3));
        assertEquals(LinkedList{"c"}, LinkedList{"a", "b", "c"}.spanFrom(2));
        assertEquals(LinkedList{"b", "c"}, LinkedList{"a", "b", "c"}.spanFrom(1));
    }

    shared test void testLinkedListSpanTo() {
        assertEquals(LinkedList{"a"}, LinkedList{"a", "b", "c"}.spanTo(0));
        assertEquals(LinkedList{"a", "b"}, LinkedList{"a", "b", "c"}.spanTo(1));
        assertEquals(LinkedList{"a", "b", "c"}, LinkedList{"a", "b", "c"}.spanTo(20));
    }

    shared test void testLinkedListSpan() {
        assertEquals(LinkedList{"b", "c"}, LinkedList{"a", "b", "c", "d"}.span(1, 2));
        assertEquals(LinkedList{"b", "c", "d"}, LinkedList{"a", "b", "c", "d"}.span(1, 20));
    }

    shared test void testLinkedListSegment() {
        assertEquals(LinkedList{}, LinkedList{"a", "b", "c"}.segment(0, 0));
        assertEquals(LinkedList{"a", "b"}, LinkedList{"a", "b", "c"}.segment(0, 2));
        assertEquals(LinkedList{"b", "c"}, LinkedList{"a", "b", "c"}.segment(1, 20));
    }

    shared test void testLinkedListConstructor(){
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

}
