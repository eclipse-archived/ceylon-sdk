import ceylon.test {
    test,
    assertTrue,
    assertFalse,
    assertEquals,
    assertThatException
}
import ceylon.collection { StringBuilder }

shared interface IterableTests satisfies CategoryTests {
    
    shared formal {String*} createIterable({String*} strings);
    
    test shared void testEmpty() {
        assertTrue(createIterable({}).empty);
        assertFalse(createIterable({""}).empty);
        assertFalse(createIterable({"", "", "", "", ""}).empty);
    }
    
    test shared void testSize() {
        assertEquals(createIterable({}).size, 0);
        assertEquals(createIterable({""}).size, 1);
        assertEquals(createIterable({"", "a"}).size, 2);
        assertEquals(createIterable({"", "a", "b", "c", "d", "e", "f"}).size, 7);
    }
    
    test shared void testShorterThan() {
        assertFalse(createIterable({}).shorterThan(0));
        assertFalse(createIterable({}).shorterThan(-1));
        assertTrue(createIterable({}).shorterThan(1));
        assertFalse(createIterable({"a"}).shorterThan(0));
        assertFalse(createIterable({"a"}).shorterThan(1));
        assertTrue(createIterable({"a"}).shorterThan(2));
        value longList = createIterable((1..100).map(Object.string));
        assertFalse(longList.shorterThan(99));
        assertFalse(longList.shorterThan(100));
        assertTrue(longList.shorterThan(101));
        assertTrue(longList.shorterThan(1000));
    }
    
    test shared void testLongerThan() {
        assertFalse(createIterable({}).longerThan(0));
        assertFalse(createIterable({}).longerThan(1));
        assertTrue(createIterable({}).longerThan(-1));
        assertTrue(createIterable({"a"}).longerThan(0));
        assertFalse(createIterable({"a"}).longerThan(1));
        assertFalse(createIterable({"a"}).longerThan(2));
        value longList = createIterable((1..100).map(Object.string));
        assertTrue(longList.longerThan(99));
        assertFalse(longList.longerThan(100));
        assertFalse(longList.longerThan(1000));
    }

    "Implementation is dependent on how the Iterable type orders its elements"
    test shared formal void testIterator();
    
    test shared default void testFirst() {
        assertEquals(createIterable({}).first, null);
        assertEquals(createIterable({"A"}).first, "A");
        
        variable value iterable = createIterable {"A", "B"};
        variable value iterator = iterable.iterator();
        assertEquals(iterable.first, iterator.next());
        
        iterable = createIterable {"Z", "B", "C", "D"};
        iterator = iterable.iterator();
        assertEquals(iterable.first, iterator.next());
    }
    
    test shared default void testLast() {
        assertEquals(createIterable({}).last, null);
        assertEquals(createIterable({"A"}).last, "A");
        value iterable = createIterable {"Z", "B", "C", "D"};
        value iterator = iterable.iterator();
        for (i in 0:3) {
            iterator.next();
        }
        assertEquals(iterable.last, iterator.next());
    }
    
    test shared default void testSkip() {
        assertEquals(createIterable({}).skip(0).sequence(), []);
        assertEquals(createIterable({}).skip(1).sequence(), []);
        assertEquals(createIterable({}).skip(-1).sequence(), []);
        assertEquals(createIterable({"A"}).skip(0).sequence(), ["A"]);
        assertEquals(createIterable({"A"}).skip(1).sequence(), []);
        assertEquals(createIterable({"A"}).skip(-1).sequence(), ["A"]);
        assertEquals(createIterable({"A", "B", "C"}).skip(0).sequence(), createIterable({"A", "B", "C"}).sequence());
        assertEquals(createIterable({"A", "B", "C"}).skip(-1).sequence(), createIterable({"A", "B", "C"}).sequence());
        
        value iterable = createIterable({"a", "b", "c"});
        value iterator = iterable.iterator();
        iterator.next();
        assertEquals(iterable.skip(1).sequence(), [iterator.next(), iterator.next()]);
    }
    
    "Implementation is dependent on how the Iterable type orders its elements"
    test shared formal void testSkipWhile();
    
    test shared default void testSequence() {
        assertEquals(createIterable({}).sequence(), []);
        assertEquals(createIterable({"A"}).sequence(), ["A"]);
        assertEquals(createIterable({"A", "B", "C"}).sequence(), createIterable({"A", "B", "C"}).sequence());
    }
    
    "This test calls [[testMappingFunction]] with the map function.
     If needed, override that method."
    test shared void testMap() {
        testMappingFunction(({String*} strings) => 
            compose(({String*} it)=>it.sequence(), strings.map<String>));
    }

    "This test calls [[testMappingFunction]] with the collect function.
     If needed, override that method."
    test shared void testCollect() {
        testMappingFunction(({String*} strings) => strings.collect<String>);
    }
    
    "This function is called by testMap and testCollect"
    shared default void testMappingFunction({String*}(String(String))({String*}) map) {
        function str(String? s) => "@" + (s else "null");
        assertEquals(map(createIterable {})(str).sequence(), []);
        assertEquals(map(createIterable {"a"})(str).sequence(), ["@a"]);
        assertEquals(map(createIterable {"a", "b", "c"})(str).sequence(), createIterable({"@a", "@b", "@c"}).sequence());
    }
    
    "This test calls [[testFilteringFunction]] with the filter function.
     If needed, override that method."
    test shared void testFilter() {
        testFilteringFunction(({String*} strings) =>
            compose(({String*} it)=>it.sequence(), strings.filter));
    }
    
    "This test calls [[testFilteringFunction]] with the select function.
     If needed, override that method."
    test shared void testSelect() {
        testFilteringFunction(({String*} strings) => strings.select);
    }
    
    "This function is called by testFilter and testSelect"
    shared default void testFilteringFunction({String*}(Boolean(String))({String*}) filter) {
        function short(String? s) => (s?.size else 0) < 3;
        assertEquals(filter(createIterable({}))(short), []);
        assertEquals(filter(createIterable({"a"}))(short), ["a"]);
        assertEquals(filter(createIterable({"abcde"}))(short), []);
        assertEquals(filter(createIterable({"a", "abcde", "fghijklmnopqrstuvxzwy", "b"}))(short), createIterable({"a", "b"}).sequence());
    }
    
    test shared default void testRest() {
        assertEquals(createIterable({}).rest.sequence(), []);
        assertEquals(createIterable({"A"}).rest.sequence(), []);
        
        variable value iterable = createIterable {"A", "B"};
        variable value iterator = iterable.iterator();
        iterator.next();
        assertEquals(iterable.rest.sequence(), [iterator.next()]);
        
        iterable = createIterable {"A", "B", "C", "D"};
        iterator = iterable.iterator();
        iterator.next();
        assertEquals(iterable.rest.sequence(), [iterator.next(), iterator.next(), iterator.next()]);
    }
    
    test shared default void testReduce() {
        function addStrings(String partial, String elem) => partial+ ", " + elem;
        assertEquals(createIterable({}).reduce(addStrings), null);
        assertEquals(createIterable({"a"}).reduce(addStrings), "a");
        
        variable value iterable = createIterable {"a", "b"};
        variable value iterator = iterable.iterator();
        assertEquals(iterable.reduce(addStrings), addStrings(next<String>(iterator), next<String>(iterator)));
        
        iterable = createIterable(('a'..'z').map(Object.string));
        iterator = iterable.iterator();
        value resultBuilder = StringBuilder();
        resultBuilder.append(next<String>(iterator));
        while (is String item = iterator.next()) {
            resultBuilder.append(", ").append(item);
        }
        assertEquals(iterable.reduce(addStrings), resultBuilder.string);
    }
    
    test shared default void testFind() {
        function afterX(String string) => string > "x";
        assertEquals(createIterable({}).find(afterX), null);
        assertEquals(createIterable({"a"}).find(afterX), null);
        assertEquals(createIterable({"x", "z"}).find(afterX), "z");
        assertEquals(createIterable(('a'..'z').map(Object.string)).find(afterX), "y");
        assertEquals(createIterable(('a'..'x').map(Object.string)).find(afterX), null);
    }
    
    test shared default void testFindLast() {
        function large(String? string) => (string else "").size > 2;
        assertEquals(createIterable({}).findLast(large), null);
        assertEquals(createIterable({"a"}).findLast(large), null);
        assertEquals(createIterable(('a'..'z').map(Object.string)).findLast(large), null);
        assertEquals(createIterable({"abc"}).findLast(large), "abc");
        value iterable = createIterable {"a", "abc", "x", "nm", "cde", "v"};
        value largeItems = iterable.select(large);
        assertEquals(largeItems.size, 2);
        value iterator = largeItems.iterator();
        iterator.next();
        assertEquals(iterable.findLast(large), iterator.next());
    }
    
    test shared default void testSort() {
        function comparing(String s1, String s2) => s1 <=> s2;
        assertEquals(createIterable({}).sort(comparing), []);
        assertEquals(createIterable({"a"}).sort(comparing), ["a"]);
        assertEquals(createIterable({"a", "b", "c"}).sort(comparing), ["a", "b", "c"]);
        assertEquals(createIterable({"c", "a", "b"}).sort(comparing), ["a", "b", "c"]);
        assertEquals(createIterable({"c", "a", "d", "b", "z"}).sort(comparing), ["a", "b", "c", "d", "z"]);
    }
    
    test shared default void testAny() {
        function afterX(String string) => string > "x";
        assertFalse(createIterable({}).any(afterX));
        assertFalse(createIterable({"a"}).any(afterX));
        assertTrue(createIterable({"x", "z"}).any(afterX));
        assertTrue(createIterable(('a'..'z').map(Object.string)).any(afterX));
        assertFalse(createIterable(('a'..'x').map(Object.string)).any(afterX));
    }
    
    test shared default void testEvery() {
        function afterX(String string) => string > "x";
        assertTrue(createIterable({}).every(afterX));
        assertFalse(createIterable({"a"}).every(afterX));
        assertFalse(createIterable({"x", "z"}).every(afterX));
        assertTrue(createIterable({"y", "z"}).every(afterX));
        assertFalse(createIterable(('a'..'z').map(Object.string)).every(afterX));
        assertTrue(createIterable(('y'..'~').map(Object.string)).every(afterX));
    }
    
    test shared default void testTake() {
        assertEquals(createIterable({}).take(0).sequence(), []);
        assertEquals(createIterable({"a"}).take(0).sequence(), []);
        assertEquals(createIterable({"a", "b", "c"}).take(0).sequence(), []);
        assertEquals(createIterable({}).take(-1).sequence(), []);
        assertEquals(createIterable({"a"}).take(-1).sequence(), []);
        assertEquals(createIterable({"a", "b", "c"}).take(-10).sequence(), []);
        assertEquals(createIterable({"a"}).take(1).sequence(), ["a"]);
        assertEquals(createIterable({"a"}).take(2).sequence(), ["a"]);
        
        variable value iterable = createIterable({"a", "b", "c"});
        variable value iterator = iterable.iterator();
        assertEquals(iterable.take(1).sequence(), [iterator.next()]);
        
        iterator = iterable.iterator();
        assertEquals(iterable.take(2).sequence(), [iterator.next(), iterator.next()]);
        
        iterator = iterable.iterator();
        assertEquals(iterable.take(3).sequence(), [iterator.next(), iterator.next(), iterator.next()]);
    }
    
    "Implementation is dependent on how the Iterable type orders its elements"
    test shared formal void testTakeWhile();
    
    test shared default void testBy() {
        assertEquals(createIterable({}).by(1).sequence(), []);
        assertEquals(createIterable({}).by(2).sequence(), []);
        assertEquals(createIterable({"a"}).by(1).sequence(), ["a"]);
        assertEquals(createIterable({"a", "b", "c"}).by(1).sequence(), createIterable {"a", "b", "c"}.sequence());
        
        value iterable = createIterable {"a", "b", "c", "d", "e", "f", "g"};
        value iterator = iterable.iterator();
        value first = iterator.next();
        iterator.next();
        iterator.next();
        value second = iterator.next();
        iterator.next();
        iterator.next();
        value third = iterator.next();
        assertEquals(iterable.by(3).sequence(), [first, second, third]);
    }
    
    test shared void byDoesNotAcceptValueSmallerThanOne() {
        assertThatException(() => createIterable({}).by(0));
        assertThatException(() => createIterable({}).by(-1));
        assertThatException(() => createIterable({"a", "b"}).by(-5));
    }
    
    test shared default void testCount() {
        function lessThanJ(String s) => s < "j";
        assertEquals(createIterable({}).count(lessThanJ), 0);
        assertEquals(createIterable({"a"}).count(lessThanJ), 1);
        assertEquals(createIterable({"a", "b", "c"}).count(lessThanJ), 3);
        assertEquals(createIterable({"z"}).count(lessThanJ), 0);
        assertEquals(createIterable({"a", "z"}).count(lessThanJ), 1);
        assertEquals(createIterable({"z", "c", "j", "m"}).count(lessThanJ), 1);
    }
    
    test shared default void testCoalesced() {
        assertEquals(createIterable({}).coalesced.sequence(), []);
        assertEquals(createIterable({"a"}).coalesced.sequence(), ["a"]);
        assertEquals(createIterable({"a", "b", "c"}).coalesced.sequence(), createIterable({"a", "b", "c"}).sequence());
    }
 
    test shared default void testIndexed() {
        assertEquals(createIterable({}).indexed.sequence(), []);
        assertEquals(createIterable({"a"}).indexed.sequence(), [0->"a"]);
        
        value iterable = createIterable {"a", "b", "c"};
        value iterator = iterable.iterator();
        assertEquals(iterable.indexed.sequence(), [
            0 -> next<String>(iterator),
            1 -> next<String>(iterator),
            2 -> next<String>(iterator) ]);
    }
    
    test shared default void testFollowing() {
        assertEquals(createIterable({}).follow("a").sequence(), ["a"]);
        assertEquals(createIterable({"a"}).follow("abc").sequence(), ["abc", "a"]);
        value iterable = createIterable {"a", "z", "c", "x"};
        value iterator = iterable.iterator();
        assertEquals(iterable.follow("abc").sequence(), ["abc", iterator.next(), iterator.next(), iterator.next(), iterator.next()]);
    }
    
    test shared default void testChain() {
        assertEquals(createIterable({}).chain({}).sequence(), []);
        assertEquals(createIterable({"a"}).chain({}).sequence(), ["a"]);
        assertEquals(createIterable({}).chain({"a"}).sequence(), ["a"]);
        assertEquals(createIterable({"a"}).chain({"a"}).sequence(), ["a", "a"]);
        value iterable = createIterable {"a", "c", "b"};
        value iterator = iterable.iterator();
        assertEquals(iterable.chain({null, "c"}).sequence(), [iterator.next(), iterator.next(), iterator.next(), null, "c"]);
    }
    
    test shared default void testDefaultNullElements() {
        assertEquals(createIterable({}).defaultNullElements("X").sequence(), []);
        assertEquals(createIterable({"a"}).defaultNullElements("X").sequence(), ["a"]);
        assertEquals(createIterable({"a", "b", "c"}).defaultNullElements("X").sequence(), createIterable({"a", "b", "c"}).sequence());
    }
    
    test shared default void testString() {
        assertEquals(createIterable({}).string, "{}");
        testStringWith(createIterable({"a"}));
        testStringWith(createIterable({"a", "b", "c"}));
        testStringWith(createIterable({"Hello", "world!"}));
    }
    
    shared void testStringWith({String?*} items) {
        value builder = StringBuilder();
        builder.append("{ ");
        for (item in items.sequence()[0:(items.size - 1)]) {
            builder.append(item else "<null>").append(", ");
        }
        builder.append(items.last else "<null>").append(" }");
        assertEquals(items.string, builder.string);
    }
    
    test shared default void testCycled() {
        assertEquals(createIterable({}).cycled.iterator().next(), finished);
        value aCycledIterator = createIterable({"A"}).cycled.iterator();
        for (i in 1..10) {
            assertEquals(aCycledIterator.next(), "A");
        }
        value abcCycledIterator = createIterable({"A", "B", "C"}).cycled.iterator();
        for (i in 1..10) {
            for (item in createIterable {"A", "B", "C"}) {
                assertEquals(abcCycledIterator.next(), item);    
            }
        }
    }
    
    "This test calls [[testCycleFunction]] with the cycle function.
     If needed, override that method."
    test shared void testCycle() {
        testCycleFunction(({String?*} strings) => 
            compose(({String?*} it)=>it.sequence(), strings.cycle));
    }
    
    "This test calls [[testCycleFunction]] with the cycle function.
     If needed, override that method."
    test shared void testRepeat() {
        testCycleFunction(({String?*} strings) => strings.repeat);
    }
    
    "This function is called by [[testCycle]] and [[testRepeat]]."
    shared default void testCycleFunction(List<String?>(Integer)({String?*}) cycle) {
        assertEquals(cycle(createIterable {})(0), []);
        assertEquals(cycle(createIterable {})(1), []);
        assertEquals(cycle(createIterable {})(-1), []);
        assertEquals(cycle(createIterable {"a"})(1), ["a"]);
        assertEquals(cycle(createIterable {"a", "b", "c"})(1), createIterable({"a", "b", "c"}).sequence());
        assertEquals(cycle(createIterable {"a"})(2), createIterable({"a", "a"}).sequence());
        assertEquals(cycle(createIterable {"a", "b", "c"})(3), createIterable({"a", "b", "c", "a", "b", "c", "a", "b", "c"}));
    }
 
    shared Target next<Target>(Iterator<Anything> iterator) {
        while(!is Finished next = iterator.next()) {
            if (is Target next) {
                return next;
            }
        }
        throw;
    }
 
}

