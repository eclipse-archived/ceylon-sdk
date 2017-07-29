import ceylon.test {
    test, assertTrue
}
import ceylon.toml {
    parseToml, TomlParseException, TomlArray
}

shared object arrays {
    shared test void empty() => checkValue("[]", TomlArray());
    shared test void el1() => checkValue("[1]", TomlArray { 1 });
    shared test void el2() => checkValue("[1,2]", TomlArray { 1, 2});
    shared test void trailingComma() => checkValue("[1,2,]", TomlArray { 1, 2});

    shared test void emptyComma()
        =>  assertTrue(parseToml("key = [,]") is TomlParseException);

    shared test void tooManyCommas()
        =>  assertTrue(parseToml("key = [1,,2]") is TomlParseException);

    shared test void tooManyCommasTrailing()
        =>  assertTrue(parseToml("key = [1,2,,]") is TomlParseException);

    shared void test() {
        empty();
        emptyComma();
        el1();
        el2();
        trailingComma();
        tooManyCommas();
        tooManyCommasTrailing();
    }
}
