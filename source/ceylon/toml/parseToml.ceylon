import ceylon.toml.parser {
    parse
}

"Parse a TOML document."
throws(`class TomlParseException`, "If the input cannot be parsed")
shared TomlTable | TomlParseException parseToml({Character*} input) {
    value [result, *errors] = parse(input);
    if (nonempty errors) {
        return TomlParseException(errors.collect(Exception.message), result);
    }
    return result;
}