shared interface InsertionOrderIterableTests satisfies IterableTests {
    
    test shared actual default void testIterator() {
        variable value iter = createIterable({}).iterator();
        assertTrue(iter.next() is Finished);
        assertTrue(iter.next() is Finished);
        iter = createIterable({"A"}).iterator();
        assertEquals(iter.next(), "A");
        assertTrue(iter.next() is Finished);
        iter = createIterable({"B", "D", "A", "C"}).iterator();
        assertEquals(iter.next(), "B");
        assertEquals(iter.next(), "D");
        assertEquals(iter.next(), "A");
        assertEquals(iter.next(), "C");
        assertTrue(iter.next() is Finished);
    }
    
    test shared actual default void testSkipWhile() {
        function lessThanJ(String? s) => (s else "a") < "j";
        assertEquals(createIterable({}).skipWhile(lessThanJ).sequence(), []);
        assertEquals(createIterable({"z"}).skipWhile(lessThanJ).sequence(), ["z"]);
        assertEquals(createIterable({"x", "y", "z"}).skipWhile(lessThanJ).sequence(), ["x", "y", "z"]);
        assertEquals(createIterable({"a"}).skipWhile(lessThanJ).sequence(), []);
        assertEquals(createIterable({"a", "b", "c"}).skipWhile(lessThanJ).sequence(), []);
        assertEquals(createIterable({"a", "x", "y"}).skipWhile(lessThanJ).sequence(), ["x", "y"]);
        assertEquals(createIterable({"z", "a", "b"}).skipWhile(lessThanJ).sequence(), ["z", "a", "b"]);
        assertEquals(createIterable({"i", "j", "k"}).skipWhile(lessThanJ).sequence(), ["j", "k"]);
    }
    
    shared actual void testTakeWhile() {
        function lessThanJ(String? s) => (s else "a") < "j";
        assertEquals(createIterable({}).takeWhile(lessThanJ).sequence(), []);
        assertEquals(createIterable({"z"}).takeWhile(lessThanJ).sequence(), []);
        assertEquals(createIterable({"x", "y", "z"}).takeWhile(lessThanJ).sequence(), []);
        assertEquals(createIterable({"a"}).takeWhile(lessThanJ).sequence(), ["a"]);
        assertEquals(createIterable({"a", "b", "c"}).takeWhile(lessThanJ).sequence(), ["a", "b", "c"]);
        assertEquals(createIterable({"a", "x", "y"}).takeWhile(lessThanJ).sequence(), ["a"]);
        assertEquals(createIterable({"z", "a", "b"}).takeWhile(lessThanJ).sequence(), []);
        assertEquals(createIterable({"i", "j", "k"}).takeWhile(lessThanJ).sequence(), ["i"]);
    }
    
}

