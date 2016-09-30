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
    
    test
    shared void lastCodePoint() {
        assertEquals("\{#10FFFF}", utf8.decode(utf8.encode("\{#10FFFF}")));
    }
    
    test
    shared void nonReiterableInput593() {
        class It<Element>({Element*} elements) satisfies Iterable<Element> {
            variable value expired = false;
            shared actual Iterator<Element> iterator() {
                assert(!expired);
                expired = true;
                return elements.iterator();
            }
        }
        assertEquals(utf8.encode(It("E".repeat(1500))), {69.byte}.repeat(1500).sequence());
        assertEquals(utf8.decode(It({69.byte}.repeat(1500))), "E".repeat(1500));
    }
}
