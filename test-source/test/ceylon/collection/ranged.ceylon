import ceylon.test {
    test,
    assertEquals
}

shared interface RangedTests {

    shared formal Ranged<Integer, List<String?>> createRanged({String?*} strings);

    test shared void testSpan() {
        variable value list = createRanged {};
        assertEquals(list.span(0, 1), []);
        assertEquals(list.span(-1, 1), []);
        assertEquals(list.span(-10, -5), []);
        assertEquals(list.span(1, -5), []);

        list = createRanged {"A", "B", "C", "D", "E"};
        assertEquals(list.span(0, 0), ["A"]);
        assertEquals(list.span(0, 1), ["A", "B"]);
        assertEquals(list.span(1, 2), ["B", "C"]);
        assertEquals(list.span(2, 3), ["C", "D"]);
        assertEquals(list.span(0, 20), ["A", "B", "C", "D", "E"]);
        assertEquals(list.span(3, 20), ["D", "E"]);
        assertEquals(list.span(-10, 0), ["A"]);
        assertEquals(list.span(-3, 1), ["A", "B"]);
        assertEquals(list.span(-10, -2), []);
        assertEquals(list.span(1, -2), []);
   }


}