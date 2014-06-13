class Parser(String str){
    
    Character[] chars = str.sequence();
    variable Integer index = 0;
    variable Integer line = 1;
    variable Integer column = 1;

    Object parseObject(){
        Object obj = Object{};
        
        eatSpacesUntil('{');
        eatSpaces();
        if(!check('}')){
            while(true){
                String key = parseString();
                eatSpacesUntil(':');
                obj.put(key, parseValue());
                
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
        return obj;
    }

    Array parseArray(){
        Array arr = Array{};
        
        eatSpacesUntil('[');
        eatSpaces();
        if(!check(']')){
            while(true){
                arr.add(parseValue());

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
        return arr;
    }
    
    throws(`class ParseException`, 
        "If the specified string cannot be parsed")
    shared Value parseValue(){
        eatSpaces();
        Character c = char();
        if(c == '{'){
            return parseObject();
        }
        if(c == '['){
            return parseArray();
        }
        if(c == '"'){
            return parseString();
        }
        if(c == 't'){
            return parseTrue();
        }
        if(c == 'f'){
            return parseFalse();
        }
        if(c == 'n'){
            return parseNull();
        }
        if(isDigit(c)
            || c == '-'){
            return parseNumber();
        }
        throw ParseException(
            "Invalid value: expecting object, array, string, " +
            "number, true, false, null but got `` c ``", 
            line, column);
    }
    
    Integer|Float parseNumber(){
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
            Integer? exp = parseExponent();
            if(exists exp){
                return signedFloat * (10.float ^ exp.float);
            }
            return signedFloat;
        }

        Integer signedInteger = 
                negative then -wholePart else wholePart;
        Integer? exp = parseExponent();
        if(exists exp){
            return signedInteger.float * (10.float ^ exp.float);
        }
        return signedInteger;
    }

    Integer? parseExponent(){
        if(check('e')
            || check('E')){
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
        while(isDigit(char())){
            digits *= 10;
            digits += parseDigit(eatChar());
        }
        return digits;
    }
    
    Boolean parseTrue(){
        eatSpacesUntil('t');
        eat('r');
        eat('u');
        eat('e');
        return true;
    }

    Boolean parseFalse(){
        eatSpacesUntil('f');
        eat('a');
        eat('l');
        eat('s');
        eat('e');
        return false;
    }

    NullInstance parseNull(){
        eatSpacesUntil('n');
        eat('u');
        eat('l');
        eat('l');
        return nil;
    }
    
    String parseString(){
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
    
    void eatSpaces(){
        while(index < chars.size
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
    
    Character char(){
        if(exists Character c = chars[index]){
            return c;
        }
        throw ParseException(
            "Unexpected end of string", 
            line, column);
    }
    
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
}

"Parses a JSON string into a JSON value"
by("Stéphane Épardaud")
throws(`class Exception`, "If the JSON string is invalid")
shared Value parse(String str) => Parser(str).parseValue();
