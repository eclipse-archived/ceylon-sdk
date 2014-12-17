import ceylon.json {
    StringEmitter
}
import ceylon.test {
    test,
    assertEquals
}
test
shared void testEmitter() {
    variable value emitter = StringEmitter(true);
    emitter.onStartObject();
    emitter.onEndObject();
    assertEquals("{}", emitter.string);
    
    emitter = StringEmitter(true);
    emitter.onStartArray();
    emitter.onEndArray();
    assertEquals("[]", emitter.string);
    
    emitter = StringEmitter(true);
    emitter.onString("hello");
    assertEquals("\"hello\"", emitter.string);
    
    emitter = StringEmitter(true);
    emitter.onBoolean(true);
    assertEquals("true", emitter.string);
    
    emitter = StringEmitter(true);
    emitter.onBoolean(false);
    assertEquals("false", emitter.string);
    
    emitter = StringEmitter(true);
    emitter.onNull();
    assertEquals("null", emitter.string);
    
    emitter = StringEmitter(true);
    emitter.onNumber(123);
    assertEquals("123", emitter.string);
    
    emitter = StringEmitter(true);
    emitter.onNumber(123.0);
    assertEquals("123.0", emitter.string);
    
    emitter = StringEmitter(true);
    emitter.onStartObject();
    emitter.onKey("foo");
    emitter.onString("FOO");
    emitter.onKey("bar");
    emitter.onBoolean(true);
    emitter.onKey("baz");
    emitter.onNull();
    emitter.onKey("array");
    emitter.onStartArray();
    emitter.onString("a");
    emitter.onString("b");
    emitter.onString("c");
    emitter.onEndArray();
    emitter.onEndObject();
    assertEquals("""{
                     "foo": "FOO",
                     "bar": true,
                     "baz": null,
                     "array": [
                      "a",
                      "b",
                      "c"
                     ]
                    }""", emitter.string);
    
}
