import ceylon.buffer.base {
    base32StringStandard,
    base32StringHex,
    base32ByteHex
}
import ceylon.test {
    assertEquals,
    test
}

shared class Base32StandardTests() {
    test
    shared void encodeEmpty() {
        assertEquals {
            base32StringStandard.encode({});
            "";
        };
    }
    
    test
    shared void encodeOne() {
        assertEquals {
            base32StringStandard.encode({ #00 }*.byte);
            "AA======";
        };
    }
    
    test
    shared void encodeTwo() {
        assertEquals {
            base32StringStandard.encode({ #00, #9f }*.byte);
            "ACPQ====";
        };
    }
    
    test
    shared void encodeThree() {
        assertEquals {
            base32StringStandard.encode({ #11, #ff, #a9 }*.byte);
            "CH72S===";
        };
    }
    
    test
    shared void encodeFour() {
        assertEquals {
            base32StringStandard.encode({ #11, #ff, #a9, #01 }*.byte);
            "CH72SAI=";
        };
    }
    
    test
    shared void encodeFive() {
        assertEquals {
            base32StringStandard.encode({ #11, #ff, #a9, #00, #10 }*.byte);
            "CH72SAAQ";
        };
    }
    
    test
    shared void encodeSix() {
        assertEquals {
            base32StringStandard.encode({ #66, #6f, #6f, #62, #61, #72 }*.byte);
            "MZXW6YTBOI======";
        };
    }
    
    test
    shared void encodeLong() {
        assertEquals {
            base32StringStandard.encode("Frank Exchange Of Views"*.integer*.byte);
            "IZZGC3TLEBCXQY3IMFXGOZJAJ5TCAVTJMV3XG===";
        };
    }
    
    test
    shared void decodeEmpty() {
        assertEquals {
            base32StringStandard.decode("");
            Array<Byte> { };
        };
    }
    
    test
    shared void decodeOne() {
        assertEquals {
            base32StringStandard.decode("AA======");
            Array({ #00 }*.byte);
        };
    }
    
    test
    shared void decodeTwo() {
        assertEquals {
            base32StringStandard.decode("ACPQ====");
            Array({ #00, #9f }*.byte);
        };
    }
    
    test
    shared void decodeThree() {
        assertEquals {
            base32StringStandard.decode("CH72S===");
            Array({ #11, #ff, #a9 }*.byte);
        };
    }
    
    test
    shared void decodeFour() {
        assertEquals {
            base32StringStandard.decode("CH72SAI=");
            Array({ #11, #ff, #a9, #01 }*.byte);
        };
    }
    
    test
    shared void decodeFive() {
        assertEquals {
            base32StringStandard.decode("CH72SAAQ");
            Array({ #11, #ff, #a9, #00, #10 }*.byte);
        };
    }
    
    test
    shared void decodeSix() {
        assertEquals {
            base32StringStandard.decode("MZXW6YTBOI======");
            Array({ #66, #6f, #6f, #62, #61, #72 }*.byte);
        };
    }
    
    test
    shared void decodeLong() {
        assertEquals {
            base32StringStandard.decode("IZZGC3TLEBCXQY3IMFXGOZJAJ5TCAVTJMV3XG===");
            Array("Frank Exchange Of Views"*.integer*.byte);
        };
    }
    
    test
    shared void decodeTruncatedByOneOk() {
        assertEquals {
            base32StringStandard.decode("MZXW6YTBOI=====");
            Array({ #66, #6f, #6f, #62, #61, #72 }*.byte);
        };
    }
    
    test
    shared void decodeTruncatedByTwoOk() {
        assertEquals {
            base32StringStandard.decode("MZXW6YTBOI====");
            Array({ #66, #6f, #6f, #62, #61, #72 }*.byte);
        };
    }
    
    test
    shared void decodeTruncatedByThreeOk() {
        assertEquals {
            base32StringStandard.decode("MZXW6YTBOI===");
            Array({ #66, #6f, #6f, #62, #61, #72 }*.byte);
        };
    }
    
    test
    shared void decodeTruncatedByFourOk() {
        assertEquals {
            base32StringStandard.decode("MZXW6YTBOI==");
            Array({ #66, #6f, #6f, #62, #61, #72 }*.byte);
        };
    }
    
    test
    shared void decodeTruncatedByFiveOk() {
        assertEquals {
            base32StringStandard.decode("MZXW6YTBOI=");
            Array({ #66, #6f, #6f, #62, #61, #72 }*.byte);
        };
    }
    
    test
    shared void decodeTruncatedBySixOk() {
        assertEquals {
            base32StringStandard.decode("MZXW6YTBOI");
            Array({ #66, #6f, #6f, #62, #61, #72 }*.byte);
        };
    }
    
    test
    shared void decodeTruncatedBySevenOk() {
        assertEquals {
            base32StringStandard.decode("MZXW6YTBO");
            Array({ #66, #6f, #6f, #62, #61, #70 }*.byte);
        };
    }
}

shared class Base32HexTests() {
    test
    shared void encodeEmpty() {
        assertEquals {
            base32StringHex.encode({});
            "";
        };
    }
    
    test
    shared void encodeOne() {
        assertEquals {
            base32StringHex.encode({ #00 }*.byte);
            "00======";
        };
    }
    
    test
    shared void encodeTwo() {
        assertEquals {
            base32StringHex.encode({ #00, #9f }*.byte);
            "02FG====";
        };
    }
    
    test
    shared void encodeThree() {
        assertEquals {
            base32StringHex.encode({ #11, #ff, #a9 }*.byte);
            "27VQI===";
        };
    }
    
    test
    shared void encodeFour() {
        assertEquals {
            base32StringHex.encode({ #11, #ff, #a9, #01 }*.byte);
            "27VQI08=";
        };
    }
    
    test
    shared void encodeFive() {
        assertEquals {
            base32StringHex.encode({ #11, #ff, #a9, #00, #10 }*.byte);
            "27VQI00G";
        };
    }
    
    test
    shared void encodeLong() {
        assertEquals {
            base32StringHex.encode("Frank Exchange Of Views"*.integer*.byte);
            "8PP62RJB412NGOR8C5N6EP909TJ20LJ9CLRN6===";
        };
    }
    
    test
    shared void encodeSix() {
        assertEquals {
            base32StringHex.encode({ #66, #6f, #6f, #62, #61, #72 }*.byte);
            "CPNMUOJ1E8======";
        };
    }
    
    test
    shared void encodeByteLong() {
        assertEquals {
            base32ByteHex.encode("Frank Exchange Of Views"*.integer*.byte);
            "8PP62RJB412NGOR8C5N6EP909TJ20LJ9CLRN6==="*.integer*.byte;
        };
    }
    
    test
    shared void decodeEmpty() {
        assertEquals {
            base32StringHex.decode("");
            Array<Byte> { };
        };
    }
    
    test
    shared void decodeOne() {
        assertEquals {
            base32StringHex.decode("00======");
            Array({ #00 }*.byte);
        };
    }
    
    test
    shared void decodeTwo() {
        assertEquals {
            base32StringHex.decode("02FG====");
            Array({ #00, #9f }*.byte);
        };
    }
    
    test
    shared void decodeThree() {
        assertEquals {
            base32StringHex.decode("27VQI===");
            Array({ #11, #ff, #a9 }*.byte);
        };
    }
    
    test
    shared void decodeFour() {
        assertEquals {
            base32StringHex.decode("27VQI08=");
            Array({ #11, #ff, #a9, #01 }*.byte);
        };
    }
    
    test
    shared void decodeFive() {
        assertEquals {
            base32StringHex.decode("27VQI00G");
            Array({ #11, #ff, #a9, #00, #10 }*.byte);
        };
    }
    
    test
    shared void decodeSix() {
        assertEquals {
            base32StringHex.decode("CPNMUOJ1E8======");
            Array({ #66, #6f, #6f, #62, #61, #72 }*.byte);
        };
    }
    
    test
    shared void decodeLong() {
        assertEquals {
            base32StringHex.decode("8PP62RJB412NGOR8C5N6EP909TJ20LJ9CLRN6===");
            Array("Frank Exchange Of Views"*.integer*.byte);
        };
    }
    
    test
    shared void decodeByteLong() {
        assertEquals {
            base32ByteHex.decode("8PP62RJB412NGOR8C5N6EP909TJ20LJ9CLRN6==="*.integer*.byte);
            Array("Frank Exchange Of Views"*.integer*.byte);
        };
    }
}
