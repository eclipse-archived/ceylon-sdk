import ceylon.test {
    assertThatException,
    test,
    assertTrue,
    assertEquals,
    assertFalse
}

shared interface IterableWithNullElementsTests satisfies IterableTests {
    
    shared formal {String?*} createIterableWithNulls({String?*} strings);
    
    "Implementation is dependent on how the Iterable type orders its elements"
    test shared formal void testIteratorWithNulls();
    
    "Implementation is dependent on how the Iterable type orders its elements"
    test shared formal void testSkipWhileWithNulls();
    
    "Implementation is dependent on how the Iterable type orders its elements"
    test shared formal void testTakeWhileWithNulls();
    
    test shared void testEmptyWithNulls() {
        assertFalse(createIterableWithNulls({null}).empty);
        assertFalse(createIterableWithNulls({"", null, "", null}).empty);
    }
    
    test shared void testSizeWithNulls() {
        assertEquals(createIterableWithNulls({null}).size, 1);
        assertEquals(createIterableWithNulls({null, "a", "b", "c", "d", "e", "f"}).size, 7);
    }
    
    test shared void testShorterThanWithNulls() {
        assertFalse(createIterableWithNulls({null}).shorterThan(0));
        assertTrue(createIterableWithNulls({null}).shorterThan(2));
        assertFalse(createIterableWithNulls({null, "a"}).shorterThan(2));
    }
    
    test shared void testLongerThanWithNulls() {
        assertTrue(createIterableWithNulls({null}).longerThan(0));
        assertFalse(createIterableWithNulls({null, null}).longerThan(2));
        assertTrue(createIterableWithNulls({null, "a"}).longerThan(1));
    }
    
    test shared default void testFirstWithNulls() {
        assertEquals(createIterableWithNulls({null}).first, null);
        assertEquals(createIterableWithNulls({null, "A"}).first, null);
        assertEquals(createIterableWithNulls({"A", null}).first, "A");
    }
    
    test shared default void testLastWithNulls() {
        assertEquals(createIterableWithNulls({null}).last, null);
        assertEquals(createIterableWithNulls({null, null}).last, null);
    }
    
    test shared default void testSkipWithNulls() {
        assertEquals(createIterableWithNulls({null}).skip(0).sequence(), [null]);
        assertEquals(createIterableWithNulls({null, null}).skip(1).sequence(), [null]);
    }
    
    test shared default void testSequenceWithNulls() {
        assertEquals(createIterableWithNulls({null}).sequence(), [null]);
        assertEquals(createIterableWithNulls({null, null, null}).sequence(), [null, null, null]);
    }
    
    "This test calls [[testMappingFunctionWithNulls]] with the map function.
     If needed, override that method."
    test shared void testMapWithNulls() {
        testMappingFunctionWithNulls(({String?*} strings) => 
            compose(({String?*} it)=>it.sequence(), strings.map<String?>));
    }
    
    "This test calls [[testMappingFunctionWithNulls]] with the collect function.
     If needed, override that method."
    test shared void testCollectWithNulls() {
        testMappingFunctionWithNulls(({String?*} strings) => strings.collect<String?>);
    }
    
    "This function is called by testMapWithNulls and testCollectWithNulls"
    shared default void testMappingFunctionWithNulls({String?*}(String?(String?))({String?*}) map) {
        function str(String? s) => "@" + (s else "null");
        assertEquals(map(createIterableWithNulls {null})(str), ["@null"]);
        assertEquals(map(createIterableWithNulls {null, "a", null})(str), createIterable {"@null", "@a", "@null"});
    }
    
    "This test calls [[testFilteringFunctionWithNulls]] with the filter function.
     If needed, override that method."
    test shared void testFilterWithNulls() {
        testFilteringFunctionWithNulls(({String?*} strings) =>
            compose(({String?*} it)=>it.sequence(), strings.filter));
    }
    
    "This test calls [[testFilteringFunctionWithNulls]] with the select function.
     If needed, override that method."
    test shared void testSelectWithNulls() {
        testFilteringFunctionWithNulls(({String?*} strings) => strings.select);
    }
    
    "This function is called by testFilterWithNulls and testSelectWithNulls"
    shared default void testFilteringFunctionWithNulls({String?*}(Boolean(String?))({String?*}) filter) {
        function short(String? s) => (s?.size else 0) < 3;
        assertEquals(filter(createIterableWithNulls({"a", null, "b", null}))(short),
            createIterableWithNulls {"a", null, "b", null});
        assertEquals(filter(createIterableWithNulls({null, "abcde", "fghijklmnopqrstuvxzwy", "b"}))(short),
            createIterableWithNulls {null, "b"});
    }
    
    test shared default void testRestWithNulls() {
        assertEquals(createIterableWithNulls({null}).rest.sequence(), []);
        assertEquals(createIterableWithNulls({null, null, null}).rest.sequence(), [null, null]);
    }
    
    test shared default void testReduceWithNulls() {
        function addStrings(String? partial, String? elem) => (partial else "null") + ", " + (elem else "null");
        assertEquals(createIterableWithNulls({null}).reduce(addStrings), null);
        assertEquals(createIterableWithNulls({null, "a"}).reduce(addStrings), "null, a");
    }
    
    test shared default void testFindWithNulls() {
        function afterX(String? string) => (string else "z") > "x";
        assertEquals(createIterableWithNulls({null}).find(afterX), null);
        assertEquals(createIterableWithNulls({null, "a", null}).find(afterX), null);
    }
    
    test shared default void testFindLastWithNulls() {
        function large(String? string) => (string else "").size > 2;
        assertEquals(createIterableWithNulls({null}).findLast(large), null);
        assertEquals(createIterableWithNulls({null, "abc", "a", null, "b"}).findLast(large), "abc");
    }
    
    test shared default void testSortWithNulls() {
        function comparing(String? s1, String? s2) => (s1 else "") <=> (s2 else "");
        assertEquals(createIterableWithNulls({null}).sort(comparing), [null]);
        assertEquals(createIterableWithNulls({null, "c", "a", null, "b"}).sort(comparing), [null, null, "a", "b", "c"]);
    }
    
    test shared default void testAnyWithNulls() {
        function afterX(String? string) => (string else "a") > "x";
        assertFalse(createIterableWithNulls({null}).any(afterX));
        assertFalse(createIterableWithNulls({"b", null}).any(afterX));
        assertTrue(createIterableWithNulls({null, "b", null, "z", null}).any(afterX));
    }
    
    test shared default void testEveryWithNulls() {
        function afterX(String? string) => (string else "a") > "x";
        assertFalse(createIterableWithNulls({null}).every(afterX));
        assertFalse(createIterableWithNulls({"y", null, "z"}).every(afterX));
    }
    
    test shared default void testTakeWithNulls() {
        assertEquals(createIterableWithNulls({null}).take(0).sequence(), []);
        assertEquals(createIterableWithNulls({null}).take(1).sequence(), [null]);
        value iterable = createIterableWithNulls {"a", null, "b", null, "c"};
        value iterator = iterable.iterator();
        assertEquals(iterable.take(3).sequence(), [iterator.next(), iterator.next(), iterator.next()]);
    }
        
    test shared default void testByWithNulls() {
        assertEquals(createIterableWithNulls({null}).by(1).sequence(), [null]);
        assertEquals(createIterableWithNulls({null}).by(2).sequence(), [null]);

        value iterable = createIterableWithNulls {"a", null, null, "z", null};
        value iterator = iterable.iterator();
        value first = iterator.next();
        iterator.next();
        iterator.next();
        value second = iterator.next();
        assertEquals(iterable.by(3).sequence(), [first, second]);
    }
    
    test shared void byDoesNotAcceptValueSmallerThanOneWithNulls() {
        assertThatException(() => createIterableWithNulls({null}).by(0));
    }
    
    test shared default void testCountWithNulls() {
        function lessThanJ(String? s) => (s else "a") < "j";
        assertEquals(createIterableWithNulls({null}).count(lessThanJ), 1);
        assertEquals(createIterableWithNulls({"a", null, "i", "j", "k", null}).count(lessThanJ), 4);
    }
    
    test shared default void testCoalescedWithNulls() {
        assertEquals(createIterableWithNulls({null}).coalesced.sequence(), []);
        assertEquals(createIterableWithNulls({"a", null}).coalesced.sequence(), ["a"]);
        assertEquals(createIterableWithNulls({null, "a", null, "b", "c", null, "d"}).coalesced.sequence(), createIterable {"a", "b", "c", "d"});
    }
    
    test shared default void testIndexedWithNulls() {
        assertEquals(createIterableWithNulls({null}).indexed.sequence(), [0->null]);
        
        value iterable = createIterableWithNulls {"a", null, "b", "c", null}; 
        value iterator = iterable.iterator();
        value indexes = [0, 1, 2, 3, 4].iterator();
        assertEquals(iterable.indexed.sequence(), [
            next<Integer>(indexes) -> next<String?>(iterator),
            next<Integer>(indexes) -> next<String?>(iterator),
            next<Integer>(indexes) -> next<String?>(iterator),
            next<Integer>(indexes) -> next<String?>(iterator),
            next<Integer>(indexes) -> next<String?>(iterator) ]);
    }
    
    test shared default void testFollowingWithNulls() {
        assertEquals(createIterableWithNulls({null}).follow("abc").sequence(), ["abc", null]);
        value iterable = createIterableWithNulls {"a", null, "c", null};
        value iterator = iterable.iterator();
        assertEquals(iterable.follow("abc").sequence(), ["abc", iterator.next(), iterator.next(), iterator.next(), iterator.next()]);
    }
    
    test shared default void testChainWithNulls() {
        assertEquals(createIterableWithNulls({null}).chain({}).sequence(), [null]);
        assertEquals(createIterableWithNulls({null}).chain({null}).sequence(), [null, null]);
        value iterable = createIterableWithNulls {"a", null, "b"};
        value iterator = iterable.iterator();
        assertEquals(iterable.chain({null, "c"}).sequence(), [iterator.next(), iterator.next(), iterator.next(), null, "c"]);
    }
    
    test shared default void testDefaultNullElementsWithNulls() {
        assertEquals(createIterableWithNulls({null}).defaultNullElements("X").sequence(), ["X"]);
        assertEquals(createIterableWithNulls({"a", "X", null}).defaultNullElements("X").sequence(), createIterable {"a", "X", "X"});
        assertEquals(createIterableWithNulls({null, "a"}).defaultNullElements("X").sequence(), createIterable {"X", "a"});
        assertEquals(createIterableWithNulls({null, null, null}).defaultNullElements("X").sequence(), createIterable {"X", "X", "X"});
        assertEquals(createIterableWithNulls({null, "a", null, "b", null}).defaultNullElements("X").sequence(), createIterable {"X", "a", "X", "b", "X"});
    }
    
    test shared default void testStringWithNulls() {
        testStringWith(createIterableWithNulls({null, "Hello", "world!", null}));
    }
    
    test shared default void testCycledWithNulls() {
        value abcCycledIterator = createIterableWithNulls({null, "A", "B", null, "C"}).cycled.iterator();
        for (i in 1..10) {
            for (item in createIterableWithNulls {null, "A", "B", null, "C"}) {
                assertEquals(abcCycledIterator.next(), item);    
            }
        }
    }
    
    "This test calls [[testRepeatFunctionWithNulls]] with the repeat function.
     If needed, override that method."
    test shared void testRepeatWithNulls() {
        testRepeatFunctionWithNulls(({String?*} strings) => 
            compose(({String?*} it)=>it.sequence(), strings.repeat));
    }
        
    "This function is called by [[testRepeatWithNulls]]."
    shared default void testRepeatFunctionWithNulls(List<String?>(Integer)({String?*}) cycle) {
        assertEquals(cycle(createIterableWithNulls {null})(1), [null]);
        assertEquals(cycle(createIterableWithNulls {"a", null, "c"})(3),
            createIterableWithNulls({"a", null, "c", "a", null, "c", "a", null, "c"}));
    }
    
}

