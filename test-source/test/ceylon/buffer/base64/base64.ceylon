import ceylon.buffer.base {
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
    assertThatException,
    assertNotEquals,
    assertTrue
}

shared abstract class TestBase64WithCharset(charset, base64Byte, base64String) {
    Charset charset;
    Base64Byte base64Byte;
    Base64String base64String;
    
    test
    shared void encodeEstimateCompare() {
        for (i in 0..16) {
            assertTrue {
                base64Byte.averageEncodeSize(i) <= base64Byte.maximumEncodeSize(i);
                "Average larger than max for ``i`` (Byte)";
            };
            assertTrue {
                base64String.averageEncodeSize(i) <= base64String.maximumEncodeSize(i);
                "Average larger than max for ``i`` (String)";
            };
        }
    }
    
    test
    shared void decodeEstimateCompare() {
        for (i in 0..16) {
            assertTrue {
                base64Byte.averageDecodeSize(i) <= base64Byte.maximumDecodeSize(i);
                "Average larger than max for ``i`` (Byte)";
            };
            assertTrue {
                base64String.averageDecodeSize(i) <= base64String.maximumDecodeSize(i);
                "Average larger than max for ``i`` (String)";
            };
        }
    }
    
    test
    shared void decodeBidZero() {
        assertEquals(base64Byte.decodeBid({ 0.byte }), 0);
        assertEquals(base64String.decodeBid("\{NULL}"), 0);
    }
    
    test
    shared void decodeBidNonZero() {
        assertNotEquals(base64String.decodeBid("YW55IGNhcm5hbCBwbGVhc3VyZS4="), 0);
    }
    
    shared void assertBase64(input, expectedEncode) {
        String input;
        String expectedEncode;
        
        List<Byte> encodedInput = charset.encode(input);
        
        List<Byte> bytesEncoded = base64Byte.encode(charset.encode(input));
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
            .hasMessage((String msg) => msg.endsWith("is not a base64 character"));
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
            .hasMessage((String msg) => msg == "Pad element = is not allowed here");
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
    shared void decodeTruncatedByThreeOk() {
        assertEquals {
            base64String.decode("SXQncyBDaGFyYWN0ZXIgRm9ybWluZ");
            ascii.encode("It's Character Formind");
        };
    }
    
    test
    shared void decodeErrorPadExtra() {
        assertThatException(() => base64String.decode("SXQncyBDaGFyYWN0ZXIgRm9ybWluZw==="))
            .hasType(`DecodeException`)
            .hasMessage((String msg) => msg == "Pad element = is not allowed here");
    }
    
    test
    shared void decodeErrorIgnorePadExtra() {
        assertEquals {
            base64String.decode("SXQncyBDaGFyYWN0ZXIgRm9ybWluZw===", ignore);
            ascii.encode("It's Character Forming");
        };
    }
}
