import ceylon.buffer.charset {
    iso_8859_1
}
import ceylon.buffer.codec {
    EncodeException,
    ignore
}
import ceylon.test {
    assertEquals,
    test,
    assertThatException
}

shared class Iso_8859_1Tests()
        extends CharsetTests(iso_8859_1) {
    test
    shared void encodeError() {
        assertThatException(() => iso_8859_1.encode("Aᛗ"))
            .hasType(`EncodeException`)
            .hasMessage("Invalid ISO_8859-1 byte value: ᛗ");
    }
    
    test
    shared void encodeErrorIgnore() {
        assertEquals {
            iso_8859_1.encode("Aᛗ", ignore);
            Array { 'A'.integer.byte };
        };
    }
}
