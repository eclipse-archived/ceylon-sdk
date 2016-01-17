import ceylon.buffer.charset {
    ascii,
    Charset
}
import ceylon.buffer.codec {
    EncodeException,
    ignore,
    DecodeException
}
import ceylon.test {
    test,
    assertEquals,
    assertThatException
}

shared abstract class CharsetTests(Charset charset) {
    test
    shared void decodeZero() {
        assertEquals {
            charset.decode({});
            "";
        };
    }
    
    test
    shared void decodeOne() {
        assertEquals {
            charset.decode({ '!'.integer.byte });
            "!";
        };
    }
    
    test
    shared void decodeTwo() {
        assertEquals {
            charset.decode({ '!', 'a' }*.integer*.byte);
            "!a";
        };
    }
    
    test
    shared void encodeZero() {
        assertEquals {
            charset.encode("");
            {};
        };
    }
    
    test
    shared void encodeOne() {
        assertEquals {
            charset.encode("!");
            Array { '!'.integer.byte };
        };
    }
    
    test
    shared void encodeTwo() {
        assertEquals {
            charset.encode("!a");
            Array { '!', 'a' }*.integer*.byte;
        };
    }
}

shared class AsciiTests()
        extends CharsetTests(ascii) {
    test
    shared void encodeError() {
        assertThatException(() => ascii.encode("Aᛗ"))
            .hasType(`EncodeException`)
            .hasMessage("Invalid ASCII byte value: ᛗ");
    }
    
    test
    shared void encodeErrorIgnore() {
        assertEquals {
            ascii.encode("Aᛗ", ignore);
            Array { 'A'.integer.byte };
        };
    }
    
    test
    shared void decodeError() {
        assertThatException(() => ascii.decode({ $11111111.byte }))
            .hasType(`DecodeException`)
            .hasMessage((String m) => m.startsWith("Invalid ASCII byte value:"));
    }
    
    test
    shared void decodeErrorIgnore() {
        assertEquals {
            ascii.decode({ 'A'.integer.byte, $11111111.byte }, ignore);
            "A";
        };
    }
}
