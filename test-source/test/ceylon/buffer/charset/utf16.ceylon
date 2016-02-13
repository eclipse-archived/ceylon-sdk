import ceylon.buffer.charset {
    utf16
}
import ceylon.buffer.codec {
    DecodeException,
    ignore
}
import ceylon.test {
    assertEquals,
    test,
    assertThatException
}

shared class Utf16Tests() {
    test
    shared void decodeZero() {
        assertEquals {
            utf16.decode({});
            "";
        };
    }
    
    test
    shared void encodeZero() {
        assertEquals {
            utf16.encode("");
            {};
        };
    }
    
    test
    shared void decodeUnicodeLittleEndianBom() {
        assertEquals {
            utf16.decode(
                {
                    #ff, #fe, #bb, #16, #da, #16, #c7, #16, #cf, #16,
                    #aa, #16, #be, #16, #ec, #16
                }*.byte
            );
            "ᚻᛚᛇᛏᚪᚾ᛬";
        };
    }
    
    test
    shared void decodeUnicodeLittleEndianNoBomError() {
        assertThatException(
            () => utf16.decode(
                    {
                        #bb, #16, #da, #16, #c7, #16, #cf, #16, #aa, #16,
                        #be, #16, #ec, #16
                    }*.byte
                )
        )
            .hasType(`DecodeException`)
            .hasMessage("Invalid UTF-16 low surrogate value: 50966");
    }
    
    test
    shared void decodeUnicodeLittleEndianNoBomErrorIgnore() {
        assertEquals {
            utf16.decode(
                {
                    #bb, #16, #da, #16, #c7, #16, #cf, #16, #aa, #16,
                    #be, #16, #ec, #16
                }*.byte,
                ignore
            );
            "묖";
        };
    }
    
    test
    shared void decodeUnicodeBigEndianBom() {
        assertEquals {
            utf16.decode(
                {
                    #fe, #ff, #16, #bb, #16, #da, #16, #c7, #16, #cf,
                    #16, #aa, #16, #be, #16, #ec
                }*.byte
            );
            "ᚻᛚᛇᛏᚪᚾ᛬";
        };
    }
    
    test
    shared void decodeUnicodeBigEndianNoBom() {
        assertEquals {
            utf16.decode(
                {
                    #16, #bb, #16, #da, #16, #c7, #16, #cf, #16, #aa,
                    #16, #be, #16, #ec
                }*.byte
            );
            "ᚻᛚᛇᛏᚪᚾ᛬";
        };
    }
    
    test
    shared void encodeUnicode() {
        assertEquals {
            utf16.encode("ᚻᛚᛇᛏᚪᚾ᛬");
            Array(
                {
                    #16, #bb, #16, #da, #16, #c7, #16, #cf, #16, #aa,
                    #16, #be, #16, #ec
                }*.byte
            );
        };
    }
}
