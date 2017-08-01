import ceylon.test {
    test, fail, assertEquals
}
import ceylon.toml {
    formatToml, TomlArray, TomlTable
}

shared object formatTomlTests {
    shared test void array() {
        assertEquals {
            expected = "key = [ 1, 2 ]\n";
            actual = formatToml {
                TomlTable {
                    "key" -> TomlArray {
                        1, 2
                    }
                };
            };
        };
    }

    shared test void mixedArray() {
        try {
            formatToml {
                TomlTable {
                    "key" -> TomlArray {
                        1, true
                    }
                };
            };
        }
        catch (AssertionError e) {
            return;
        }
        fail("expected AssertionError");
    }

    shared void test() {
        array();
        mixedArray();
    }
}
