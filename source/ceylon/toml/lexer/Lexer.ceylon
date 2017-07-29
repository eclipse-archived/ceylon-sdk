shared class Lexer({Character*} characters) {
    shared variable LexerMode mode = LexerMode.key;
    value t = Tokenizer(characters);

    shared T inMode<T>(LexerMode mode, T() do) {
        value save = this.mode;
        try {
            this.mode = mode;
            return do();
        }
        finally {
            this.mode = save;
        }
    }

    shared Token | Finished next() {
        switch (c = t.advance())
        case (null) { return finished; }
        case ('{') { return t.newToken(openBrace); }
        case ('}') { return t.newToken(closeBrace); }
        case (',') { return t.newToken(comma); }
        case ('=') { return t.newToken(equal); }
        case ('.') { return t.newToken(period); }
        case (':') { return t.newToken(colon); }
        case ('+') { return t.newToken(plus); }
        case ('[') {
            return t.newToken {
                if (t.accept('['))
                then doubleOpenBracket
                else openBracket;
            };
        }
        case (']') {
            return t.newToken {
                if (t.accept(']'))
                then doubleCloseBracket
                else closeBracket;
            };
        }
        case ('#') {
            t.acceptRun(isCommentCharacter);
            return t.newToken(comment);
        }
        case ('"') {
            if (t.accept('"')) {
                // empty string or start of multiline string
                if (t.accept('"')) {
                    // multi-line
                    value unescaped = acceptStringContent(false, true);
                    return t.newToken(multilineBasicString, unescaped);
                }
                // empty
                return t.newToken(basicString, "");
            }
            // single-line
            value unescaped = acceptStringContent(false, false);
            return t.newToken(basicString, unescaped);
        }
        case ('\'') {
            if (t.accept('\'')) {
                // empty string or start of multiline string
                if (t.accept('\'')) {
                    //  multi-line
                    value unescaped = acceptStringContent(true, true);
                    return t.newToken(multilineLiteralString, unescaped);
                }
                // empty
                return t.newToken(literalString, "");
            }
            // single-line
            value unescaped = acceptStringContent(true, false);
            return t.newToken(literalString, unescaped);
        }
        else if (c == '\r' || c == '\n') {
            t.acceptRun("\r\n");
            return t.newToken(newline);
        }
        else if (c == '\t' || c == ' ') {
            t.acceptRun("\t ");
            t.ignore();
            return next();
        }
        else if (mode == LexerMode.key) {
            if (isBareKeyCharacter(c)) {
                t.acceptRun(isBareKeyCharacter);
                return t.newToken(bareKey);
            }
            else {
                return t.newToken(error);
            }
        }
        else { // mode == LexerMode.val
            switch (c)
            case ('-') { return t.newToken(minus); }
            case ('_') { return t.newToken(underscore); }
            case ('e') { return t.newToken(exponentCharacter); }
            case ('E') { return t.newToken(exponentCharacter); }
            case ('z') { return t.newToken(zuluCharacter); }
            case ('Z') { return t.newToken(zuluCharacter); }
            case ('T') { return t.newToken(timeCharacter); }
            case ('t' | 'f') {
                t.acceptRun(or(Character.letter, Character.digit));
                return switch (t.text())
                    case ("true") t.newToken(trueKeyword)
                    case ("false") t.newToken(falseKeyword)
                    else t.newToken(error);
            }
            else if (c in '0'..'9') {
                t.acceptRun(isDigit);
                return t.newToken(digits);
            }
            else {
                return t.newToken(error);
            }
        }
    }

    String acceptStringContent(Boolean literal, Boolean multiLine) {
        value sb = StringBuilder();
        value quoteChar = literal then '\'' else '"';
        variable value lastWasSlash = false;
        if (multiLine, exists c = t.peek(), c in "\r\n") {
            // ignore immediate newline
            t.accept('\r');
            t.accept('\n');
        }
        while (exists c = t.peek()) {
            if (lastWasSlash) {
                lastWasSlash = false;
                switch (c)
                case ('b') { t.advance(); sb.appendCharacter('\b'); }
                case ('t') { t.advance(); sb.appendCharacter('\t'); }
                case ('n') { t.advance(); sb.appendCharacter('\n'); }
                case ('f') { t.advance(); sb.appendCharacter('\f'); }
                case ('r') { t.advance(); sb.appendCharacter('\r'); }
                case ('"') { t.advance(); sb.appendCharacter('"'); }
                case ('\\') { t.advance(); sb.appendCharacter('\\'); }
                case ('u' | 'U') {
                    t.advance();
                    value expected = c == 'u' then 4 else 8;
                    value digits = t.read(isHexDigit, expected);
                    if (digits.size != expected) {
                        t.error("``expected`` hex digits expected but only \
                                 found ``digits.size``", t.line, t.column);
                    }
                    else {
                        assert (is Integer int = Integer.parse(digits, 16));
                        try {
                            sb.appendCharacter(int.character);
                        }
                        catch (OverflowException e) {
                            t.error("invalid codepoint", t.line, t.column - expected - 2);
                        }
                    }
                }
                else {
                    value possibleError = t.createError(
                            "invalid escape character", t.line, t.column);

                    // if followed by ws then newline, trim ws and newlines
                    value whitespace = t.read(" \t\r");
                    if (t.accept('\n')) {
                        t.acceptRun(" \t\r\n");
                    }
                    else {
                        t.error(possibleError);
                        sb.appendCharacter('\\');
                        sb.append(whitespace);
                    }
                }
            }
            else if (!multiLine && c in "\r\n") {
                break;
            }
            else if (c == quoteChar) {
                t.advance();
                if (!multiLine) {
                    return sb.string;
                }
                else {
                    // if """ done, else accept " or ""
                    if (t.accept(quoteChar)) {
                        if (t.accept(quoteChar)) {
                            return sb.string;
                        }
                        sb.appendCharacter(quoteChar);
                    }
                    sb.appendCharacter(quoteChar);
                }
            }
            else if (c < #20.character && !c in "\r\n") {
                t.error("control character", t.line, t.column);
                t.advance();
                sb.appendCharacter(#FFFD.character);
            }
            else if (!literal && c == '\\') {
                t.advance();
                lastWasSlash = true;
            }
            else {
                t.advance();
                sb.appendCharacter(c);
            }
        }
        if (lastWasSlash) {
            t.error("string ended in '\\'", t.line, t.column);
        }
        t.error("unterminated string", t.line, t.column);
        return sb.string;
    }
}

Boolean anyCharacter
        (Character | {Character*} | Boolean(Character)* patterns)
        (Character c)
    =>  patterns.any((p)
        =>  switch (p)
            case (is Character) c == p
            case (is {Anything*}) c in p
            else p(c));

Boolean(Character) isBareKeyCharacter
    =   anyCharacter(Character.letter, Character.digit, "_-");

Boolean(Character) isCommentCharacter
    =   anyCharacter('\{#20}'..'\{#10ffff}', '\t');

Boolean(Character) isDigit
    =   ('0'..'9').contains;

Boolean(Character) isHexDigit
    =   anyCharacter('0'..'9', 'A'..'F');
