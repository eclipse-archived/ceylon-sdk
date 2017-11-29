/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
"Parse true, consuming any initial whitespace"
shared Boolean parseTrue(Tokenizer tokenizer){
    tokenizer.eatSpacesUntil('t');
    tokenizer.eat('r');
    tokenizer.eat('u');
    tokenizer.eat('e');
    return true;
}
"Parse false, consuming any initial whitespace"
shared Boolean parseFalse(Tokenizer tokenizer){
    tokenizer.eatSpacesUntil('f');
    tokenizer.eat('a');
    tokenizer.eat('l');
    tokenizer.eat('s');
    tokenizer.eat('e');
    return false;
}
"Parse null, consuming any initial whitespace"
shared Null parseNull(Tokenizer tokenizer){
    tokenizer.eatSpacesUntil('n');
    tokenizer.eat('u');
    tokenizer.eat('l');
    tokenizer.eat('l');
    return null;
}
"Parse a String literal, consuming any initial whitespace"
shared String parseKeyOrString(Tokenizer tokenizer){
    tokenizer.eatSpacesUntil('"');
    StringBuilder buf = StringBuilder();
    while(!tokenizer.check('"')){
        Character c = tokenizer.eatChar();
        if(c == '\\'){
            buf.append(parseStringEscape(tokenizer).string);
        }else{
            buf.append(c.string);
        }
    }
    return buf.string;
}
Character parseStringEscape(Tokenizer tokenizer){
    Character c = tokenizer.eatChar();
    if(c == '"'
        || c == '\\'
            || c == '/'){
        return c;
    }
    if(c == 'b'){
        return '\b';
    }
    if(c == 'f'){
        return '\f';
    }
    if(c == 'r'){
        return '\r';
    }
    if(c == 'n'){
        return '\n';
    }
    if(c == 't'){
        return '\t';
    }
    if(c == 'u'){
        return parseStringUnicode(tokenizer);
    }
    throw ParseException(
        "Expected String escape sequence, got `` c `` TERM ", 
        tokenizer.line, tokenizer.column);
}
Character parseStringUnicode(Tokenizer tokenizer){
    Integer codePoint = 
            parseHex(tokenizer) * 16 ^ 3
            + parseHex(tokenizer) * 16 ^ 2
            + parseHex(tokenizer) * 16
            + parseHex(tokenizer);
    return codePoint.character;
}
Integer parseHex(Tokenizer tokenizer){
    Character c = tokenizer.eatChar();
    Integer codePoint = c.integer;
    if(codePoint >= '0'.integer && 
        codePoint <= '9'.integer){
        return codePoint - '0'.integer;
    }
    if(codePoint >= 'a'.integer && 
        codePoint <= 'f'.integer){
        return 10 + codePoint - 'a'.integer;
    }
    if(codePoint >= 'A'.integer && 
        codePoint <= 'F'.integer){
        return 10 + codePoint - 'A'.integer;
    }
    throw ParseException(
        "Expecting hex number, got `` c ``", 
        tokenizer.line, tokenizer.column);
}

"Parse a number, consuming any initial whitespace."
shared Integer|Float parseNumber(Tokenizer tokenizer){
    tokenizer.eatSpaces();
    value wholePart = parseDigits(tokenizer, true, true);
    value decimalPart = tokenizer.hasMore && tokenizer.check('.')
            then "." + parseDigits(tokenizer, false, false);
    value exponentPart = parseExponent(tokenizer);

    if (decimalPart exists || exponentPart exists) {
        value floatString = wholePart + (decimalPart else "") + (exponentPart else "");
        assert (is Float float = Float.parse(floatString));
        return float;
    } else {
        value integer = Integer.parse(wholePart);
        if (is Integer integer) {
            return integer;
        } else {
            // It must be too large or too small to be represented
            // as an Integer. Return a Float instead.
            assert (is Float float = Float.parse(wholePart));
            return float;
        }
    }
}
String parseDigits(Tokenizer tokenizer, Boolean requireNonZeroFirstChar,
        Boolean allowNegative) {
    variable value c = tokenizer.eatChar();
    variable value negative = false;
    if (allowNegative && c == '-') {
        negative = true;
        c = tokenizer.eatChar();
    }
    if(!tokenizer.isDigit(c)){
        throw ParseException(
            "Expected digit, got: `` c ``", 
            tokenizer.line, tokenizer.column);
    }
    if (requireNonZeroFirstChar && c == '0' && tokenizer.hasMore
            && tokenizer.isDigit(tokenizer.character())) {
        throw ParseException(
            "Expected non-zero digit, got: `` c ``", 
            tokenizer.line, tokenizer.column);
    }
    value buf = StringBuilder();
    if (negative) {
        buf.appendCharacter('-');
    }
    buf.appendCharacter(c);
    while(tokenizer.hasMore && tokenizer.isDigit(tokenizer.character())) {
        buf.appendCharacter(tokenizer.eatChar());
    }
    return buf.string;
}
Integer parseDigit(Character c)
        => c.integer - '0'.integer;
