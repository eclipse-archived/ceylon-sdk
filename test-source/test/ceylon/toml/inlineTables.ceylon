import ceylon.test {
    test, assertTrue
}
import ceylon.toml {
    parseToml, TomlParseException, TomlTable
}

shared object inlineTables {
    shared test void empty() => checkValue("{}", TomlTable());
    shared test void el1() => checkValue("{a=1}", TomlTable {"a"->1});
    shared test void el2() => checkValue("{a=1,b=2}", TomlTable {"a"->1,"b"->2});

    shared test void trailingComma()
        =>  assertTrue(parseToml("key = {a=1,b=2,}") is TomlParseException);

    shared test void emptyComma()
        =>  assertTrue(parseToml("key = {,}") is TomlParseException);

    shared test void tooManyCommas()
        =>  assertTrue(parseToml("key = {a=1,,b=2}") is TomlParseException);

    shared test void tooManyCommasTrailing()
        =>  assertTrue(parseToml("key = {a=1,b=2,,}") is TomlParseException);

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
