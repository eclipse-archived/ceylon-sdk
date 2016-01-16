import ceylon.buffer.base64 {
    Base64Byte,
    Base64String
}
import ceylon.buffer.charset {
    Charset,
    ascii
}
import ceylon.buffer.codec {
    ignore,
    DecodeException
}
import ceylon.test {
    assertEquals,
    test,
    assertThatException
}

shared abstract class TestBase64WithCharset(charset, base64Byte, base64String) {
    Charset charset;
    Base64Byte base64Byte;
    Base64String base64String;
    
    shared void assertBase64(input, expectedEncode) {
        String input;
        String expectedEncode;
        
        Array<Byte> encodedInput = charset.encode(input);
        
        Array<Byte> bytesEncoded = base64Byte.encode(charset.encode(input));
        assertEquals {
            expected = expectedEncode;
            actual = charset.decode(bytesEncoded);
        };
        assertEquals {
            expected = encodedInput;
            actual = base64Byte.decode(bytesEncoded);
        };
        
        String stringEncoded = base64String.encode(charset.encode(input));
        assertEquals {
            expected = expectedEncode;
            actual = stringEncoded;
        };
        assertEquals {
            expected = encodedInput;
            actual = base64String.decode(stringEncoded);
        };
    }
    
    test
    shared void onePad() {
        assertBase64 {
            "any carnal pleasure.";
            "YW55IGNhcm5hbCBwbGVhc3VyZS4=";
        };
    }
    
    test
    shared void twoPad() {
        assertBase64 {
            "any carnal pleasure";
            "YW55IGNhcm5hbCBwbGVhc3VyZQ==";
        };
    }
    
    test
    shared void zeroPad() {
        assertBase64 {
            "any carnal pleasur";
            "YW55IGNhcm5hbCBwbGVhc3Vy";
        };
    }
    
    test
    shared void onePadShort() {
        assertBase64 {
            "any carnal pleasu";
            "YW55IGNhcm5hbCBwbGVhc3U=";
        };
    }
    
    test
    shared void twoPadShort() {
        assertBase64 {
            "any carnal pleas";
            "YW55IGNhcm5hbCBwbGVhcw==";
        };
    }
    
    test
    shared void decodeErrorNotAChar() {
        assertThatException(() => base64Byte.decode({ 0.byte }))
            .hasType(`DecodeException`)
            .hasMessage((String msg) => msg.endsWith("is not a base64 Character"));
    }
    
    test
    shared void decodeErrorIgnoreNotAChar() {
        assertEquals {
            base64Byte.decode({ 0.byte }, ignore);
            {};
        };
    }
    
    test
    shared void decodeErrorNoPadHere() {
        assertThatException(() => base64String.decode("U3RlZWx5IEdsaW50="))
            .hasType(`DecodeException`)
            .hasMessage((String msg) => msg == "Pad character = is not allowed here");
    }
    
    test
    shared void decodeErrorIgnoreNoPadHere() {
        assertEquals {
            base64String.decode("U3RlZWx5IEdsaW50=", ignore);
            ascii.encode("Steely Glint");
        };
    }
    
    test
    shared void decodeErrorPadHere() {
        assertThatException(() => base64String.decode("SXQncyBDaGFyYWN0ZXIgRm9ybWluZw=w"))
                .hasType(`DecodeException`)
                .hasMessage((String msg) => msg == "Non-pad character w is not allowed here");
    }
    
    test
    shared void decodeErrorIgnorePadHere() {
        assertEquals {
            base64String.decode("SXQncyBDaGFyYWN0ZXIgRm9ybWluZw=w", ignore);
            ascii.encode("It's Character Forming");
        };
    }
    
    test
    shared void decodeTruncatedByOneOk() {
        assertEquals {
            base64String.decode("SXQncyBDaGFyYWN0ZXIgRm9ybWluZw=");
            ascii.encode("It's Character Forming");
        };
    }
    
    test
    shared void decodeTruncatedByTwoOk() {
        assertEquals {
            base64String.decode("SXQncyBDaGFyYWN0ZXIgRm9ybWluZw");
            ascii.encode("It's Character Forming");
        };
    }
    
    test
    shared void decodeTruncatedByThreeError() {
        assertThatException(() => base64String.decode("SXQncyBDaGFyYWN0ZXIgRm9ybWluZ"))
                .hasType(`DecodeException`)
                .hasMessage((String msg) => msg == "Missing one input piece");
    }
    
    test
    shared void decodeTruncatedByThreeIgnoreError() {
        assertEquals {
            base64String.decode("SXQncyBDaGFyYWN0ZXIgRm9ybWluZ", ignore);
            ascii.encode("It's Character Formin");
        };
    }
    
    test
    shared void decodeErrorPadExtra() {
        assertThatException(() => base64String.decode("SXQncyBDaGFyYWN0ZXIgRm9ybWluZw==="))
                .hasType(`DecodeException`)
                .hasMessage((String msg) => msg == "Pad character = is not allowed here");
    }
    
    test
    shared void decodeErrorIgnorePadExtra() {
        assertEquals {
            base64String.decode("SXQncyBDaGFyYWN0ZXIgRm9ybWluZw===", ignore);
            ascii.encode("It's Character Forming");
        };
    }
}
