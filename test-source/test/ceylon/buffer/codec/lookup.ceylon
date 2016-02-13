import ceylon.buffer.base {
    base64StringStandard,
    base64ByteStandard,
    base64ByteUrl,
    base64StringUrl,
    baseStringByAlias,
    baseByteByAlias
}
import ceylon.buffer.charset {
    charsetsByAlias,
    utf8,
    utf16,
    iso_8859_1,
    ascii
}
import ceylon.test {
    test,
    assertEquals
}

shared class Base64LookupTests() {
    test
    shared void primary() {
        assertEquals(baseStringByAlias["base64"], base64StringStandard);
        assertEquals(baseByteByAlias["base64"], base64ByteStandard);
        assertEquals(baseStringByAlias["base64url"], base64StringUrl);
        assertEquals(baseByteByAlias["base64url"], base64ByteUrl);
    }
}

shared class CharsetLookupTests() {
    test
    shared void primary() {
        assertEquals(charsetsByAlias["UTF-8"], utf8);
        assertEquals(charsetsByAlias["UTF-16"], utf16);
        assertEquals(charsetsByAlias["US-ASCII"], ascii);
        assertEquals(charsetsByAlias["ISO-8859-1"], iso_8859_1);
    }
}