shared interface InsertionOrderIterableWithNullsTests
    satisfies IterableWithNullElementsTests & InsertionOrderIterableTests {
    
    test shared actual default void testIteratorWithNulls() {
        assertEquals(createIterableWithNulls({null}).iterator().next(), null);
        value iter = createIterableWithNulls({null, "a", "b", null, "c"}).iterator();
        assertEquals(iter.next(), null);
        assertEquals(iter.next(), "a");
        assertEquals(iter.next(), "b");
        assertEquals(iter.next(), null);
        assertEquals(iter.next(), "c");
        assertTrue(iter.next() is Finished);
    }
    
    test shared actual default void testSkipWhileWithNulls() {
        function lessThanJ(String? s) => (s else "a") < "j";
        assertEquals(createIterableWithNulls({null}).skipWhile(lessThanJ).sequence(), []);
        assertEquals(createIterableWithNulls({"i", null, "j", null, "k"}).skipWhile(lessThanJ).sequence(), ["j", null, "k"]);
    }
    
    shared actual void testTakeWhileWithNulls() {
        function lessThanJ(String? s) => (s else "a") < "j";
        assertEquals(createIterableWithNulls({null}).takeWhile(lessThanJ).sequence(), [null]);
        assertEquals(createIterableWithNulls({"i", null, "j", null, "k"}).takeWhile(lessThanJ).sequence(), ["i", null]);
    }
    
}