shared interface NaturalOrderIterableTests satisfies IterableTests {

    test shared actual default void testIterator() {
        variable value iter = createIterable({}).iterator();
        assertTrue(iter.next() is Finished);
        assertTrue(iter.next() is Finished);
        iter = createIterable({"A"}).iterator();
        assertEquals(iter.next(), "A");
        assertTrue(iter.next() is Finished);
        iter = createIterable({"B", "D", "A", "C"}).iterator();
        assertEquals(iter.next(), "A");
        assertEquals(iter.next(), "B");
        assertEquals(iter.next(), "C");
        assertEquals(iter.next(), "D");
        assertTrue(iter.next() is Finished);
    }
    
    test shared actual default void testSkipWhile() {
        function lessThanJ(String? s) => (s else "a") < "j";
        assertEquals(createIterable({}).skipWhile(lessThanJ).sequence(), []);
        assertEquals(createIterable({"z"}).skipWhile(lessThanJ).sequence(), ["z"]);
        assertEquals(createIterable({"x", "y", "z"}).skipWhile(lessThanJ).sequence(), ["x", "y", "z"]);
        assertEquals(createIterable({"a"}).skipWhile(lessThanJ).sequence(), []);
        assertEquals(createIterable({"a", "b", "c"}).skipWhile(lessThanJ).sequence(), []);
        assertEquals(createIterable({"a", "x", "y"}).skipWhile(lessThanJ).sequence(), ["x", "y"]);
        assertEquals(createIterable({"z", "a", "b"}).skipWhile(lessThanJ).sequence(), ["z"]);
        assertEquals(createIterable({"i", "j", "k"}).skipWhile(lessThanJ).sequence(), ["j", "k"]);
    }
    
    shared actual void testTakeWhile() {
        function lessThanJ(String? s) => (s else "a") < "j";
        assertEquals(createIterable({}).takeWhile(lessThanJ).sequence(), []);
        assertEquals(createIterable({"z"}).takeWhile(lessThanJ).sequence(), []);
        assertEquals(createIterable({"x", "y", "z"}).takeWhile(lessThanJ).sequence(), []);
        assertEquals(createIterable({"a"}).takeWhile(lessThanJ).sequence(), ["a"]);
        assertEquals(createIterable({"a", "b", "c"}).takeWhile(lessThanJ).sequence(), ["a", "b", "c"]);
        assertEquals(createIterable({"a", "x", "y"}).takeWhile(lessThanJ).sequence(), ["a"]);
        assertEquals(createIterable({"z", "a", "b"}).takeWhile(lessThanJ).sequence(), ["a", "b"]);
        assertEquals(createIterable({"i", "j", "k"}).takeWhile(lessThanJ).sequence(), ["i"]);
    }
    
}

