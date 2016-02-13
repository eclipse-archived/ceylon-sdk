import ceylon.buffer.charset {
    utf8
}
import ceylon.test {
    assertEquals,
    test
}

shared class Utf8Tests()
        extends CharsetTests(utf8) {
    test
    shared void decodeUnicode() {
        assertEquals {
            utf8.decode(
                {
                    #e1, #9a, #bb, #e1, #9b, #9a, #e1, #9b, #87, #e1,
                    #9b, #8f, #e1, #9a, #aa, #e1, #9a, #be, #e1, #9b,
                    #ac
                }*.byte
            );
            "ᚻᛚᛇᛏᚪᚾ᛬";
        };
    }
    
    test
    shared void encodeUnicode() {
        assertEquals {
            utf8.encode("ᚻᛚᛇᛏᚪᚾ᛬");
            Array(
                {
                    #e1, #9a, #bb, #e1, #9b, #9a, #e1, #9b, #87, #e1,
                    #9b, #8f, #e1, #9a, #aa, #e1, #9a, #be, #e1, #9b,
                    #ac
                }*.byte
            );
        };
    }
    
    test
    shared void lowRangeEncodeDecode() {
        assertEquals {
            utf8.encode("Español");
            { 69, 115, 112, 97, 195, 177, 111, 108 }*.byte;
        };
        assertEquals {
            utf8.decode({ 69, 115, 112, 97, 195, 177, 111, 108 }*.byte);
            "Español";
        };
    }
}
