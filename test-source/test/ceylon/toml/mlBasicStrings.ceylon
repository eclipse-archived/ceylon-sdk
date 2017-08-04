import ceylon.test {
    test, assertEquals, assertTrue
}
import ceylon.toml {
    parseToml, TomlParseException
}

shared object mlBasicStrings {
    value tq = "\"\"\"";

    shared test void empty() {
        checkValue {
            input = "``tq````tq``";
            expected = "";
        };
    }

    shared test void unterminated() {
        assertTrue {
            parseToml("key = ``tq``abc") is TomlParseException;
        };
        assertTrue {
            parseToml("key = ``tq``abc
                       ") is TomlParseException;
        };
    }

    shared test void unescapes() {
        checkValue {
            input = "``tq``\\b\\t\\n\\f\\r\\\"\\\\``tq``";
            expected = "\b\t\n\f\r\"\\";
        };
    }

    shared test void unescapeError() {
        value input = "key = ``tq``\\xhello``tq`` ";
        "Illegal escape \\x should generate an error"
        assert (is TomlParseException e = parseToml(input));
        assertEquals {
            actual = e.partialResult.get("key");
            expected = "\\xhello";
            "should produce result anyway";
        };
    }

    shared test void unicode4digit() {
        checkValue {
            input = "``tq``-\\u0023\\u0024-``tq`` ";
            expected = "-#$-";
        };
    }

    shared test void unicode8digit() {
        checkValue {
            input = "``tq``-\\U0001D419\\U0001D419-``tq``";
            expected = "-\{#01D419}\{#01D419}-";
        };
    }

    shared test void unicode4digitLengthErrors() {
        assertTrue {
            parseToml("key = ``tq``\\u023 ``tq``") is TomlParseException;
            "Too few 'u' digits then non-hex char";
        };
        assertTrue {
            parseToml("key = ``tq``\\u023``tq``") is TomlParseException;
            "Too few 'u' digits then end of string";
        };
        assertTrue {
            parseToml("key = ``tq``\\u023
                       ``tq``") is TomlParseException;
            "Too few 'u' digits then newline";
        };
        assertTrue {
            parseToml("key = ``tq``\\u023``tq``") is TomlParseException;
            "Too few 'u' digits then eof";
        };
    }

    shared test void unicode8digitLengthErrors() {
        assertTrue {
            parseToml("key = ``tq``\\U001D419 ``tq``") is TomlParseException;
            "Too few 'U' digits then non-hex char";
        };
        assertTrue {
            parseToml("key = ``tq``\\U001D419``tq``") is TomlParseException;
            "Too few 'U' digits then end of string";
        };
        assertTrue {
            parseToml("key = ``tq``\\U001D419
                       ``tq``") is TomlParseException;
            "Too few 'U' digits then newline";
        };
        assertTrue {
            parseToml("key = ``tq``\\U001D419") is TomlParseException;
            "Too few 'U' digits then eof";
        };
    }

    shared test void unicodeBadCodePoint() {
        assertTrue {
            parseToml("key = ``tq``\\U00110000``tq``") is TomlParseException;
        };
    }

    // * A newline immediately following the opening delimiter will be trimmed
    // * All other whitespace and newline characters remain intact

    shared test void twoLine() {
        checkValue {
            input = "``tq``abc\ndef``tq``";
            expected = "abc\ndef";
        };
    }

    shared test void twoLineSkipFirst() {
        checkValue {
            input = "``tq``\nabc\ndef``tq``";
            expected = "abc\ndef";
        };
    }

    shared test void threeLine() {
        checkValue {
            input = "``tq``abc\n\ndef``tq``";
            expected = "abc\n\ndef";
        };
    }

    shared test void threeLineEmptyLast() {
        checkValue {
            input = "``tq``abc\ndef\n``tq``";
            expected = "abc\ndef\n";
        };
    }

    shared test void threeLineSkipFirst() {
        checkValue {
            input = "``tq``\n\nabc\ndef``tq``";
            expected = "\nabc\ndef";
        };
    }

    shared test void escapeNewline() {
        assertEquals {
            parseToml("key = ``tq``val\\\nue``tq``");
            map { "key" -> "value" };
        };
    }

    shared test void escapeNewline2() {
        assertEquals {
            parseToml("key = ``tq``val\\\n\n\nue``tq``");
            map { "key" -> "value" };
        };
    }

    shared test void escapeNewlineSpaces() {
        assertEquals {
            parseToml("key = ``tq``val\\ \t \nue``tq``");
            map { "key" -> "value" };
        };
    }

    shared void test() {
        empty();
        unterminated();
        unescapes();
        unescapeError();
        unicode4digit();
        unicode8digit();
        unicode4digitLengthErrors();
        unicode8digitLengthErrors();
        unicodeBadCodePoint();
        twoLine();
        twoLineSkipFirst();
        threeLine();
        threeLineEmptyLast();
        threeLineSkipFirst();
        escapeNewline();
        escapeNewline2();
        escapeNewlineSpaces();
    }
}