String? parseExponent(Tokenizer tokenizer){
    if(tokenizer.hasMore && (tokenizer.check('e')
        || tokenizer.check('E'))) {
        tokenizer.check('+'); // ignore leading '+'
        assert (is Integer exponentPart
            = Integer.parse(parseDigits(tokenizer, false, true)));
        return "E" + exponentPart.string; 
    }
    return null;
}


"A parser for JSON data presented as a Tokenizer which calls  
 the given visitor for each matched rule. 
 
 To construct a JSON model the visitor would be a [[Builder]]."
by("Stéphane Épardaud")
shared class Parser(tokenizer, visitor) {
    
    "The data to be parsed."
    Tokenizer tokenizer;
    
    "The visitor to called for each matched rule."
    shared Visitor visitor;
    
    void parseObject(){
        visitor.onStartObject();
        tokenizer.eatSpacesUntil('{');
        tokenizer.eatSpaces();
        if(!tokenizer.check('}')){
            
            while(true){
                String key = parseKeyOrString(tokenizer);
                tokenizer.eatSpacesUntil(':');
                visitor.onKey(key);
                parseValue();
                
                tokenizer.eatSpaces();
                if(tokenizer.check('}')){
                    break;
                }
                if(!tokenizer.check(',')){
                    throw ParseException(
                        "Expected '}' or ',' but got `` tokenizer.character() ``", 
                        tokenizer.line, tokenizer.column);
                }
            }
        }
        visitor.onEndObject();
    }
    
    void parseArray(){
        visitor.onStartArray();
        tokenizer.eatSpacesUntil('[');
        tokenizer.eatSpaces();
        if(!tokenizer.check(']')){
            while(true){
                parseValue();
                
                tokenizer.eatSpaces();
                if(tokenizer.check(']')){
                    break;
                }
                if(!tokenizer.check(',')){
                    throw ParseException(
                        "Expected ']' or ',' but got `` tokenizer.character() ``", 
                        tokenizer.line, tokenizer.column);
                }
            }
        }
        visitor.onEndArray();
    }
    
    throws(`class ParseException`, 
        "If the specified string cannot be parsed")
    shared void parseValue(){
        tokenizer.eatSpaces();
        Character c = tokenizer.character();
        if(c == '{'){
            parseObject();
            return;
        }
        if(c == '['){
            parseArray();
            return;
        }
        if(c == '"'){
            parseString();
            return;
        }
        if(c == 't'){
            visitor.onBoolean(parseTrue(tokenizer));
            return;
        }
        if(c == 'f'){
            visitor.onBoolean(parseFalse(tokenizer));
            return;
        }
        if(c == 'n'){
            parseNull(tokenizer);
            visitor.onNull();
            return;
        }
        if(tokenizer.isDigit(c)
            || c == '-'){
            visitor.onNumber(parseNumber(tokenizer));
            return;
        }
        throw ParseException(
            "Invalid value: expecting object, array, string, " +
                    "number, true, false, null but got `` c ``", 
            tokenizer.line, tokenizer.column);
    }

    void parseString() {
        visitor.onString(parseKeyOrString(tokenizer));
    }
    shared void parse() {
        parseValue();
        tokenizer.eatSpaces();
        if (tokenizer.hasMore) {
            throw ParseException("Unexpected extra characters", tokenizer.line, tokenizer.column);
        }
    }
}

"A parser for JSON data presented as a String which calls  
 the given visitor for each matched rule. 
 
 To construct a JSON model the visitor would be a [[Builder]]."
by("Stéphane Épardaud")
shared class StringParser("The string of JSON data to be parsed."
    String str,
Visitor visitor) extends Parser(StringTokenizer(str), visitor){
    
}

"Parses a JSON string into a JSON value"
by("Stéphane Épardaud")
throws(`class Exception`, "If the JSON string is invalid")
shared Value parse(String str) {
    value builder = Builder();
    value parser = StringParser(str, builder);
    parser.parse();
    return builder.result;
}
