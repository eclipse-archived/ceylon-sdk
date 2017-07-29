import ceylon.toml.parser {
    parse
}

"Parse a TOML document."
shared TomlTable | TomlParseException parseToml({Character*} input) {
    value [result, *errors] = parse(input);
    if (nonempty errors) {
        return TomlParseException(errors.collect(Exception.message), result);
    }
    return result;
}
