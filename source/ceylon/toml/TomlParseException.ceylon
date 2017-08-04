"A [[ParseException]] that may be thrown by [[parseToml]]."
shared class TomlParseException(
        "A list of parse errors"
        shared [String+] errors,
        "A [[TomlTable]] representing the parsable portions of the input document"
        shared TomlTable partialResult)
        extends ParseException("``errors.first`` (``errors.size`` total errors)") {}
