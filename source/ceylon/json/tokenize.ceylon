/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
"Contract for stateful iterators, tokenizers etc which have the concept of a 'current position'."
shared interface Positioned {
    "The position (in characters) within the input."
    shared formal Integer position;
    
    "The line number within the input."
    shared formal Integer line;
    
    "The column number within the current line."
    shared formal Integer column;
    
    "A string descriptor of the current position."
    shared String location => "``line``:``column`` (line:column)";
}


"Contract for a tokenizer"
shared abstract class Tokenizer() 
        satisfies Positioned {
    variable Integer index = 0;
    variable Integer line_ = 1;
    variable Integer column_ = 1;
    
    shared actual Integer position => index;
    
    shared actual Integer line => line_;
    
    shared actual Integer column => column_;
    
    "Whether there is another character"
    shared formal Boolean hasMore;
    
    "The character at the current index, or throw"
    shared formal Character character();
    
    "Move to the next character"
    shared void moveOne() {
        value c = character();
        switch(c)
        case('\n'){
            line_++;
            column_ = 1;
        }
        case('\r'){
            column_ = 1;
        }
        else {
            column_++;
        }
        index++;
    }
    
    "Consume characters until the first non-whitespace"
    shared void eatSpaces(){
        while(hasMore
            && isSpace(character())){
            moveOne();
        } 
    }
    
    "Consume characters until the given character occurs"
    shared void eatSpacesUntil(Character c){
        eatSpaces();
        eat(c);
    }
    
    "If the current [[character]] is not the given character then return false. 
     Otherwise [[moveOne]] and return true."
    shared Boolean check(Character c){
        if(character() != c){
            return false;
        }
        moveOne();
        return true;
    }
    
    "If the current character is not the given character then throw, 
     otherwise [[moveOne]]"
    shared void eat(Character c){
        if(character() != c){
            throw unexpectedCharacter(c);
        }
        moveOne();
    }
    
    "The character at the current index, and move one"
    shared Character eatChar(){
        Character c = character();
        moveOne();
        return c;
    }
    
    """true if the given character is a space, 
       newline (`\n`), carriage return (`\r`) or a horizontal tab (`\t`).
       """
    shared Boolean isSpace(Character c)
            => c == ' ' 
            || c == '\n'
            || c == '\r'
            || c == '\t';
    
    "true if the given character is 
     `0`, `1`, `2`, `3`, `4`, `5`, `6`, `7`, `8` or `9`."
    shared Boolean isDigit(Character c){
        Integer codePoint = c.integer;
        return codePoint >= '0'.integer && 
                codePoint <= '9'.integer; 
    }
    
    shared ParseException exception(String message) 
        => ParseException(message, line, column);
    
    shared ParseException unexpectedEnd=>
            exception(
        "Unexpected end of input");
    
    shared ParseException unexpectedCharacter(Character|String? expected) => exception(
        "Expected `` expected else "end of input" `` but got `` character()``");
}

"An implementation of Tokenizer using a String"
shared class StringTokenizer(String chars) extends Tokenizer() {
    variable value count = -1;
    value size = chars.size;
    value it = chars.iterator();
    variable Character|Finished? char = null;
    
    "Whether there is another character"
    shared actual Boolean hasMore => position < size;
    
    "The character at the current index, or throw"
    shared actual Character character() {
        while(count < position) {
            value c = it.next();
            if(is Finished c){
                throw unexpectedEnd;
            }
            count++;
            char = c;
        }
        
        assert(is Character last = char);
        return last;
    }
}