shared interface NaturalOrderIterableWithNullsTests
    satisfies IterableWithNullElementsTests & NaturalOrderIterableTests {
    
    test shared actual default void testIteratorWithNulls() {
        assertEquals(createIterableWithNulls({null}).iterator().next(), null);
        value iter = createIterableWithNulls({null, "B", "D", null}).iterator();
        assertEquals(iter.next(), null);
        assertEquals(iter.next(), null);
        assertEquals(iter.next(), "B");
        assertEquals(iter.next(), "D");
        assertTrue(iter.next() is Finished);
    }
    
    test shared actual default void testSkipWhileWithNulls() {
        function lessThanJ(String? s) => (s else "a") < "j";
        assertEquals(createIterableWithNulls({null}).skipWhile(lessThanJ).sequence(), []);
        assertEquals(createIterableWithNulls({"i", null, "j", null, "k"}).skipWhile(lessThanJ).sequence(), ["j", null, "k"]);
    }
    
    shared actual void testTakeWhileWithNulls() {
        function lessThanJ(String? s) => (s else "a") < "j";
        assertEquals(createIterableWithNulls({null}).takeWhile(lessThanJ).sequence(), [null]);
        assertEquals(createIterableWithNulls({"i", null, "j", null, "k"}).takeWhile(lessThanJ).sequence(), ["i", null]);
    }
    
}


