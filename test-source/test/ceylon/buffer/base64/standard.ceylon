import ceylon.buffer.base64 {
    base64StringStandard,
    base64ByteStandard
}
import ceylon.buffer.charset {
    ascii,
    iso_8859_1,
    utf8,
    Charset
}
import ceylon.test {
    test
}

shared abstract class TestBase64StandardWithCharset(Charset charset)
        extends TestBase64WithCharset(charset, base64ByteStandard, base64StringStandard) {
    
    test
    shared void slash() {
        assertBase64 {
            "What Is The Answer and Why?";
            "V2hhdCBJcyBUaGUgQW5zd2VyIGFuZCBXaHk/";
        };
    }
}

shared class TestBase64StandardWithAscii()
        extends TestBase64StandardWithCharset(ascii) {
}

shared class TestBase64StandardWithIso88591()
        extends TestBase64StandardWithCharset(iso_8859_1) {
}

shared class TestBase64StandardWithUtf8()
        extends TestBase64StandardWithCharset(utf8) {
    test
    shared void unicodeOne() {
        assertBase64 {
            "A≢Α.";
            "QeKJos6RLg==";
        };
    }
    
    test
    shared void unicodeTwo() {
        assertBase64 {
            "한국어";
            "7ZWc6rWt7Ja0";
        };
    }
    
    test
    shared void unicodeThree() {
        assertBase64 {
            "日本語";
            "5pel5pys6Kqe";
        };
    }
    
    test
    shared void unicodeFour() {
        assertBase64 {
            "𣎴";
            "8KOOtA==";
        };
    }
}
