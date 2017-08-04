import ceylon.test {
    assertEquals
}
import ceylon.toml {
    parseToml, TomlParseException, TomlValue
}

void checkValue(
        String input,
        TomlValue? expected,
        Boolean withError = false,
        Boolean eofAfter = true) {

    value suffix = eofAfter then "" else "\n";
    value result = parseToml("key = ``input````suffix``");

    if (withError) {
        "parse error expected"
        assert (is TomlParseException result);
        assertEquals(result.partialResult.get("key"), expected);
    }
    else {
        "no parse error expected"
        assert (!is TomlParseException result);
        assertEquals(result.get("key"), expected);
    }
}
