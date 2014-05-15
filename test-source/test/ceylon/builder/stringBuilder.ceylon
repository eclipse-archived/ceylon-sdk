import ceylon.test {
    test
}
import ceylon.builder {
    StringBuilder
}

"Run the module `test.ceylon.builder`."
shared class StringBuilderTest() {
    
    shared test void testAppend() {
        StringBuilder sb = StringBuilder();
        assert("foobar" == sb.append("foo").append("bar").string);
    }
    
    shared test void testAppendCharacter() {
        StringBuilder sb = StringBuilder();
        assert("foobar" == sb.append("foo").appendCharacter('b').appendCharacter('a').appendCharacter('r').string);
    }
    
}