shared interface HashOrderIterableTests satisfies IterableTests {

    test shared actual void testIterator() {
        variable value iter = createIterable({}).iterator();
        assertTrue(iter.next() is Finished);
        assertTrue(iter.next() is Finished);
        iter = createIterable({"A"}).iterator();
        assertEquals(iter.next(), "A");
        assertTrue(iter.next() is Finished);
        iter = createIterable({"A", "B", "C"}).iterator();
        value items = [iter.next(), iter.next(), iter.next(), iter.next()];
        assertTrue(items.contains("A"));
        assertTrue(items.contains("B"));
        assertTrue(items.contains("C"));
        assertTrue(items.contains(finished));
    }

    test shared actual default void testSkipWhile() {
        function lessThanJ(String? s) => (s else "a") < "j";
        assertEquals(createIterable({}).skipWhile(lessThanJ).sequence(), []);
        assertEquals(createIterable({"z"}).skipWhile(lessThanJ).sequence(), ["z"]);
        assertEquals(createIterable({"x", "y", "z"}).skipWhile(lessThanJ).sequence(), ["x", "y", "z"]);
        assertEquals(createIterable({"a"}).skipWhile(lessThanJ).sequence(), []);
        assertEquals(createIterable({"a", "b", "c"}).skipWhile(lessThanJ).sequence(), []);
        assertEquals(createIterable({"a", "x", "y"}).skipWhile(lessThanJ).sequence(), ["x", "y"]);
        assertEquals(createIterable({"z", "a", "b"}).skipWhile(lessThanJ).sequence(), ["z"]);
        assertEquals(createIterable({"i", "j", "k"}).skipWhile(lessThanJ).sequence(), ["j", "k"]);
    }
    
    shared actual void testTakeWhile() {
        function lessThanJ(String? s) => (s else "a") < "j";
        assertEquals(createIterable({}).takeWhile(lessThanJ).sequence(), []);
        assertEquals(createIterable({"z"}).takeWhile(lessThanJ).sequence(), []);
        assertEquals(createIterable({"x", "y", "z"}).takeWhile(lessThanJ).sequence(), []);
        assertEquals(createIterable({"a"}).takeWhile(lessThanJ).sequence(), ["a"]);
        assertEquals(createIterable({"a", "b", "c"}).takeWhile(lessThanJ).sequence(), ["a", "b", "c"]);
        assertEquals(createIterable({"a", "x", "y"}).takeWhile(lessThanJ).sequence(), ["a"]);
        assertEquals(createIterable({"z", "a", "b"}).takeWhile(lessThanJ).sequence(), ["a", "b"]);
        assertEquals(createIterable({"i", "j", "k"}).takeWhile(lessThanJ).sequence(), ["i"]);
    }

}
