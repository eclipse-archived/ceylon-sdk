import ceylon.buffer.base {
    base32StringStandard,
    base32StringHex
}
import ceylon.test {
    assertEquals,
    test
}

shared class Base32StringStandardTests() {
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
    shared void encodeLong() {
        assertEquals {
            base32StringStandard.encode("Frank Exchange Of Views"*.integer*.byte);
            "IZZGC3TLEBCXQY3IMFXGOZJAJ5TCAVTJMV3XG===";
        };
    }
}

shared class Base32StringHexTests() {
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
}
