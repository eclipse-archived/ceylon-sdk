import ceylon.buffer.charset {
    utf16
}
import ceylon.test {
    assertEquals,
    test
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
    shared void decodeUnicode() {
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
    shared void encodeUnicode() {
        assertEquals {
            utf16.encode("ᚻᛚᛇᛏᚪᚾ᛬");
            Array(
                {
                    #ff, #fe, #bb, #16, #da, #16, #c7, #16, #cf, #16,
                    #aa, #16, #be, #16, #ec, #16
                }*.byte
            );
        };
    }
}
