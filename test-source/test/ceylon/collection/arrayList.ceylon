import ceylon.collection {
    ArrayList
}
import ceylon.test {
    test,
    assertEquals
}

shared test void basicArrayListTests() {
    doListTests(ArrayList<String>());
}

shared test void testArrayListFirstAndLast() {
    List<String> listArray = ArrayList{"a", "b"};
    assertEquals("a", listArray.first);
    assertEquals("b", listArray.last);
}

