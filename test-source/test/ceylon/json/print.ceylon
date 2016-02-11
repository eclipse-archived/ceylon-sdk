import ceylon.json { Object, Array }
import ceylon.test { assertEquals, test }

shared test void testPrint(){
    value o1 = Object{};
    assertEquals("{}", o1.string);
    
    value o2 = Object{
        "s" -> "asd",
        "i" -> 12,
        "f" -> 12.34,
        "true" -> true,
        "false" ->false,
        "null" -> null,
        "o" -> Object{
            values=["i" -> 2];
        },
        "a" -> Array{
            values=["a", 2, true];
        }
    };
    assertEquals("{\"a\":[\"a\",2,true],\"f\":12.34,\"false\":false,\"i\":12,\"null\":null,\"o\":{\"i\":2},\"s\":\"asd\",\"true\":true}", o2.string);
}

shared test void testPrintTrickyFloats() {
    assertEquals(Object{
        "infinity"-> 1.0/0.0, 
        "minusInfinity"-> -1.0/0.0,
        "undefined" -> 0.0/0.0
    }.string, 
        """{"infinity":null,"minusInfinity":null,"undefined":null}""");
}