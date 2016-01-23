import ceylon.buffer.base {
    base16String,
    base16Byte
}
import ceylon.buffer.codec {
    ignore,
    DecodeException
}
import ceylon.test {
    test,
    assertEquals,
    assertThatException
}

shared class Base16Tests() {
    test
    shared void encodeStringEmpty() {
        assertEquals {
            base16String.encode({});
            "";
        };
    }
    
    test
    shared void encodeStringOne() {
        assertEquals {
            base16String.encode({ #00 }*.byte);
            "00";
        };
    }
    
    test
    shared void encodeStringTwo() {
        assertEquals {
            base16String.encode({ #00, #9f }*.byte);
            "009f";
        };
    }
    
    test
    shared void encodeStringThree() {
        assertEquals {
            base16String.encode({ #11, #ff, #a9 }*.byte);
            "11ffa9";
        };
    }
    
    test
    shared void encodeStringEverything() {
        assertEquals {
            base16String.encode({ #01, #23, #45, #67, #89, #ab, #cd, #ef, #ab, #cd, #ef }*.byte);
            "0123456789abcdefabcdef";
        };
    }
    
    test
    shared void decodeStringEverything() {
        assertEquals {
            base16String.decode("0123456789ABCDEFabcdef");
            Array({ #01, #23, #45, #67, #89, #ab, #cd, #ef, #ab, #cd, #ef }*.byte);
        };
    }
    
    test
    shared void encodeByteEverything() {
        assertEquals {
            base16Byte.encode({ #01, #23, #45, #67, #89, #ab, #cd, #ef, #ab, #cd, #ef }*.byte);
            Array("0123456789abcdefabcdef"*.integer*.byte);
        };
    }
    
    test
    shared void decodeByteEverything() {
        assertEquals {
            base16Byte.decode(Array("0123456789ABCDEFabcdef"*.integer*.byte));
            Array({ #01, #23, #45, #67, #89, #ab, #cd, #ef, #ab, #cd, #ef }*.byte);
        };
    }
    
    test
    shared void decodeStringEmpty() {
        assertEquals {
            base16String.decode("");
            Array<Byte> { };
        };
    }
    
    test
    shared void decodeStringOne() {
        assertEquals {
            base16String.decode("e");
            Array { #e0.byte };
        };
    }
    
    test
    shared void decodeStringTwo() {
        assertEquals {
            base16String.decode("0E");
            Array { #0e.byte };
        };
    }
    
    test
    shared void decodeStringThree() {
        assertEquals {
            base16String.decode("99A");
            Array { #99.byte, #a0.byte };
        };
    }
    
    test
    shared void decodeStringFour() {
        assertEquals {
            base16String.decode("afFA");
            Array { #af.byte, #fa.byte };
        };
    }
    
    test
    shared void decodeStringError() {
        assertThatException(() => base16String.decode("az"))
            .hasType(`DecodeException`)
            .hasMessage("Input element z is not valid ASCII hex");
    }
    
    test
    shared void decodeStringErrorIgnore() {
        assertEquals {
            base16String.decode("az", ignore);
            Array { #a0.byte };
        };
    }
    
    test
    shared void decodeStringErrorIgnoreContinue() {
        assertEquals {
            base16String.decode("azf0d", ignore);
            Array { #af.byte, #0d.byte };
        };
    }
}
