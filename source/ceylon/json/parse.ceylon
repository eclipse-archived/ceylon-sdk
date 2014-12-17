"A parser for JSON data presented as a String which calls  
 the given visitor for each matched rule. 
 
 To construct a JSON model the visitor would be a [[Builder]]."
by("Stéphane Épardaud")
shared class StringParser(str, visitor) {
    
    "The string of JSON data to be parsed."
    String str;
    
    "The visitor to called for each matched rule."
    shared Visitor visitor;
    
    Character[] chars = str.sequence();
    variable Integer index = 0;
    variable Integer line = 1;
    variable Integer column = 1;
    
    void parseObject(){
        visitor.onStartObject();
        eatSpacesUntil('{');
        eatSpaces();
        if(!check('}')){
            
            while(true){
                String key = parseKeyOrString();
                eatSpacesUntil(':');
                visitor.onKey(key);
                parseValue();
                
                eatSpaces();
                if(check('}')){
                    break;
                }
                if(!check(',')){
                    throw ParseException(
                        "Expected '}' or ',' but got `` char() ``", 
                        line, column);
                }
            }
        }
        visitor.onEndObject();
    }
    
    void parseArray(){
        visitor.onStartArray();
        eatSpacesUntil('[');
        eatSpaces();
        if(!check(']')){
            while(true){
                parseValue();
                
                eatSpaces();
                if(check(']')){
                    break;
                }
                if(!check(',')){
                    throw ParseException(
                        "Expected ']' or ',' but got `` char() ``", 
                        line, column);
                }
            }
        }
        visitor.onEndArray();
    }
    
    throws(`class ParseException`, 
        "If the specified string cannot be parsed")
    shared void parseValue(){
        eatSpaces();
        Character c = char();
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
            parseTrue();
            return;
        }
        if(c == 'f'){
            parseFalse();
            return;
        }
        if(c == 'n'){
            parseNull();
            return;
        }
        if(isDigit(c)
            || c == '-'){
            parseNumber();
            return;
        }
        throw ParseException(
            "Invalid value: expecting object, array, string, " +
                    "number, true, false, null but got `` c ``", 
            line, column);
    }
    
    void parseNumber(){
        eatSpaces();
        Boolean negative = check('-');
        Integer wholePart = parseDigits();
        
        if(check('.')){
            Integer start = index;
            Integer fractionPart = parseDigits();
            Integer digits = index - start;
            Float float = wholePart.float + 
                    (fractionPart.float / (10 ^ digits).float);
            Float signedFloat = negative then -float else float;
            Integer? exp1 = parseExponent();
            if(exists exp1){
                visitor.onNumber(signedFloat * (10.float ^ exp1.float));
                return;
            }
            visitor.onNumber(signedFloat);
            return;
        }
        
        Integer signedInteger = 
                negative then -wholePart else wholePart;
        Integer? exp2 = parseExponent();
        if(exists exp2){
            visitor.onNumber(signedInteger.float * (10.float ^ exp2.float));
            return;
        }
        visitor.onNumber(signedInteger);
        return;
    }
    
    Integer? parseExponent(){
        if(hasMore && (check('e')
            || check('E'))) {
            Boolean negativeExponent;
            if(check('-')){
                negativeExponent = true;
            }else if(check('+')){
                negativeExponent = false;
            }else{
                negativeExponent = false;
            }
            Integer exponentPart = parseDigits();
            return negativeExponent 
            then -exponentPart 
            else exponentPart;
        }
        return null;
    }
    
    function parseDigit(Character c)
            => c.integer - '0'.integer;
    
    Integer parseDigits(){
        Character c = eatChar();
        if(!isDigit(c)){
            throw ParseException(
                "Expected digit, got: `` c ``", 
                line, column);
        }
        variable Integer digits = parseDigit(c);
        while(hasMore && isDigit(char())){
            digits *= 10;
            digits += parseDigit(eatChar());
        }
        return digits;
    }
    
    void parseTrue(){
        eatSpacesUntil('t');
        eat('r');
        eat('u');
        eat('e');
        visitor.onBoolean(true);
    }
    
    void parseFalse(){
        eatSpacesUntil('f');
        eat('a');
        eat('l');
        eat('s');
        eat('e');
        visitor.onBoolean(false);
    }
    
    void parseNull(){
        eatSpacesUntil('n');
        eat('u');
        eat('l');
        eat('l');
        visitor.onNull();
    }
    
    String parseKeyOrString(){
        eatSpacesUntil('"');
        StringBuilder buf = StringBuilder();
        while(!check('"')){
            Character c = eatChar();
            if(c == '\\'){
                buf.append(parseStringEscape().string);
            }else{
                buf.append(c.string);
            }
        }
        return buf.string;
    }
    void parseString() {
        visitor.onString(parseKeyOrString());
    }
    
    Character parseStringEscape(){
        Character c = eatChar();
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
            return parseStringUnicode();
        }
        throw ParseException(
            "Expected String escape sequence, got `` c `` TERM ", 
            line, column);
    }
    
    Character parseStringUnicode(){
        Integer codePoint = 
                parseHex() * 16 ^ 3
                + parseHex() * 16 ^ 2
                + parseHex() * 16
                + parseHex();
        return codePoint.character;
    }
    
    Integer parseHex(){
        Character c = eatChar();
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
            line, column);
    }
    
    "Whether there is another character"
    Boolean hasMore => index < chars.size;
    
    void eatSpaces(){
        while(hasMore
            && isSpace(char())){
            moveOne();
        } 
    }
    
    void eatSpacesUntil(Character c){
        eatSpaces();
        eat(c);
    }
    
    Boolean check(Character c){
        if(char() != c){
            return false;
        }
        moveOne();
        return true;
    }
    
    void eat(Character c){
        if(char() != c){
            throw ParseException(
                "Expected `` c `` but got `` char()``", 
                line, column);
        }
        moveOne();
    }
    
    "The character at the current index, or throw"
    Character char(){
        if(exists Character c = chars[index]){
            return c;
        }
        throw ParseException(
            "Unexpected end of string", 
            line, column);
    }
    
    "The character at the current index, and move one"
    Character eatChar(){
        Character c = char();
        moveOne();
        return c;
    }
    
    Boolean isSpace(Character c)
            => c == ' ' 
            || c == '\n'
            || c == '\r'
            || c == '\t';
    
    void moveOne() {
        value c = char();
        switch(c)
        case('\n'){
            line++;
            column = 1;
        }
        case('\r'){
            column = 1;
        }
        else {
            column++;
        }
        index++;
    }
    
    Boolean isDigit(Character c){
        Integer codePoint = c.integer;
        return codePoint >= '0'.integer && 
                codePoint <= '9'.integer; 
    }
    shared void parse() {
        value result = parseValue();
        eatSpaces();
        if (hasMore) {
            throw ParseException("Unexpected extra characters", line, column);
        }
    }
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
