shared class Token(type, text, position, line, column,
        errors, processedText = null) {

    shared TokenType type;
    shared String text;
    shared String? processedText;
    shared Integer position;
    shared Integer line;
    shared Integer column;
    shared [ParseException*]  errors;

    string => "Token(``type.string``)";
}
