import ceylon.test {
    test, assertTrue, ignore
}
import ceylon.toml {
    parseToml, TomlParseException, TomlArray
}

shared object arrays {
    shared test void empty() => checkValue("[]", TomlArray());
    shared test void el1() => checkValue("[1]", TomlArray { 1 });
    shared test void el2() => checkValue("[1,2]", TomlArray { 1, 2 });
    shared test void trailingComma() => checkValue("[1,2,]", TomlArray { 1, 2 });

    shared test void emptyComma()
        =>  assertTrue(parseToml("key = [,]") is TomlParseException);

    shared test void tooManyCommas()
        =>  assertTrue(parseToml("key = [1,,2]") is TomlParseException);

    shared test void tooManyCommasTrailing()
        =>  assertTrue(parseToml("key = [1,2,,]") is TomlParseException);

    shared test void mixedArrays() {
        assertTrue(parseToml("""key = [0,{a=1}]""") is TomlParseException);
        assertTrue(parseToml("""key = [0,[0]]""") is TomlParseException);
        assertTrue(parseToml("""key = [0,10:10:10]""") is TomlParseException);
        assertTrue(parseToml("""key = [0,1979-05-27]""") is TomlParseException);
        assertTrue(parseToml("""key = [1979-05-27,1979-05-27T07:32:00]""") is TomlParseException);
        assertTrue(parseToml("""key = [1979-05-27T07:32:00, 1979-05-27T07:32:00Z]""") is TomlParseException);
        assertTrue(parseToml("""key = [0,true]""") is TomlParseException);
        assertTrue(parseToml("""key = [0,1.0]""") is TomlParseException);
        assertTrue(parseToml("""key = ["0",1]""") is TomlParseException);
        assertTrue(parseToml("""key = [0,""]""") is TomlParseException);
    }

    "elements that are arrays may have different element types"
    shared test void mixedArraysOk()    
        =>  checkValue("[ [0], [1.0] ]", TomlArray { TomlArray { 0 }, TomlArray { 1.0 } });

    ignore
    shared test void trickyMixedArray()
        =>  assertTrue {
                parseToml {
                    // elements in the array for k2 are mixed
                    // { k1->{ k2->{ 0, { k3->1 } } } }
                    """
                        [k1]
                        k2 = [0]
                        [[k1.k2]]
                        k3 = 1
                    """;
                } is TomlParseException;
            };

    shared void test() {
        empty();
        emptyComma();
        el1();
        el2();
        trailingComma();
        tooManyCommas();
        tooManyCommasTrailing();
        mixedArrays();
        mixedArraysOk();
        trickyMixedArray();
    }
}
