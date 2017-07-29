import ceylon.test {
    test, assertEquals, assertTrue
}
import ceylon.toml {
    parseToml, TomlParseException
}

shared object mlLiteralStrings {
    // TODO what about ''' ''''? Is it a string with " '", or " " and a trailing '?
    shared test void empty() {
        checkValue {
            input = """''''''""";
            expected = "";
        };
    }

    shared test void unterminated() {
        assertTrue {
            parseToml("""key = '''abc""") is TomlParseException;
        };
        assertTrue {
            parseToml("""key = '''abc
                         """) is TomlParseException;
        };
    }

    shared test void dontUnescape() {
        checkValue {
            input = """'''\b\t\n\f\r\"\\''' """;
            expected = """\b\t\n\f\r\"\\""";
        };
    }

    shared test void dontUnescapeError() {
        value input = """key = '''\xhello''' """;
        "\\x is fine for literal strings"
        assert (!is TomlParseException e = parseToml(input));
        assertEquals {
            actual = e.get("key");
            expected = """\xhello""";
        };
    }

    shared test void ignoreUnicode4digit() {
        checkValue {
            input = """'''-\u0023\u0024-''' """;
            expected = """-\u0023\u0024-""";
        };
    }

    shared test void ignoreUnicode8digit() {
        checkValue {
            input = """'''-\U0001D419\U0001D419-''' """;
            expected = """-\U0001D419\U0001D419-""";
        };
    }

    // * A newline immediately following the opening delimiter will be trimmed
    // * All other whitespace and newline characters remain intact

    shared test void twoLine() {
        checkValue {
            input = "'''abc\ndef'''";
            expected = "abc\ndef";
        };
    }

    shared test void twoLineSkipFirst() {
        checkValue {
            input = "'''\nabc\ndef'''";
            expected = "abc\ndef";
        };
    }

    shared test void threeLine() {
        checkValue {
            input = "'''abc\n\ndef'''";
            expected = "abc\n\ndef";
        };
    }

    shared test void threeLineEmptyLast() {
        checkValue {
            input = "'''abc\ndef\n'''";
            expected = "abc\ndef\n";
        };
    }

    shared test void threeLineSkipFirst() {
        checkValue {
            input = "'''\n\nabc\ndef'''";
            expected = "\nabc\ndef";
        };
    }

    shared test void dontEscapeNewline() {
        assertEquals {
            parseToml("key = '''val\\\nue'''");
            map { "key" -> "val\\\nue" };
        };
    }

    shared test void dontEscapeNewline2() {
        assertEquals {
            parseToml("key = '''val\\\n\n\nue'''");
            map { "key" -> "val\\\n\n\nue" };
        };
    }

    shared test void dontEscapeNewlineSpaces() {
        // Tabs not allowed? See https://github.com/toml-lang/toml/issues/474
        // assertEquals {
        //     parseToml("key = '''val\\ \t \nue'''");
        //     map { "key" -> "val\\ \t \nue" };
        // };
        assertEquals {
            parseToml("key = '''val\\   \nue'''");
            map { "key" -> "val\\   \nue" };
        };
    }

    shared void test() {
        empty();
        unterminated();
        dontUnescape();
        dontUnescapeError();
        ignoreUnicode4digit();
        ignoreUnicode8digit();
        twoLine();
        twoLineSkipFirst();
        threeLine();
        threeLineEmptyLast();
        threeLineSkipFirst();
        dontEscapeNewline();
        dontEscapeNewline2();
        dontEscapeNewlineSpaces();
    }
}
