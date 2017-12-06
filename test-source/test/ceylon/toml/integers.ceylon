import ceylon.test {
    test, assertTrue
}
import ceylon.toml {
    parseToml, TomlParseException
}

shared object integers {
    shared test void simpleIntegers() {
        checkValue { input = "-0"; expected = 0; };
        checkValue { input = "0"; expected = 0; };
        checkValue { input = "+0"; expected = 0; };
        checkValue { input = "-5"; expected = -5; };
        checkValue { input = "5"; expected = 5; };
        checkValue { input = "+5"; expected = 5; };
    }

    shared test void tooLarge() {
        assertTrue {
            parseToml("key = ``runtime.maxIntegerValue``0") is TomlParseException;
        };
    }

    shared test void tooSmall() {
        assertTrue {
            parseToml("key = -``runtime.minIntegerValue``0") is TomlParseException;
        };
    }

    shared test void underscore() {
        checkValue { input = "-1_2"; expected = -12; };
        checkValue { input =  "1_2"; expected = 12; };
        checkValue { input = "+1_2"; expected = 12; };

        checkValue { input = "-1_2_3"; expected = -123; };
        checkValue { input =  "1_2_3"; expected = 123; };
        checkValue { input = "+1_2_3"; expected = 123; };
    }

    shared test void badUnderscore() {
        assertTrue(parseToml("key = -1__0") is TomlParseException);
        assertTrue(parseToml("key =  1__0") is TomlParseException);
        assertTrue(parseToml("key = +1__0") is TomlParseException);

        assertTrue(parseToml("key = -_10") is TomlParseException);
        assertTrue(parseToml("key =  _10") is TomlParseException);
        assertTrue(parseToml("key = +_10") is TomlParseException);

        assertTrue(parseToml("key = -10_") is TomlParseException);
        assertTrue(parseToml("key =  10_") is TomlParseException);
        assertTrue(parseToml("key = +10_") is TomlParseException);
    }

    shared test void badTrailingChar() {
        checkValue {
            input = "11a";
            expected = 11;
            withError = true;
        };
    }

    shared void test() {
        simpleIntegers();
        tooLarge();
        tooSmall();
        underscore();
        badUnderscore();
        badTrailingChar();
    }
}
