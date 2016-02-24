import ceylon.test {
    test,
    assertTrue,
    assertFalse
}
import ceylon.net.http.server {
    equals
}

test void testEqualsMatcher() {
    assertTrue(equals("/hello").matches("/hello"));
    assertFalse(equals("/hello").matches("/hell"));
    assertFalse(equals("/hello").matches("/helloo"));
    assertFalse(equals("/hello").matches("h"));
}