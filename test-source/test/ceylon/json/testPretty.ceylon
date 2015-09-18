import ceylon.json {
    StringParser,
    StringEmitter
}
import ceylon.test {
    test,
    assertEquals
}
String prettify(String json) {
    value emitter = StringEmitter(true);
    StringParser(json, emitter).parse();
    return emitter.string;
}
String minify(String json) {
    value emitter = StringEmitter(false);
    StringParser(json, emitter).parse();
    return emitter.string;
}

test 
shared void testPretty() {
    assertEquals("""{
                     "foo": 1
                    }""",
        prettify("""  {  "foo" : 1 }  """));
    assertEquals("""{"foo":1}""", 
        minify("""  {  "foo" : 1 }  """));
}