shared interface HashOrderIterableWithNullsTests
    satisfies IterableWithNullElementsTests & HashOrderIterableTests {
    
    test shared actual void testIteratorWithNulls() {
        assertEquals(createIterableWithNulls({null}).iterator().next(), null);
        value iter = createIterableWithNulls({null, "A", "B", null, "C", null}).iterator();
        value items = [iter.next(), iter.next(), iter.next(), iter.next(), iter.next(), iter.next()];
        assertTrue(items.contains("A"));
        assertTrue(items.contains("B"));
        assertTrue(items.contains("C"));
        assertEquals(items.filter((Anything elem) => elem is Null).size, 3);
        assertTrue(items.contains(finished));
    }
    
    test shared actual default void testSkipWhileWithNulls() {
        function lessThanJ(String? s) => (s else "a") < "j";
        assertEquals(createIterableWithNulls({null}).skipWhile(lessThanJ).sequence(), []);
        assertEquals(createIterableWithNulls({"i", null, "j", null, "k"}).skipWhile(lessThanJ).sequence(), ["j", null, "k"]);
    }
    
    shared actual void testTakeWhileWithNulls() {
        function lessThanJ(String? s) => (s else "a") < "j";
        assertEquals(createIterableWithNulls({null}).takeWhile(lessThanJ).sequence(), [null]);
        assertEquals(createIterableWithNulls({"i", null, "j", null, "k"}).takeWhile(lessThanJ).sequence(), ["i", null]);
    }

}
