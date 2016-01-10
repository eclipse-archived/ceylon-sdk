import ceylon.buffer.base64 {
    base64ByteStandard {
        encode=encode,
        decode=decode
    },
    base64StringStandard
}
import ceylon.buffer.charset {
    utf8,
    Charset,
    ascii,
    iso_8859_1
}
import ceylon.test {
    assertEquals,
    test
}

"Should work for any charset that degrades to ASCII"
shared abstract class TestBase64WithCharset(charset) {
    shared Charset charset;
    
    test
    shared void onePad() {
        assertBase64 {
            "any carnal pleasure.";
            "YW55IGNhcm5hbCBwbGVhc3VyZS4=";
            charset;
        };
    }
    
    test
    shared void twoPad() {
        assertBase64 {
            "any carnal pleasure";
            "YW55IGNhcm5hbCBwbGVhc3VyZQ==";
            charset;
        };
    }
    
    test
    shared void zeroPad() {
        assertBase64 {
            "any carnal pleasur";
            "YW55IGNhcm5hbCBwbGVhc3Vy";
            charset;
        };
    }
    
    test
    shared void onePadShort() {
        assertBase64 {
            "any carnal pleasu";
            "YW55IGNhcm5hbCBwbGVhc3U=";
            charset;
        };
    }
    
    test
    shared void twoPadShort() {
        assertBase64 {
            "any carnal pleas";
            "YW55IGNhcm5hbCBwbGVhcw==";
            charset;
        };
    }
}

shared class TestBase64WithAscii()
        extends TestBase64WithCharset(ascii) {
}

shared class TestBase64WithIso88591()
        extends TestBase64WithCharset(iso_8859_1) {
}

shared class TestBase64WithUtf8()
        extends TestBase64WithCharset(utf8) {
    test
    shared void unicodeOne() {
        assertBase64 {
            "A≢Α.";
            "QeKJos6RLg==";
            charset;
        };
    }
    
    test
    shared void unicodeTwo() {
        assertBase64 {
            "한국어";
            "7ZWc6rWt7Ja0";
            charset;
        };
    }
    
    test
    shared void unicodeThree() {
        assertBase64 {
            "日本語";
            "5pel5pys6Kqe";
            charset;
        };
    }
    
    test
    shared void unicodeFour() {
        assertBase64 {
            "𣎴";
            "8KOOtA==";
            charset;
        };
    }
}

void assertBase64(String input, String expectedEncode, Charset charset) {
    Array<Byte> encodedInput = charset.encode(input);
    
    Array<Byte> bytesEncoded = base64ByteStandard.encode(charset.encode(input));
    assertEquals {
        expected = expectedEncode;
        actual = charset.decode(bytesEncoded);
    };
    assertEquals {
        expected = encodedInput;
        actual = base64ByteStandard.decode(bytesEncoded);
    };
    
    String stringEncoded = base64StringStandard.encode(charset.encode(input));
    assertEquals {
        expected = expectedEncode;
        actual = stringEncoded;
    };
    assertEquals {
        expected = encodedInput;
        actual = base64StringStandard.decode(stringEncoded);
    };
}
