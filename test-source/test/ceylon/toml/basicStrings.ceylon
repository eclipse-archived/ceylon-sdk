import ceylon.test {
    test, assertEquals, assertTrue
}
import ceylon.toml {
    parseToml, TomlParseException
}

shared object basicStrings {
    shared test void empty()
        =>  checkValue("""""""", "");

    shared test void unterminated() {
        assertTrue {
            parseToml("""key = "abc""") is TomlParseException;
        };
        assertTrue {
            parseToml("""key = "abc
                         """) is TomlParseException;
        };
        assertTrue {
            parseToml("""key = "abc
                         key2 = "def" """) is TomlParseException;
        };
    }

    shared test void unterminatedLineRecover() {
        checkValue {
            input = """"abc
                    """;
            expected = "abc";
            withError = true;
        };

        value input = """key = "abc
                         key2 = "def" """;
        assert (is TomlParseException e = parseToml(input));
        assertEquals {
            actual = e.partialResult.get("key2");
            expected = "def";
        };
    }

    shared test void unescapes() {
        checkValue {
            input = """"\b\t\n\f\r\"\\" """;
            expected = "\b\t\n\f\r\"\\";
        };
    }

    shared test void unescapeError() {
        checkValue {
            input = """"\xhello" """;
            expected = "\\xhello";
            withError = true;
        };
    }

    shared test void unicode4digit() {
        checkValue {
            input = """"-\u0023\u0024-" """;
            expected = "-#$-";
        };
    }

    shared test void unicode8digit() {
        checkValue {
            input = """"-\U0001D419\U0001D419-" """;
            expected = "-\{#01D419}\{#01D419}-";
        };
    }

    shared test void unicode4digitLengthErrors() {
        assertTrue {
            parseToml("""key = "\u023 " """) is TomlParseException;
            "Too few 'u' digits then non-hex char";
        };
        assertTrue {
            parseToml("""key = "\u023" """) is TomlParseException;
            "Too few 'u' digits then end of string";
        };
        assertTrue {
            parseToml("""key = "\u023
                         """) is TomlParseException;
            "Too few 'u' digits then newline";
        };
        assertTrue {
            parseToml("""key = "\u023""") is TomlParseException;
            "Too few 'u' digits then eof";
        };
    }

    shared test void unicode8digitLengthErrors() {
        assertTrue {
            parseToml("""key = "\U001D419 " """) is TomlParseException;
            "Too few 'U' digits then non-hex char";
        };
        assertTrue {
            parseToml("""key = "\U001D419" """) is TomlParseException;
            "Too few 'U' digits then end of string";
        };
        assertTrue {
            parseToml("""key = "\U001D419
                         """) is TomlParseException;
            "Too few 'U' digits then newline";
        };
        assertTrue {
            parseToml("""key = "\U001D419""") is TomlParseException;
            "Too few 'U' digits then eof";
        };
    }

    shared test void unicodeBadCodePoint() {
        assertTrue {
            parseToml("""key = "\U00110000" """) is TomlParseException;
        };
    }

    shared test void escapeNewline() {
        assertEquals {
            parseToml("key = \"val\\\nue\"");
            map { "key" -> "value" };
        };
    }

    shared test void escapeNewline2() {
        assertEquals {
            parseToml("key = \"val\\\n\n\nue\"");
            map { "key" -> "value" };
        };
    }

    shared test void escapeNewlineSpaces() {
        assertEquals {
            parseToml("key = \"val\\ \t \nue\"");
            map { "key" -> "value" };
        };
    }

    shared void test() {
        empty();
        unterminated();
        unterminatedLineRecover();
        unescapes();
        unescapeError();
        unicode4digit();
        unicode8digit();
        unicode4digitLengthErrors();
        unicode8digitLengthErrors();
        unicodeBadCodePoint();
        escapeNewline();
        escapeNewline2();
        escapeNewlineSpaces();
    }
}
