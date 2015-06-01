
import ceylon.json {
    StringTokenizer,
    ParseException
}
import ceylon.test {
    test,
    assertEquals,
    fail
}
import ceylon.json.stream {
    ArrayStartEvent,
    ArrayEndEvent,
    KeyEvent,
    ObjectStartEvent,
    ObjectEndEvent,
    StreamParser
}

StreamParser parser(String json) => StreamParser(StringTokenizer(json));

test
shared void testString() {
    value events = parser(""""hello, world"""");
    assert(is String e1=events.next());
    assert(e1=="hello, world");
    assert(is Finished end=events.next());
}

test
shared void testTrue() {
    value events = parser(""" true """);
    assert(is Boolean e1=events.next());
    assert(e1==true);
    assert(is Finished end=events.next());
}

test
shared void testFalse() {
    value events = parser("""false """);
    assert(is Boolean e1=events.next());
    assert(e1==false);
    assert(is Finished end=events.next());
}

test
shared void testNull() {
    value events = parser(""" null""");
    assert(is Null e1=events.next());
    assert(is Finished end=events.next());
}

test
shared void testInteger() {
    value events = parser(""" 100 """);
    assert(is Integer e1=events.next());
    assert(e1 ==100);
    assert(is Finished end=events.next());
}

test
shared void testFloat() {
    value events = parser(""" 100.0 """);
    assert(is Float e1=events.next());
    assert(e1 ==100.0);
    assert(is Finished end=events.next());
    
    // TODO lots more tests according to the spec grammar
}

test
shared void testEmptyArray1() {
    value events = parser(""" [ ] """);
    assert(is ArrayStartEvent e1=events.next());
    assert(is ArrayEndEvent e3=events.next());
    assert(is Finished end=events.next());
}

test
shared void testEmptyArray2() {
    value events = parser(""" [] """);
    assert(is ArrayStartEvent e1=events.next());
    assert(is ArrayEndEvent e3=events.next());
    assert(is Finished end=events.next());
}

test
shared void testEmptyArray3() {
    value events = parser("""[]""");
    assert(is ArrayStartEvent e1=events.next());
    assert(is ArrayEndEvent e3=events.next());
    assert(is Finished end=events.next());
}

test
shared void testArrayOf1String() {
    value events = parser(""" [ "hello" ] """);
    assert(is ArrayStartEvent e1=events.next());
    assert(is String e2=events.next());
    assert(e2=="hello");
    assert(is ArrayEndEvent e3=events.next());
    assert(is Finished end=events.next());
}

test
shared void testArrayOf1Boolean() {
    value events = parser(""" [ true ] """);
    assert(is ArrayStartEvent e1=events.next());
    assert(is Boolean e2=events.next());
    assert(e2);
    assert(is ArrayEndEvent e3=events.next());
    assert(is Finished end=events.next());
}

test
shared void testArrayOf1Integer() {
    value events = parser("""[1]""");
    assert(is ArrayStartEvent e1=events.next());
    //print(events.next());
    assert(is Integer e2=events.next());
    assert(e2 ==1);
    //print(events.next());
    assert(is ArrayEndEvent e3=events.next());
    assert(is Finished end=events.next());
}

test
shared void testArrayOf1Float() {
    value events = parser("""[ 1.0 ]""");
    assert(is ArrayStartEvent e1=events.next());
    assert(is Float e2=events.next());
    assert(e2==1.0);
    assert(is ArrayEndEvent e3=events.next());
    assert(is Finished end=events.next());
}

test
shared void testArrayOf1Null() {
    value events = parser(""" [null] """);
    assert(is ArrayStartEvent e1=events.next());
    assert(is Null e2=events.next());
    assert(is ArrayEndEvent e3=events.next());
    assert(is Finished end=events.next());
}

test
shared void testArrayOf1Array() {
    value events = parser(""" [[]] """);
    assert(is ArrayStartEvent e1=events.next());
    assert(is ArrayStartEvent e2=events.next());
    assert(is ArrayEndEvent e3=events.next());
    assert(is ArrayEndEvent e4=events.next());
    assert(is Finished end=events.next());
}

test
shared void testArrayOf1Object() {
    value events = parser(""" [{"key": "value"}] """);
    assert(is ArrayStartEvent e1=events.next());
    assert(is ObjectStartEvent e2=events.next());
    assert(is KeyEvent e3=events.next());
    assert("key" == e3.eventValue);
    assert(is String e4=events.next());
    assert("value" == e4);
    assert(is ObjectEndEvent e5=events.next());
    assert(is ArrayEndEvent e6=events.next());
    assert(is Finished end=events.next());
}

test
shared void testArrayOf2String() {
    value events = parser(""" [ "hello" , "world" ] """);
    assert(is ArrayStartEvent e1=events.next());
    assert(is String e2=events.next());
    assert(e2=="hello");
    assert(is String e3=events.next());
    assert(e3=="world");
    assert(is ArrayEndEvent e4=events.next());
    assert(is Finished end=events.next());
}

test
shared void testArrayOf2Boolean() {
    value events = parser(""" [ true,false ] """);
    assert(is ArrayStartEvent e1=events.next());
    assert(is Boolean e2=events.next());
    assert(e2);
    assert(is Boolean e3=events.next());
    assert(!e3);
    assert(is ArrayEndEvent e4=events.next());
    assert(is Finished end=events.next());
}

test
shared void testArrayOf2Integer() {
    value events = parser("""[1 ,2]""");
    assert(is ArrayStartEvent e1=events.next());
    //print(events.next());
    assert(is Integer e2=events.next());
    assert(e2 ==1);
    assert(is Integer e3=events.next());
    assert(e3==2);
    //print(events.next());
    assert(is ArrayEndEvent e4=events.next());
    assert(is Finished end=events.next());
}

test
shared void testArrayOf2Float() {
    value events = parser("""[ 1.0, 2.0 ]""");
    assert(is ArrayStartEvent e1=events.next());
    assert(is Float e2=events.next());
    assert(e2 ==1.0);
    assert(is Float e3=events.next());
    assert(e3 ==2.0);
    assert(is ArrayEndEvent e4=events.next());
    assert(is Finished end=events.next());
}

test
shared void testArrayOf2Null() {
    value events = parser(""" [null,null] """);
    assert(is ArrayStartEvent e1=events.next());
    assert(is Null e2=events.next());
    assert(is Null e3=events.next());
    assert(is ArrayEndEvent e4=events.next());
    assert(is Finished end=events.next());
}

test
shared void testEmptyObject1() {
    value events = parser(""" { } """);
    assert(is ObjectStartEvent e1=events.next());
    assert(is ObjectEndEvent e3=events.next());
    assert(is Finished end=events.next());
}

test
shared void testEmptyObject2() {
    value events = parser(""" {} """);
    assert(is ObjectStartEvent e1=events.next());
    assert(is ObjectEndEvent e3=events.next());
    assert(is Finished end=events.next());
}

test
shared void testEmptyObject3() {
    value events = parser("""{}""");
    assert(is ObjectStartEvent e1=events.next());
    assert(is ObjectEndEvent e3=events.next());
    assert(is Finished end=events.next());
}

test
shared void testObject1String() {
    value events = parser(""" { "key" : "value" } """);
    assert(is ObjectStartEvent e1=events.next());
    assert(is KeyEvent e2=events.next());
    assert("key" == e2.eventValue);
    assert(is String e3=events.next());
    assert("value" == e3);
    assert(is ObjectEndEvent e4=events.next());
    assert(is Finished end=events.next());
}

test
shared void testObject1Integer() {
    value events = parser(""" { "key":1 } """);
    assert(is ObjectStartEvent e1=events.next());
    assert(is KeyEvent e2=events.next());
    assert("key" == e2.eventValue);
    assert(is Integer e3=events.next());
    assert(1 == e3);
    assert(is ObjectEndEvent e4=events.next());
    assert(is Finished end=events.next());
}

test
shared void testObject1True() {
    value events = parser(""" { "key" :true} """);
    assert(is ObjectStartEvent e1=events.next());
    assert(is KeyEvent e2=events.next());
    assert("key" == e2.eventValue);
    assert(is Boolean e3=events.next());
    assert(true == e3);
    assert(is ObjectEndEvent e4=events.next());
    assert(is Finished end=events.next());
}

test
shared void testObject1False() {
    value events = parser("""{"key" : false } """);
    assert(is ObjectStartEvent e1=events.next());
    assert(is KeyEvent e2=events.next());
    assert("key" == e2.eventValue);
    assert(is Boolean e3=events.next());
    assert(false == e3);
    assert(is ObjectEndEvent e4=events.next());
    assert(is Finished end=events.next());
}

test
shared void testObject1Null() {
    value events = parser(""" { "key":null } """);
    assert(is ObjectStartEvent e1=events.next());
    assert(is KeyEvent e2=events.next());
    assert("key" == e2.eventValue);
    assert(is Null e3=events.next());
    assert(is ObjectEndEvent e4=events.next());
    assert(is Finished end=events.next());
}

test
shared void testObject1Array() {
    value events = parser(""" { "key":[] } """);
    assert(is ObjectStartEvent e1=events.next());
    assert(is KeyEvent e2=events.next());
    assert("key" == e2.eventValue);
    assert(is ArrayStartEvent e3=events.next());
    assert(is ArrayEndEvent e4=events.next());
    assert(is ObjectEndEvent e5=events.next());
    assert(is Finished end=events.next());
}

test
shared void testObject1Object() {
    value events = parser(""" { "key":{ "key2": null} } """);
    assert(is ObjectStartEvent e1=events.next());
    assert(is KeyEvent e2=events.next());
    assert("key" == e2.eventValue);
    assert(is ObjectStartEvent e3=events.next());
    assert(is KeyEvent e4=events.next());
    assert("key2" == e4.eventValue);
    assert(is Null e5=events.next());
    assert(is ObjectEndEvent e6=events.next());
    assert(is ObjectEndEvent e7=events.next());
    assert(is Finished end=events.next());
}

test
shared void testObject2String() {
    value events = parser(""" { "key" : "value", "hello": "world" } """);
    assert(is ObjectStartEvent e1=events.next());
    assert(is KeyEvent e2=events.next());
    assert("key" == e2.eventValue);
    assert(is String e3=events.next());
    assert("value" == e3);
    assert(is KeyEvent e4=events.next());
    assert("hello" == e4.eventValue);
    assert(is String e5=events.next());
    assert("world" == e5);
    assert(is ObjectEndEvent e6=events.next());
    assert(is Finished end=events.next());
}

test
shared void testObject2Integer() {
    value events = parser(""" { "one":1,"two":2 } """);
    assert(is ObjectStartEvent e1=events.next());
    assert(is KeyEvent e2=events.next());
    assert("one" == e2.eventValue);
    assert(is Integer e3=events.next());
    assert(1 == e3);
    assert(is KeyEvent e4=events.next());
    assert("two" == e4.eventValue);
    assert(is Integer e5=events.next());
    assert(2 == e5);
    assert(is ObjectEndEvent e6=events.next());
    assert(is Finished end=events.next());
}

test
shared void testObject2True() {
    value events = parser(""" { "key" :true, "key": true} """);
    assert(is ObjectStartEvent e1=events.next());
    assert(is KeyEvent e2=events.next());
    assert("key" == e2.eventValue);
    assert(is Boolean e3=events.next());
    assert(true == e3);
    assert(is KeyEvent e4=events.next());
    assert("key" == e4.eventValue);
    assert(is Boolean e5=events.next());
    assert(true == e5);
    assert(is ObjectEndEvent e6=events.next());
    assert(is Finished end=events.next());
}

test
shared void testObject2False() {
    value events = parser("""{"key" : false , "key2" : false } """);
    assert(is ObjectStartEvent e1=events.next());
    assert(is KeyEvent e2=events.next());
    assert("key" == e2.eventValue);
    assert(is Boolean e3=events.next());
    assert(false == e3);
    assert(is KeyEvent e4=events.next());
    assert("key2" == e4.eventValue);
    assert(is Boolean e5=events.next());
    assert(false == e5);
    assert(is ObjectEndEvent e6=events.next());
    assert(is Finished end=events.next());
}

test
shared void testObject2Null() {
    value events = parser(""" { "key":null,"NULL":null } """);
    assert(is ObjectStartEvent e1=events.next());
    assert(is KeyEvent e2=events.next());
    assert("key" == e2.eventValue);
    assert(is Null e3=events.next());
    assert(is KeyEvent e4=events.next());
    assert("NULL" == e4.eventValue);
    assert(is Null e5=events.next());
    assert(is ObjectEndEvent e6=events.next());
    assert(is Finished end=events.next());
}

void nextError(StreamParser events, String expect) {
    try {
        value evt = events.next();
        fail("Expected an exception, but got ``evt else "null"``");
    } catch (Exception e) {
        assertEquals(expect, e.message);
    }
}

test
shared void illegalToken() {
    variable value events = parser(""" nul """);
    nextError(events, "Expected l but got   at 1:5 (line:column)");
    
    events = parser(""" nulll """);
    nextError(events, "Expected null but got nulll at 1:6 (line:column)");
    
    events = parser(""" tru """);
    nextError(events, "Expected e but got   at 1:5 (line:column)");
    
    events = parser(""" truee """);
    nextError(events, "Expected true but got truee at 1:6 (line:column)");
    
    events = parser(""" fals""");
    nextError(events, "Unexpected end of input at 1:6 (line:column)");
    
    events = parser(""" falsee """);
    nextError(events, "Expected false but got falsee at 1:7 (line:column)");
}
test
shared void twoValues() {
    variable value events = parser(""" null null""");
    assert(is Null e1=events.next());
    nextError(events, "Expected end of input but got n at 1:7 (line:column)");
    
    events = parser(""" [] null""");
    assert(is ArrayStartEvent e2=events.next());
    assert(is ArrayEndEvent e3=events.next());
    nextError(events, "Expected end of input but got n at 1:5 (line:column)");
    
    events = parser("""  null []""");
    assert(is Null e4=events.next());
    nextError(events, "Expected end of input but got [ at 1:8 (line:column)");
    
    events = parser(""" {} null""");
    assert(is ObjectStartEvent e5=events.next());
    assert(is ObjectEndEvent e6=events.next());
    nextError(events, "Expected end of input but got n at 1:5 (line:column)");
    
    events = parser("""  null {}""");
    assert(is Null e7=events.next());
    nextError(events, "Expected end of input but got { at 1:8 (line:column)");
}
test
shared void nakedArray() {
    variable value events = parser("""null, true""");
    assert(is Null e1=events.next());
    nextError(events, "Expected end of input but got , at 1:5 (line:column)");
    
    events = parser("""null,""");
    assert(is Null e2=events.next());
    nextError(events, "Expected end of input but got , at 1:5 (line:column)");
}
test
shared void nakedObject() {
    variable value events = parser(""" "key": true""");
    assert(is String e1=events.next());
    assert("key"==e1);
    nextError(events, "Expected end of input but got : at 1:7 (line:column)");
}
test
shared void commaAtToplevel() {
    variable value events = parser(""" ,""");
    nextError(events, "Expected a value but got , at 1:2 (line:column)");
    
    events = parser("""null,""");
    assert(is Null e2=events.next());
    nextError(events, "Expected end of input but got , at 1:5 (line:column)");
    
    events = parser("""null , """);
    assert(is Null e3=events.next());
    nextError(events, "Expected end of input but got , at 1:6 (line:column)");
    
    events = parser(""",null""");
    nextError(events, "Expected a value but got , at 1:1 (line:column)");
    
    events = parser(""" , null""");
    nextError(events, "Expected a value but got , at 1:2 (line:column)");
}
test
shared void unterminatedString() {
    variable value events = parser(""" "      """);
    nextError(events, "Unexpected end of input at 1:9 (line:column)");
    
    events = parser(""" [ "      """);
    assert(is ArrayStartEvent e1=events.next());
    nextError(events, "Unexpected end of input at 1:11 (line:column)");
    
    events = parser(""" [ "]""");
    assert(is ArrayStartEvent e2=events.next());
    nextError(events, "Unexpected end of input at 1:6 (line:column)");
    
    events = parser(""" { "      """);
    assert(is ObjectStartEvent e3=events.next());
    nextError(events, "Unexpected end of input at 1:11 (line:column)");
    
    events = parser(""" { "}""");
    assert(is ObjectStartEvent e4=events.next());
    nextError(events, "Unexpected end of input at 1:6 (line:column)");
    
    events = parser(""" { "k": "}""");
    assert(is ObjectStartEvent e5=events.next());
    assert(is KeyEvent e6=events.next());
    assert("k"==e6.eventValue);
    nextError(events, "Unexpected end of input at 1:11 (line:column)");
}

test
shared void unterminatedArray() {
    variable value events = parser("""[null""");
    assert(events.next() is ArrayStartEvent);
    assert(events.next() is Null);
    nextError(events, "Unexpected end of input at 1:6 (line:column)");
    
    events = parser("""[ null,""");
    assert(events.next() is ArrayStartEvent);
    assert(events.next() is Null);
    nextError(events, "Unexpected end of input at 1:8 (line:column)");
    
    events = parser("""[ """);
    assert(events.next() is ArrayStartEvent);
    nextError(events, "Unexpected end of input at 1:3 (line:column)");
}
test
shared void unterminatedObject() {
    variable value events = parser("""{ """);
    assert(events.next() is ObjectStartEvent);
    nextError(events, "Unexpected end of input at 1:3 (line:column)");
    
    events = parser("""{"key" """);
    assert(events.next() is ObjectStartEvent);
    assert(is KeyEvent e2=events.next());
    assert("key" == e2.eventValue);
    nextError(events, "Unexpected end of input at 1:8 (line:column)");
    
    events = parser("""{"key": """);
    assert(events.next() is ObjectStartEvent);
    assert(is KeyEvent e3=events.next());
    assert("key" == e3.eventValue);
    nextError(events, "Unexpected end of input at 1:9 (line:column)");
    
    events = parser("""{"key":"value" """);
    assert(events.next() is ObjectStartEvent);
    assert(is KeyEvent e4=events.next());
    assert("key" == e4.eventValue);
    assert(is String e5=events.next());
    assert("value" == e5);
    nextError(events, "Unexpected end of input at 1:16 (line:column)");
    
    events = parser("""{"key":"value", """);
    assert(events.next() is ObjectStartEvent);
    assert(is KeyEvent e6=events.next());
    assert("key" == e6.eventValue);
    assert(is String e7=events.next());
    assert("value" == e7);
    nextError(events, "Unexpected end of input at 1:17 (line:column)");
    
    events = parser("""{"key":"value", "key2" """);
    assert(events.next() is ObjectStartEvent);
    assert(is KeyEvent e8=events.next());
    assert("key" == e8.eventValue);
    assert(is String e9=events.next());
    assert("value" == e9);
    assert(is KeyEvent e10=events.next());
    assert("key2" == e10.eventValue);
    nextError(events, "Unexpected end of input at 1:24 (line:column)");
    
    events = parser("""{"key":"value", "key2": """);
    assert(events.next() is ObjectStartEvent);
    assert(is KeyEvent e11=events.next());
    assert("key" == e11.eventValue);
    assert(is String e12=events.next());
    assert("value" == e12);
    assert(is KeyEvent e13=events.next());
    assert("key2" == e13.eventValue);
    nextError(events, "Unexpected end of input at 1:25 (line:column)");
    
    events = parser("""{"key":"value", "key2": "value" """);
    assert(events.next() is ObjectStartEvent);
    assert(is KeyEvent e14=events.next());
    assert("key" == e14.eventValue);
    assert(is String e15=events.next());
    assert("value" == e15);
    assert(is KeyEvent e16=events.next());
    assert("key2" == e16.eventValue);
    assert(is String e17=events.next());
    assert("value" == e17);
    nextError(events, "Unexpected end of input at 1:33 (line:column)");
}


test
shared void badlyDelimitedItems() {
    // missing :
    variable value events = parser(""" {"key" "value" } """);
    assert(events.next() is ObjectStartEvent);
    assert(events.next() is KeyEvent);
    nextError(events, "Expected : but got \" at 1:9 (line:column)");
    // double ::
    events = parser(""" {"key":: "value" } """);
    assert(events.next() is ObjectStartEvent);
    assert(events.next() is KeyEvent);
    nextError(events, "Expected a value but got : at 1:9 (line:column)");
    // , instead of :
    events = parser(""" {"key", "value" } """);
    assert(events.next() is ObjectStartEvent);
    assert(events.next() is KeyEvent);
    nextError(events, "Expected a value but got , at 1:8 (line:column)");
    // : instead of ,
    events = parser(""" {"key": "value": "key2": "value2" } """);
    assert(events.next() is ObjectStartEvent);
    assert(events.next() is KeyEvent);
    assert(events.next() is String);
    nextError(events, "Expected , but got : at 1:17 (line:column)");
    // missing ,
    events = parser(""" {"key": "value" "key2": "value2" } """);
    assert(events.next() is ObjectStartEvent);
    assert(events.next() is KeyEvent);
    assert(events.next() is String);
    nextError(events, "Expected , but got \" at 1:18 (line:column)");
    // double ,,
    events = parser(""" {"key": "value",, "key2": "value2" } """);
    assert(events.next() is ObjectStartEvent);
    assert(events.next() is KeyEvent);
    assert(events.next() is String);
    nextError(events, "Expected a key but got , at 1:18 (line:column)");
    // trailing ,
    events = parser(""" {"key": "value", } """);
    assert(events.next() is ObjectStartEvent);
    assert(events.next() is KeyEvent);
    assert(events.next() is String);
    nextError(events, "Expected a key but got } at 1:19 (line:column)");
}

test
shared void badlyDelimitedElements() {
    // missing ,
    variable value events = parser(""" ["e1" "e2" ] """);
    assert(events.next() is ArrayStartEvent);
    assert(events.next() is String);
    nextError(events, "Expected , but got \" at 1:8 (line:column)");
    // double ,,
    events = parser(""" ["e1",, "e2" ] """);
    assert(events.next() is ArrayStartEvent);
    assert(events.next() is String);
    nextError(events, "Expected a value but got , at 1:8 (line:column)");
    // : instead of ,
    events = parser(""" ["e1": "e2" ] """);
    assert(events.next() is ArrayStartEvent);
    assert(events.next() is String);
    nextError(events, "Expected , but got : at 1:7 (line:column)");
    // trailing ,
    events = parser(""" ["e1", ] """);
    assert(events.next() is ArrayStartEvent);
    assert(events.next() is String);
    nextError(events, "Expected a value but got ] at 1:9 (line:column)");
}

// TODO bad string quoting
