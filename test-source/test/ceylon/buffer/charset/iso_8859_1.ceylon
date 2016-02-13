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
    
    test
    shared void lowRangeEncodeDecode() {
        assertEquals {
            iso_8859_1.decode({
                    97, 108, 105, 116, 233, 115, 60, 47, 97, 62,
                    32, 60, 97, 32, 99, 108
                }*.byte);
            "alités</a> <a cl";
        };
        assertEquals {
            iso_8859_1.encode("alités</a> <a cl");
            { 97, 108, 105, 116, 233, 115, 60, 47, 97, 62, 32, 60, 97, 32, 99, 108 }*.byte;
        };
    }
}
