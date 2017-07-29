shared class TomlParseException(
        shared [String+] errors,
        shared TomlTable partialResult)
        extends ParseException("``errors.first`` (``errors.size`` total errors)") {}
