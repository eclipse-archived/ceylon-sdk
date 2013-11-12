import ceylon.collection {
    group
}
import ceylon.test {
    assertEquals,
    test
}

"Test the `group()` function"
see(`function group`)
shared test void testGroup(){
    value l = {"foo", "bar", "last", "list", "end"};
    value byFirstChar = group(l, (String element) => element.first?.string else "");
    print(byFirstChar);
    assertEquals(byFirstChar.size, 4, byFirstChar.string);
    assertEquals(byFirstChar["l"], {"last", "list"}, byFirstChar.string);
    assertEquals(byFirstChar["f"], {"foo"}, byFirstChar.string);
    assertEquals(byFirstChar["b"], {"bar"}, byFirstChar.string);
    assertEquals(byFirstChar["e"], {"end"}, byFirstChar.string);
    
    value byLastChar = group(l, (String element) => element.last?.string else "");
    assertEquals(byLastChar.size, 4, byLastChar.string);
    assertEquals(byLastChar["t"], {"last", "list"}, byLastChar.string);
    assertEquals(byLastChar["o"], {"foo"}, byLastChar.string);
    assertEquals(byLastChar["r"], {"bar"}, byLastChar.string);
    assertEquals(byLastChar["d"], {"end"}, byLastChar.string);
}
