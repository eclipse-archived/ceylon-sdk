import ceylon.test {
    test,
    assertEquals
}

shared interface RangedTests {

    shared formal Ranged<Integer, String?, List<String?>> createRanged({String?*} strings);

    test shared void testSpan() {
        variable value ranged = createRanged {};
        assertEquals(ranged.span(0, 1), []);
        assertEquals(ranged.span(-1, 1), []);
        assertEquals(ranged.span(-10, -5), []);
        assertEquals(ranged.span(1, -5), []);

        ranged = createRanged { "A", "B", "C", "D", "E" };

        assertEquals(ranged.span(0, 0), ["A"]);
        assertEquals(ranged.span(0, 1), ["A", "B"]);
        assertEquals(ranged.span(1, 2), ["B", "C"]);
        assertEquals(ranged.span(2, 3), ["C", "D"]);
        assertEquals(ranged.span(0, 20), ["A", "B", "C", "D", "E"]);
        assertEquals(ranged.span(3, 20), ["D", "E"]);
        assertEquals(ranged.span(5, 20), []);
        assertEquals(ranged.span(3, 1), ["D", "C", "B"]);
        assertEquals(ranged.span(-10, 0), ["A"]);
        assertEquals(ranged.span(-3, 1), ["A", "B"]);
        assertEquals(ranged.span(-10, -2), []);
        assertEquals(ranged.span(1, -2), ["B", "A"]);
        assertEquals(ranged.span(10, -50), ["E", "D", "C", "B", "A" ]);
   }

   test shared void testSpanFrom() {
       variable value ranged = createRanged {};
       assertEquals(ranged.spanFrom(0), []);
       assertEquals(ranged.spanFrom(-1), []);
       assertEquals(ranged.spanFrom(1), []);

       ranged = createRanged {"A", "B", "C", "D", "E"};
       assertEquals(ranged.spanFrom(0), ["A", "B", "C", "D", "E"]);
       assertEquals(ranged.spanFrom(1), ["B", "C", "D", "E"]);
       assertEquals(ranged.spanFrom(4), ["E"]);
       assertEquals(ranged.spanFrom(5), []);
       assertEquals(ranged.spanFrom(6), []);
   }

   test shared void testSpanTo() {
       variable value ranged = createRanged {};
       assertEquals(ranged.spanTo(0), []);
       assertEquals(ranged.spanTo(-1), []);
       assertEquals(ranged.spanTo(1), []);

       ranged = createRanged {"A", "B", "C", "D", "E"};
       assertEquals(ranged.spanTo(10), ["A", "B", "C", "D", "E"]);
       assertEquals(ranged.spanTo(4), ["A", "B", "C", "D", "E"]);
       assertEquals(ranged.spanTo(3), ["A", "B", "C", "D"]);
       assertEquals(ranged.spanTo(0), ["A"]);
       assertEquals(ranged.spanTo(-1), []);
       assertEquals(ranged.spanTo(-10), []);
   }

   test shared void testMeasure() {
       variable value ranged = createRanged {};
       assertEquals(ranged.measure(0, 1), []);
       assertEquals(ranged.measure(-1, 1), []);
       assertEquals(ranged.measure(-10, -5), []);
       assertEquals(ranged.measure(1, -5), []);

       ranged = createRanged {"A", "B", "C", "D", "E"};
       assertEquals(ranged.measure(0, 0), []);
       assertEquals(ranged.measure(0, 1), ["A"]);
       assertEquals(ranged.measure(1, 2), ["B", "C"]);
       assertEquals(ranged.measure(2, 3), ["C", "D", "E"]);
       assertEquals(ranged.measure(0, 20), ["A", "B", "C", "D", "E"]);
       assertEquals(ranged.measure(3, 20), ["D", "E"]);
       assertEquals(ranged.measure(-10, 0), []);
       assertEquals(ranged.measure(-3, 4), ["A"]);
       assertEquals(ranged.measure(-10, -2), []);
       assertEquals(ranged.measure(1, -2), []);
   }

}