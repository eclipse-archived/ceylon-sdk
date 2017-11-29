/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
import ceylon.toml {
    TomlTable, TomlArray, TomlValue
}
import ceylon.collection {
    IdentitySet
}
import ceylon.time.timezone {
    TimeZone, ZoneDateTime, timeZone, zoneDateTime
}
import ceylon.time {
    Time, Date, DateTime,
    time, date, dateTime
}
import ceylon.toml.internal {
    TomlValueType, elementTypeOf, Producer
}
import ceylon.toml.lexer {
    ...
}

shared [TomlTable, ParseException*] parse({Character*} input) =>
        object satisfies Producer<[TomlTable, ParseException*]> {
    value lexer = Lexer(input);
    value result = TomlTable();
    variable [ParseException*] errors = [];
    variable Token | Finished | Null nextToken = null;
    variable value currentTable = result;
    value createdButNotDefined = IdentitySet<TomlTable>();
    "Arrays defined like `fruit = [...]`"
    value staticallyDefinedArrays = IdentitySet<TomlArray>();

    String formatToken(Token token)
        =>  if (token.type == newline) then "newline"
            else if (token.type == newline) then "eof"
            else if (token.text.shorterThan(10)) then "token '``token.text``'"
            else "'``token.text[...10]``...'";

    ParseException badTokenError(Token? token, String? description = null) {
        value sb = StringBuilder();
        sb.append("unexpected ");
        if (!exists token) {
            sb.append("end-of-file");
        }
        else {
            sb.append(formatToken(token));
        }
        if (exists description) {
            sb.append(": ");
            sb.append(description);
        }
        if (exists token) {
            sb.append(" at ``token.line``:``token.column``");
        }
        value exception = ParseException(sb.string);
        errors = errors.withTrailing(exception);
        return exception;
    }

    ParseException error(Token? token, String description) {
        value exception = ParseException {
            if (exists token)
            then  "``description`` at ``token.line``:``token.column``"
            else description;
        };
        errors = errors.withTrailing(exception);
        return exception;
    }

    "Return the next token if one exists and it matches [[type]]; do not advance. Use
     `true` or no-argument to match any token type."
    Token? peek(Boolean | TokenType | {TokenType*} | Boolean(TokenType) type = true)
        =>  let (token = nextToken else (nextToken = lexer.next()))
            if (is Finished token) then
                null
            else if (is Boolean type) then
                (type then token)
            else if (is TokenType type) then
                (type == token.type then token)
            else if (is {Anything*} type) then
                (token.type in type then token)
            else
                (type(token.type) then token);

    "Advance and return the next token if one exists and it matches [[type]]. Use `true`
     or no-argument to match any token type."
    Token? advance(Boolean | TokenType | {TokenType*} | Boolean(TokenType) type = true) {
        value token = peek(type);
        if (exists token) {
            nextToken = null;
            errors = concatenate(errors, token.errors);
        }
        return token;
    }

    "Advance to the next token and return `true` if one exists and it matches [[type]];
     otherwise return `false`."
    Boolean accept(TokenType | {TokenType*} | Boolean(TokenType) type)
        =>  advance(type) exists;

    "Advance until a token is reached that does not match [[type]]; return the number
     of tokens advanced, which is also the number of matched tokens."
    Integer acceptRun(TokenType | {TokenType*} | Boolean(TokenType) type) {
        variable Integer count = 0;
        while (accept(type)) {
            count++;
        }
        return count;
    }

    "Return true if the next token exists and matches [[type]]; do not advance."
    Boolean check(TokenType | {TokenType*} | Boolean(TokenType) type)
        =>  peek(type) exists;

    "Advance past the next token which must be of the given [[type]], or raise an error
     if the next token does not exist or does not match the given `type`."
    Token consume(
            TokenType | {TokenType*} | Boolean(TokenType) type,
            String errorDescription) {
        if (exists token = advance(type)) {
            return token;
        }
        throw badTokenError(peek(), errorDescription);
    }

    "Return true if there is no next token."
    Boolean endOfFile
        =>  !peek() exists;

    shared actual [TomlTable, ParseException*] get() {
        while (!endOfFile) {
            try {
                lexer.inMode(LexerMode.key, parseLine);
            }
            catch (ParseException e) {
                acceptRun(not(newline.equals));
            }
        }
        return [result, *errors];
    }

     """
            BareKey
     """
    String parseBareKey() {
        value token = consume(bareKey, "expected a bare key");
        validateBareKey(token, token.text);
        return token.text;
    }

     """
            BasicString
     """
    String parseBasicString() {
        value token = consume(basicString, "expected a basic string");
        assert (exists s = token.processedText);
        return String(s);
    }

     """
            MultilineBasicString
     """
    String parseMultilineBasicString() {
        value token = consume(multilineBasicString, "expected a multi-line basic string");
        assert (exists s = token.processedText);
        return String(s);
    }

     """
            LiteralString
     """
    String parseLiteralString() {
        value token = consume(literalString, "expected a literal string");
        assert (exists s = token.processedText);
        return String(s);
    }

     """
            MultilineLiteralString
     """
    String parseMultilineLiteralString() {
        value token = consume(
            multilineLiteralString,
            "expected a multi-line literal string"
        );
        assert (exists s = token.processedText);
        return String(s);
    }

     """
            key : word | basicString | literalString
     """
    String parseKey() {
        switch(peek()?.type)
        case (bareKey) { return parseBareKey(); }
        case (basicString) { return parseBasicString(); }
        case (literalString) { return parseLiteralString(); }
        else {
            throw badTokenError(peek(), "expected a key");
        }
    }

    TomlArray parseArray() {
        value array = TomlArray();
        consume(openBracket, "expected '[' to start an array");
        variable TomlValueType? arrayElementType = null;
        while (!check(closeBracket)) {
            acceptRun([comment, newline]);
            value tokenForError = peek();
            value element = parseValue();
            value elementType = elementTypeOf(element);
            if (exists aet = arrayElementType) {
                if (!aet == elementType) {
                    // log the error, but don't throw; continue parsing
                    error(tokenForError,
                        "found value of type '``elementType``' but expected '``aet``'; \
                         Array data types may not be mixed");
                }
            }
            else {
                arrayElementType = elementType;
            }
            array.add(element);
            acceptRun([comment, newline]);
            // trailing comma ok
            if (!accept(comma)) {
                break;
            }
            acceptRun([comment, newline]);
        }
        acceptRun([comment, newline]);
        consume(closeBracket, "expected ']' to end the array");
        return array;
    }

    TomlTable parseInlineTable() {
        value table = TomlTable();
        consume(openBrace, "expected '{' to start an inline table");
        variable value first = true;
        lexer.inMode {
            LexerMode.key;
            void () {
                if (!check(closeBrace)) {
                    while (first || accept(comma)) {
                        first = false;
                        table.putAll { parseKeyValuePair() };
                    }
                }
            };
        };
        consume(closeBrace, "expected '}' to end the inline table");
        return table;
    }

     """
            Integer: ('+' | '-')? DIGIT+ ('_' DIGIT+)*
     """
    String parseInteger(
            Token? signToken = null,
            Token? leadingDigitsToken = null) {

        value positive
            =   if (exists signToken)
                    then signToken.type == plus
                else if (!leadingDigitsToken exists)
                    then accept(plus) || !accept(minus)
                else true;

        value sb = StringBuilder();

        if (!positive) {
            sb.appendCharacter('-');
        }

        sb.append {
            (leadingDigitsToken
                else consume(digits, "expected digits")).text;
        };

        while (accept(underscore)) {
            value t = consume(digits, "expected digits after '_'");
            sb.append(t.text);
        }

        return sb.string;
    }

     """
            Float: Integer '.' Integer? (('E' | 'e') Integer)?
     """
    Integer | Float parseNumber(
            Token? signToken = null,
            Token? leadingDigitsToken = null) {

        value firstToken
            =   signToken else leadingDigitsToken else peek();

        value wholePart
            =   parseInteger(signToken, leadingDigitsToken);

        value fractionalPart
            =   if (accept(period))
                then parseInteger()
                else null;

        value exponent
            =   if (accept(exponentCharacter))
                then "e" + parseInteger()
                else null;

        if (!fractionalPart exists && !exponent exists) {
            switch (i = Integer.parse(wholePart))
            case (Integer) {
                return i;
            }
            else {
                throw badTokenError(firstToken, "unparsable integer: ``i.message``");
            }
        }
        else {
            value floatString
                =   wholePart
                    + "." + (fractionalPart else "0")
                    + (exponent else "");
            switch (f = Float.parse(floatString))
            case (Float) {
                return f;
            }
            else {
                throw badTokenError(firstToken,  "unparsable float: ``f.message``");
            }
        }
    }

    Integer consumeDigits(
            Token? token, Integer count, String errorCount,
            Range<Integer>? range = null, String? errorRange = null) {
        value t = token else consume(digits, errorCount);
        if (t.text.size != count) {
            throw badTokenError(t, errorCount);
        }
        assert (is Integer result = Integer.parse(t.text));
        if (exists range, !result in range) {
            throw badTokenError(t, errorRange);
        }
        return result;
    }

    Time parseTime(Token? leadingDigitsToken = null) {
        value hours = consumeDigits {
            leadingDigitsToken;
            count = 2;
            errorCount = "expected two digits for hours";
            range = 0..23;
            errorRange = "hours must be between 00 and 23";
        };
        consume(colon, "expected ':'");
        value minutes = consumeDigits {
            null;
            count = 2;
            errorCount = "expected two digits for minutes";
            range = 0..59;
            errorRange = "hours must be between 00 and 59";
        };
        consume(colon, "expected ':'");
        value seconds = consumeDigits {
            null;
            count = 2;
            errorCount = "expected two digits for seconds";
            range = 0..59;
            errorRange = "seconds must be between 00 and 59";
        };
        Integer millis;
        if (accept(period)) {
            value millisToken = consume(digits, "expected milliseconds");
            assert (is Integer ms = Integer.parse(
                        millisToken.text[0:3].padTrailing(3, '0')));
            millis = ms;
        }
        else {
            millis = 0;
        }
        return time(hours, minutes, seconds, millis);
    }

    TimeZone parseTimeZone() {
        if (accept(zuluCharacter)) {
            return timeZone.offset(0);
        }

        value sign
            =   switch (consume([plus, minus].contains,
                        "expected 'Z', '+' or '-' for timezone offset").type)
                case (plus) 1
                else -1;

        value hours = consumeDigits {
            null;
            count = 2;
            errorCount = "expected two digits for hours";
            range = 0..23;
            errorRange = "hours must be between 00 and 23";
        };

        consume(colon, "expected ':'");

        value minutes = consumeDigits {
            null;
            count = 2;
            errorCount = "expected two digits for minutes";
            range = 0..59;
            errorRange = "hours must be between 00 and 59";
        };

        return timeZone.offset(sign * hours, sign * minutes, 0);
    }

    Date | DateTime | ZoneDateTime parseDateTime(Token? leadingDigitsToken = null) {
        value year = consumeDigits {
            leadingDigitsToken;
            count = 4;
            "expected four digits for year";
        };
        consume(minus, "expected '-'");
        value month = consumeDigits {
            null;
            count = 2;
            "expected 2 digits for month";
            range = 1..31;
            errorRange = "month must be between 01 and 12";
        };
        consume(minus, "expected '-'");
        value day = consumeDigits {
            null;
            count = 2;
            "expected 2 digits for day";
            range = 1..31;
            errorRange = "day must be between 01 and 31";
        };

        value timePart = accept(timeCharacter) then parseTime();

        if (!exists timePart) {
            return date(year, month, day);
        }

        value zone = check([zuluCharacter, minus, plus]) then parseTimeZone();

        if (!exists zone) {
            return dateTime(year, month, day, timePart.hours, timePart.minutes,
                    timePart.seconds, timePart.milliseconds);
        }

        return zoneDateTime(zone, year, month, day, timePart.hours, timePart.minutes,
                    timePart.seconds, timePart.milliseconds);
    }

    Integer | Float | Time | Date | DateTime | ZoneDateTime parseNumberOrDate() {
        if (check([plus, minus])) {
            return parseNumber();
        }

        value leadingDigits = consume(digits, "expected digits");

        switch (peek()?.type)
        case (underscore | exponentCharacter) {
            return parseNumber(null, leadingDigits);
        }
        case (colon) {
            return parseTime(leadingDigits);
        }
        case (minus) {
            return parseDateTime(leadingDigits);
        }
        else {
            // it's an integer
            return parseNumber(null, leadingDigits);
        }
    }

     """
            value : basicString | literalString | ...
     """
    TomlValue parseValue() {
        value token = peek();
        switch (type = token?.type)
        case (basicString) { return parseBasicString(); }
        case (multilineBasicString) { return parseMultilineBasicString(); }
        case (literalString) { return parseLiteralString(); }
        case (multilineLiteralString) { return parseMultilineLiteralString(); }
        case (openBracket) { return parseArray(); }
        case (openBrace) { return parseInlineTable(); }
        case (trueKeyword) { advance(); return true; }
        case (falseKeyword) { advance(); return false; }
        case (plus | minus | digits) { return parseNumberOrDate(); }
        else {
            throw badTokenError(peek(), "expected a toml value");
        }
    }

     """
            keyValuePair : key '=' value Comment? (Newline | EOF)
     """
    String->TomlValue parseKeyValuePair() {
        value key = lexer.inMode(LexerMode.key, parseKey);
        consume(equal, "expected '='");
        value item = lexer.inMode(LexerMode.val, parseValue);
        if (is TomlArray item) {
            staticallyDefinedArrays.add(item);
        }
        return key -> item;
    }

    [String*] parseKeyPath() {
        switch (p = peek())
        case (null) {
            throw badTokenError(null, "expected a key");
        }
        else if (p.type == period) {
            throw badTokenError(p, "table name may not start with '.'");
        }
        else if (!p.type in [bareKey, basicString, literalString]) {
            throw badTokenError(p, "expected a key");
        }

        variable {String*} result = [];
        variable value lastWasDot = true;
        variable value lastPart = null of Token?;

        while (exists part = advance([bareKey, basicString, literalString, period])) {
            lastPart = part;

            if (lastWasDot && part.type == period) {
                throw badTokenError(part, "consecutive '.'s may not exist between keys");
            }
            else if (part.type == period) {
                lastWasDot = true;
            }
            else {
                if (!lastWasDot) {
                    throw badTokenError(part, "keys must be separated by '.'");
                }
                lastWasDot = false;
                switch (part.type)
                case (bareKey) {
                    validateBareKey(part, part.text);
                    result = result.follow(part.text);
                }
                case (basicString | literalString) {
                    assert (exists text = part.processedText);
                    result = result.follow(text);
                }
                else {
                    throw badTokenError(part, "invalid key");
                }
            }
        }

        if (lastWasDot) {
            throw badTokenError(lastPart, "table name may not end with '.'");
        }

        return result.sequence().reversed;
    }

    void parseTable() {
        value openToken = consume(openBracket, "expected '['");
        value path = lexer.inMode(LexerMode.key, parseKeyPath);
        if (!nonempty path) {
            throw badTokenError(openToken, "table name must not be empty");
        }
        currentTable = path.indexed.fold(this.result, (table, index -> pathPart) {
            switch (obj = table[pathPart])
            case (TomlTable) {
                return obj;
            }
            case (Null) {
                value newTable = TomlTable();
                createdButNotDefined.add(newTable);
                table[pathPart] = newTable;
                return newTable;
            }
            else if (is TomlArray obj, is TomlTable last = obj.last) {
                // for [whatever.key1.key2] following [[whatever.key1]]
                // just add to the last table in the array
                return last;    
            }
            else {
                currentTable = TomlTable(); // ignore subsequent key/value pairs
                // TODO properly format/escape path in error msg
                throw error(openToken,
                        "a value already exists for the key \
                            '``".".join(path.take(index+1))``'");
            }
        });
        if (!createdButNotDefined.remove(currentTable)) {
            // TODO properly format/escape path in error msg
            throw error(openToken,
                    "table '``".".join(path)``'' has already been defined");
        }
        consume(closeBracket, "expected ']'");
    }

    void parseArrayOfTables() {
        value openToken = consume(doubleOpenBracket, "expected '[['");
        value path = lexer.inMode(LexerMode.key, parseKeyPath);
        if (!nonempty path) {
            throw badTokenError(openToken, "table name must not be empty");
        }
        value container = path.indexed.exceptLast.fold(this.result, (table, index -> pathPart) {
            switch (obj = table[pathPart])
            case (TomlTable) {
                return obj;
            }
            case (Null) {
                value newTable = TomlTable();
                createdButNotDefined.add(newTable);
                table[pathPart] = newTable;
                return newTable;
            }
            else if (is TomlArray obj, obj in staticallyDefinedArrays) {
                // TODO properly format/escape path in error msg
                throw error(openToken,
                        "a statically defined array already exists for the key \
                         '``".".join(path.take(index+1))``'");
            }
            else if (is TomlArray obj, is TomlTable last = obj.last) {
                // for [[whatever.key1.key2]] following [[whatever.key1]]
                // just add to the last table in the array
                return last;
            }
            else {
                currentTable = TomlTable(); // ignore subsequent key/value pairs
                // TODO properly format/escape path in error msg
                throw error(openToken,
                        "a value already exists for the key \
                         '``".".join(path.take(index+1))``'");
            }
        });
        TomlArray array;
        switch (obj = container[path.last])
        case (TomlArray) {
            if (obj in staticallyDefinedArrays) {
                // TODO properly format/escape path in error msg
                throw error(openToken,
                        "a statically defined array already exists for the key \
                         '``".".join(path)``'");
            }
            if (exists first = obj.first) {
                value firstType = elementTypeOf(first);
                if (firstType != TomlValueType.table) {
                    throw error(openToken,
                        "cannot add a Table to an array containing a value of type \
                         '``firstType``' for the key '``".".join(path)``'; Array \
                         data types may not be mixed");
                }
            }
            array = obj;
        }
        case (Null) {
            array = TomlArray();
            container[path.last] = array;
        }
        else {
            // TODO properly format/escape path in error msg
            throw error(openToken,
                    "a non-array value already exists for the key \
                     '``".".join(path)``'");
        }

        currentTable = TomlTable();
        array.add(currentTable);

        consume(doubleCloseBracket, "expected ']]'");
    }

     """
            line : comment | newline | keyValuePair | table | arrayOfTables
     """
    void parseLine() {
        switch (peek()?.type)
        case (comment) { advance(); }
        case (newline) { advance(); }
        case (bareKey | basicString | literalString) {
            value tokenForError = peek();
            let (key -> item = parseKeyValuePair());
            if (currentTable.defines(key)) {
                throw error(tokenForError, "value for ``key`` already defined");
            }
            currentTable[key] = item;
            accept(comment);
            if (!endOfFile && !accept(newline)) {
                throw badTokenError(peek(),
                        "expected a newline or eof after key/value pair");
            }
        }
        case (openBracket) {
            parseTable();
            accept(comment);
            if (!endOfFile && !accept(newline)) {
                throw badTokenError(peek(),
                        "expected a newline or eof after table header");
            }
        }
        case (doubleOpenBracket) {
            parseArrayOfTables();
            accept(comment);
            if (!endOfFile && !accept(newline)) {
                throw badTokenError(peek(),
                        "expected a newline or eof after array of tables header");
            }
        }
        else {
            throw badTokenError(peek());
        }
    }

    void validateBareKey(Token token, String key) {
        function validChar(Character c)
            =>     c in 'A'..'Z'
                || c in 'a'..'z'
                || c in '0'..'9'
                || c == '_' || c == '-'; 
        if (!key.every(validChar)) {
            throw badTokenError {
                token;
                "bare keys may only contain the characters \
                 'A-Z', 'a-z', '0-9', '_', and '-'";
            };
        }
    }
}.get();
