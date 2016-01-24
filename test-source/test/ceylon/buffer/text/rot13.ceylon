import ceylon.buffer.text {
    rot13
}
import ceylon.test {
    test,
    assertEquals
}

shared class Rot13Tests() {
    test
    shared void encodeZero() {
        assertEquals {
            rot13.encode("");
            "";
        };
    }
    
    test
    shared void encodeOne() {
        assertEquals {
            rot13.encode("T");
            "G";
        };
    }
    
    test
    shared void encodeTwo() {
        assertEquals {
            rot13.encode("zZ");
            "mM";
        };
    }
    
    shared void encodeThree() {
        assertEquals {
            rot13.encode("AaY");
            "NnL";
        };
    }
    
    test
    shared void encodeAll() {
        assertEquals {
            rot13.encode("The Quick Brown Fox Jumps Over The Lazy Dog.");
            "Gur Dhvpx Oebja Sbk Whzcf Bire Gur Ynml Qbt.";
        };
    }
    
    test
    shared void decodeZero() {
        assertEquals {
            rot13.decode("");
            "";
        };
    }
    
    test
    shared void decodeOne() {
        assertEquals {
            rot13.decode("G");
            "T";
        };
    }
    
    test
    shared void decodeTwo() {
        assertEquals {
            rot13.decode("mM");
            "zZ";
        };
    }
    
    shared void decodeThree() {
        assertEquals {
            rot13.decode("NnL");
            "AaY";
        };
    }
    
    test
    shared void decodeAll() {
        assertEquals {
            rot13.decode("Gur Dhvpx Oebja Sbk Whzcf Bire Gur Ynml Qbt.");
            "The Quick Brown Fox Jumps Over The Lazy Dog.";
        };
    }
}
