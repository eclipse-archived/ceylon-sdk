import ceylon.test {
    test, assertTrue
}
import ceylon.toml {
    parseToml, TomlParseException
}

shared object floats {
    shared test void simpleFloats() {
        checkValue { input = "-0.0"; expected = 0.0; };
        checkValue { input = "0.0"; expected = 0.0; };
        checkValue { input = "+0.0"; expected = 0.0; };
        checkValue { input = "-5.1"; expected = -5.1; };
        checkValue { input = "5.1"; expected = 5.1; };
        checkValue { input = "+5.1"; expected = 5.1; };
    }

    shared test void exponents() {
        checkValue { input = "1.2e3"; expected = 1.2e3; };
        checkValue { input = "1.2e-3"; expected = 1.2e-3; };

        checkValue { input = "-1.2e3"; expected = -1.2e3; };
        checkValue { input = "-1.2e-3"; expected = -1.2e-3; };
    }

    shared test void exponentNoFractionals() {
        checkValue { input = "1e3"; expected = 1.0e3; };
        checkValue { input = "1e-3"; expected = 1.0e-3; };

        checkValue { input = "-1e3"; expected = -1.0e3; };
        checkValue { input = "-1e-3"; expected = -1.0e-3; };
    }

    shared test void underscoreWhole() {
        checkValue { input = "-0_1.2"; expected = -1.2; };
        checkValue { input =  "0_1.2"; expected = 1.2; };
        checkValue { input = "+0_1.2"; expected = 1.2; };

        checkValue { input = "-1_0.2"; expected = -10.2; };
        checkValue { input =  "1_0.2"; expected = 10.2; };
        checkValue { input = "+1_0.2"; expected = 10.2; };

        checkValue { input = "-1_0_0.2"; expected = -100.2; };
        checkValue { input =  "1_0_0.2"; expected = 100.2; };
        checkValue { input = "+1_0_0.2"; expected = 100.2; };
    }

    shared test void underscoreFractional() {
        checkValue { input = "0.0_1"; expected = 0.01; };
        checkValue { input = "0.0_1_2"; expected = 0.012; };
    }

    shared test void underscoreExponent() {
        checkValue { input = "1e-1_0"; expected = 1.0e-10; };
        checkValue { input = "1e-2_1_0"; expected = 1.0e-210; };

        checkValue { input = "1e1_0"; expected = 1.0e10; };
        checkValue { input = "1e2_1_0"; expected = 1.0e210; };

        checkValue { input = "1e+1_0"; expected = 1.0e10; };
        checkValue { input = "1e+2_1_0"; expected = 1.0e210; };
    }

    shared test void badUnderscoreWhole() {
        assertTrue(parseToml("key = -1__0.0") is TomlParseException);
        assertTrue(parseToml("key =  1__0.0") is TomlParseException);
        assertTrue(parseToml("key = +1__0.0") is TomlParseException);

        assertTrue(parseToml("key = -_10.0") is TomlParseException);
        assertTrue(parseToml("key =  _10.0") is TomlParseException);
        assertTrue(parseToml("key = +_10.0") is TomlParseException);

        assertTrue(parseToml("key = -10_.0") is TomlParseException);
        assertTrue(parseToml("key =  10_.0") is TomlParseException);
        assertTrue(parseToml("key = +10_.0") is TomlParseException);

        assertTrue(parseToml("key = -10_e0") is TomlParseException);
        assertTrue(parseToml("key =  10_e0") is TomlParseException);
        assertTrue(parseToml("key = +10_e0") is TomlParseException);
    }

    shared test void badUnderscoreFractional() {
        assertTrue(parseToml("key =  1.0__1") is TomlParseException);
        assertTrue(parseToml("key =  1._12") is TomlParseException);
        assertTrue(parseToml("key =  1.12_") is TomlParseException);
        assertTrue(parseToml("key =  1.12_e0") is TomlParseException);
    }

    shared test void badUnderscoreExponent() {
        assertTrue(parseToml("key = 1.0e-1__2") is TomlParseException);
        assertTrue(parseToml("key = 1.0e1__2") is TomlParseException);
        assertTrue(parseToml("key = 1.0e+1__2") is TomlParseException);

        assertTrue(parseToml("key = 1.0e-_12") is TomlParseException);
        assertTrue(parseToml("key = 1.0e_12") is TomlParseException);
        assertTrue(parseToml("key = 1.0e+_12") is TomlParseException);

        assertTrue(parseToml("key = 1.0e-12_") is TomlParseException);
        assertTrue(parseToml("key = 1.0e12_") is TomlParseException);
        assertTrue(parseToml("key = 1.0e+12_") is TomlParseException);
    }

    shared test void badTrailingChar() {
        checkValue {
            input = "1.0a";
            expected = 1.0;
            withError = true;
        };
    }

    shared void test() {
        simpleFloats();
        exponents();
        exponentNoFractionals();
        underscoreWhole();
        underscoreFractional();
        underscoreExponent();
        badUnderscoreWhole();
        badUnderscoreFractional();
        badUnderscoreExponent();
        badTrailingChar();
    }
}
