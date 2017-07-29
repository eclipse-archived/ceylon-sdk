import ceylon.test {
    test, assertEquals
}
import ceylon.toml {
    parseToml, formatToml, TomlParseException
}
import ceylon.json {
    parseJson = parse,
    JsonObject
}

shared
object tomlDistTests {
    void runTest(String filename) {
        assert (exists tomlText
            =   `module`.resourceByPath("``filename``.toml")
                        ?.textContent("UTF-8"));
        assert (exists jsonText
            =   `module`.resourceByPath("``filename``.json")
                        ?.textContent("UTF-8"));

        assert (!is TomlParseException toml = parseToml(tomlText));
        assert (is JsonObject json = parseJson(jsonText));

        assertEquals(toml, json);
    }

    void roundTrip(String filename) {
        assert (exists tomlText
            =   `module`.resourceByPath("``filename``.toml")
                        ?.textContent("UTF-8"));

        assert (!is TomlParseException toml = parseToml(tomlText));
        value tomlText2 = formatToml(toml);
        assert (!is TomlParseException toml2 = parseToml(tomlText2));
        assertEquals(toml, toml2);
    }

    // NOTE the date-time "dob" example.toml was changed to a String since
    //      json doesn't support first class dates
    shared test void example() => runTest("example");
    shared test void fruit() => runTest("fruit");
    shared test void hardExample() => runTest("hard_example");
    shared test void exampleRoundTrip() => roundTrip("example");
    shared test void fruitRoundTrip() => roundTrip("fruit");
    shared test void hardExampleRoundTrip() => roundTrip("hard_example");

    shared test void exampleV040RoundTrip() => roundTrip("example-v0.4.0-modified");
}
