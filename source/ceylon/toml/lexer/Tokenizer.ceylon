/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
shared class Tokenizer({Character*} input,
        Integer offsetPosition = 0,
        Integer offsetLine = 1,
        Integer offsetColumn = 1) {

    value builder = StringBuilder();
    value iterator = PeekingIterator(input.iterator());

    variable Integer position = offsetPosition;
    shared variable Integer line = offsetLine;
    shared variable Integer column = offsetColumn;

    shared variable Integer startPosition = position;
    shared variable Integer startLine = line;
    shared variable Integer startColumn = column;

    variable [ParseException*] errors = [];

    "Create an error, but don't add it to the list of errors, yet."
    shared ParseException createError(
            String description,
            Integer line = startLine,
            Integer column = startColumn) {
        value sb = StringBuilder();
        sb.append(description);
        sb.append(" at ``line``:``column``");
        value exception = ParseException(sb.string);
        return exception;
    }

    shared ParseException error(
            String | ParseException description,
            Integer line = startLine,
            Integer column = startColumn) {
        ParseException e;
        if (is ParseException description) {
            e = description;
        }
        else {
            e = createError(description, line, column);
        }
        errors = errors.withTrailing(e);
        return e;
    }

    shared Character? advance() {
        if (!is Finished c = iterator.next()) {
            position += 1;
            if (c == '\n') {
                line += 1;
                column = 1;
            }
            else if (c != '\r') {
                column += 1;
            }
            builder.appendCharacter(c);
            return c;
        }
        return null;
    }

    shared void ignore() {
        builder.clear();
        startPosition = position;
        startLine = line;
        startColumn = column;
    }

    shared Character? peek()
        =>  if (!is Finished p = iterator.peek()) then p else null;

    Boolean check(Character c, Character | {Character*} | Boolean(Character) valid)
        =>  switch (valid)
            case (Character) c == valid
            case (Iterable<Anything>) c in valid
            else valid(c);

    shared Boolean accept(Character | {Character*} | Boolean(Character) valid) {
        if (exists c = peek(), check(c, valid)) {
            advance();
            return true;
        }
        return false;
    }

    shared Integer acceptRun(Character | {Character*} | Boolean(Character) valid) {
        variable value count = 0;
        while (accept(valid)) {
            count++;
        }
        return count;
    }

    shared String read(
            Character | {Character*} | Boolean(Character) valid,
            Integer maxLength = runtime.maxIntegerValue) {
        value sb = StringBuilder();
        variable value count = 0;
        while (count++ < maxLength, exists c = peek(), check(c, valid)) {
            sb.appendCharacter(c);
            advance();
        }
        return sb.string;
    }

    shared String text()
        =>  builder.string;

    shared Token newToken(
            TokenType type,
            String? processedText = null) {
        value result = Token(
                type, text(),
                startPosition, startLine, startColumn,
                errors, processedText);
        ignore();
        errors = [];
        return result;
    }
}
