import ceylon.collection {
    LinkedList
}
import ceylon.test {
    test,
    assertEquals
}

shared class LinkedListTest() satisfies MutableListTests {

    createList({String?*} strings) => LinkedList(strings);

    createRanged = createList;

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
