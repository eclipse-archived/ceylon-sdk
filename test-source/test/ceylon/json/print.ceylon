import ceylon.json { ... }
import ceylon.test { assertEquals, test }

test void testPrint(){
    value o1 = Object{};
    assertEquals("{}", o1.string);
    
    value o2 = Object{
        "s" -> "asd",
        "i" -> 12,
        "f" -> 12.34,
        "true" -> true,
        "false" ->false,
        "null" -> nil,
        "o" -> Object{
            values=["i" -> 2];
        },
        "a" -> Array{
            values=["a", 2, true];
        }
    };
    assertEquals("{\"a\":[\"a\",2,true],\"false\":false,\"s\":\"asd\",\"f\":12.34,\"null\":null,\"i\":12,\"true\":true,\"o\":{\"i\":2}}", o2.string);
}