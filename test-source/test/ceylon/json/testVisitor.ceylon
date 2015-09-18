import ceylon.test {
    test,
    fail,
    assertEquals
}
import ceylon.json {
    Object,
    Array,
    Visitor,
    visit
}

class Pessimistic() satisfies Visitor {
        shared actual default void onString(String s) {
            fail();
        }
        shared actual default void onNull() {
            fail();
        }
        shared actual default void onBoolean(Boolean boolean) {
            fail();
        }
        
        shared actual default void onEndArray() {
            fail();
        }
        
        shared actual default void onEndObject() {
            fail();
        }
        
        shared actual default void onKey(String key) {
            fail();
        }
        
        shared actual default void onNumber(Integer|Float number) {
            fail();
        }
        
        shared actual default void onStartArray() {
            fail();
        }
        
        shared actual default void onStartObject() {
            fail();
        }
        
    }

test
shared void testVisitor() {
    object v1 extends Pessimistic() {
        shared variable Boolean seenStart = false;
        shared variable Boolean seenEnd = false;
        shared actual void onStartObject() {
            assert(!seenStart);
            assert(!seenEnd);
            seenStart = true;
        }
        shared actual void onEndObject() {
            assert(seenStart);
            assert(!seenEnd);
            seenEnd = true;
        }
    }
    visit(Object(), v1);
    assert(v1.seenStart);
    assert(v1.seenEnd);
    
    Object o1 = Object();
    o1.put("foo", "FOO");
    object v2 extends Pessimistic() {
        shared variable Boolean seenStart = false;
        shared variable Boolean seenEnd = false;
        shared variable Boolean seenKey = false;
        shared actual void onStartObject() {
            assert(!seenStart);
            assert(!seenKey);
            assert(!seenEnd);
            seenStart = true;
        }
        shared actual void onEndObject() {
            assert(seenStart);
            assert(!seenEnd);
            seenEnd = true;
        }
        shared actual void onKey(String key) {
            assert(seenStart);
            assert(!seenEnd);
            assert(!seenKey);
            assertEquals("foo", key);
            seenKey = true;
        }
        shared actual void onString(String str) {
            assert(seenStart);
            assert(seenKey);
            assert(!seenEnd);
            assertEquals("FOO", str);
        }
    }
    visit(o1, v2);
    assert(v2.seenStart);
    assert(v2.seenKey);
    assert(v2.seenEnd);
    
    object v3 extends Pessimistic() {
        shared variable Boolean seenStart = false;
        shared variable Boolean seenEnd = false;
        shared actual void onStartArray() {
            assert(!seenStart);
            assert(!seenEnd);
            seenStart = true;
        }
        shared actual void onEndArray() {
            assert(seenStart);
            assert(!seenEnd);
            seenEnd = true;
        }
    }
    visit(Array(), v3);
    assert(v3.seenStart);
    assert(v3.seenEnd);
    
    value a1 = Array();
    a1.add("FOO");
    object v4 extends Pessimistic() {
        shared variable Boolean seenStart = false;
        shared variable Boolean seenEnd = false;
        shared variable Boolean seenElement = false;
        shared actual void onStartArray() {
            assert(!seenStart);
            assert(!seenElement);
            assert(!seenEnd);
            seenStart = true;
        }
        shared actual void onString(String str) {
            assert(seenStart);
            assert(!seenElement);
            assert(!seenEnd);
            assertEquals("FOO", str);
            seenElement = true;
        }
        shared actual void onEndArray() {
            assert(seenStart);
            assert(seenElement);
            assert(!seenEnd);
            seenEnd = true;
        }
    }
    visit(a1, v4);
    assert(v4.seenStart);
    assert(v4.seenElement);
    assert(v4.seenEnd);
}
