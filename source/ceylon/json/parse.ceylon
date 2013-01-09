class Parser(String str){
    Character[] chars = str.characters;
    variable Integer index = 0;

    shared Object parseObject(){
        Object obj = Object();
        
        eatSpacesUntil(`{`);
        eatSpaces();
        if(!check(`}`)){
            while(true){
                String key = parseString();
                eatSpacesUntil(`:`);
                String|Boolean|Integer|Float|Object|Array|NullInstance val = parseValue();
                obj.put(key, val);
                
                eatSpaces();
                if(check(`}`)){
                    break;
                }
                if(!check(`,`)){
                    throw Exception("Expected '}' or ',' but got " char().string "");
                }
            }
        }
        return obj;
    }

    Array parseArray(){
        Array arr = Array();
        
        eatSpacesUntil(`[`);
        eatSpaces();
        if(!check(`]`)){
            while(true){
                String|Boolean|Integer|Float|Object|Array|NullInstance val = parseValue();
                arr.add(val);

                eatSpaces();
                if(check(`]`)){
                    break;
                }
                if(!check(`,`)){
                    throw Exception("Expected ']' or ',' but got " char().string "");
                }
            }
        }
        return arr;
    }
    
    String|Boolean|Integer|Float|Object|Array|NullInstance parseValue(){
        eatSpaces();
        Character c = char();
        if(c == `{`){
            return parseObject();
        }
        if(c == `[`){
            return parseArray();
        }
        if(c == `"`){
            return parseString();
        }
        if(c == `t`){
            return parseTrue();
        }
        if(c == `f`){
            return parseFalse();
        }
        if(c == `n`){
            return parseNull();
        }
        if(isDigit(c)
            || c == `-`){
            return parseNumber();
        }
        throw Exception("Invalid value: expecting object, array, string, number, true, false, null but got " c.string "");
    }
    
    Integer|Float parseNumber(){
        eatSpaces();
        Boolean negative = check(`-`);
        Integer wholePart = parseDigits();
        
        if(check(`.`)){
            Integer start = index;
            Integer fractionPart = parseDigits();
            Integer digits = index - start;
            Float float = wholePart.float + (fractionPart.float / (10 ** digits).float);
            Float signedFloat = negative then float.negativeValue else float;
            Integer? exp = parseExponent();
            if(exists exp){
                return signedFloat * (10.float ** exp.float);
            }
            return signedFloat;
        }

        Integer signedInteger = negative then wholePart.negativeValue else wholePart;
        Integer? exp = parseExponent();
        if(exists exp){
            return signedInteger.float * (10.float ** exp.float);
        }
        return signedInteger;
    }

    Integer? parseExponent(){
        if(check(`e`)
            || check(`E`)){
            Boolean negativeExponent;
            if(check(`-`)){
                negativeExponent = true;
            }else if(check(`+`)){
                negativeExponent = false;
            }else{
                negativeExponent = false;
            }
            Integer exponentPart = parseDigits();
            return negativeExponent then -exponentPart else exponentPart;
        }
        return null;
    }
        
    Integer parseDigits(){
        Character c = eatChar();
        if(!isDigit(c)){
            throw Exception("Expected digit, got: " c.string "");
        }
        variable Integer digits = parseDigit(c);
        while(isDigit(char())){
            digits *= 10;
            digits += parseDigit(eatChar());
        }
        return digits;
    }
    
    Integer parseDigit(Character c){
        return c.integer - `0`.integer;
    }
    
    Boolean parseTrue(){
        eatSpacesUntil(`t`);
        eat(`r`);
        eat(`u`);
        eat(`e`);
        return true;
    }

    Boolean parseFalse(){
        eatSpacesUntil(`f`);
        eat(`a`);
        eat(`l`);
        eat(`s`);
        eat(`e`);
        return false;
    }

    NullInstance parseNull(){
        eatSpacesUntil(`n`);
        eat(`u`);
        eat(`l`);
        eat(`l`);
        return nil;
    }
    
    String parseString(){
        eatSpacesUntil(`"`);
        StringBuilder buf = StringBuilder();
        while(!check(`"`)){
            Character c = eatChar();
            if(c == `\\`){
                buf.append(parseStringEscape().string);
            }else{
                buf.append(c.string);
            }
        }
        return buf.string;
    }
    
    Character parseStringEscape(){
        Character c = eatChar();
        if(c == `"`
            || c == `\\`
            || c == `/`){
            return c;
        }
        if(c == `b`){
            return `\b`;
        }
        if(c == `f`){
            return `\f`;
        }
        if(c == `r`){
            return `\r`;
        }
        if(c == `n`){
            return `\n`;
        }
        if(c == `t`){
            return `\t`;
        }
        if(c == `u`){
            return parseStringUnicode();
        }
        throw Exception("Expected String escape sequence, got " c " TERM ");
    }
    
    Character parseStringUnicode(){
        Integer codePoint = 
            parseHex() * 16 ** 3
            + parseHex() * 16 ** 2
            + parseHex() * 16
            + parseHex();
        return codePoint.character;
    }
    
    Integer parseHex(){
        Character c = eatChar();
        Integer codePoint = c.integer;
        if(codePoint >= `0`.integer && codePoint <= `9`.integer){
            return codePoint - `0`.integer;
        }
        if(codePoint >= `a`.integer && codePoint <= `f`.integer){
            return 10 + codePoint - `a`.integer;
        }
        if(codePoint >= `A`.integer && codePoint <= `F`.integer){
            return 10 + codePoint - `A`.integer;
        }
        throw Exception("Expecting hex number, got " c.string "");
    }
    
    void eatSpaces(){
        while(index < chars.size
            && isSpace(char())){
            index++;
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
        index++;
        return true;
    }
    
    void eat(Character c){
        if(char() != c){
            throw Exception("Expected " c.string " but got " char().string "");
        }
        index++;
    }
    
    Character char(){
        if(exists Character c = chars[index]){
            return c;
        }
        throw Exception("Unexpected end of string");
    }
    
    Character eatChar(){
        Character c = char();
        index++;
        return c;
    }
    
    Boolean isSpace(Character c){
        return c == ` ` 
            || c == `\n`
            || c == `\r`
            || c == `\t`;
    }

    Boolean isDigit(Character c){
        Integer codePoint = c.integer;
        return codePoint >= `0`.integer && codePoint <= `9`.integer; 
    }
}

by "Stéphane Épardaud"
doc "Parses a JSON string into a JSON Object"
throws(Exception, "If the JSON string is invalid")
shared Object parse(String str){
    return Parser(str).parseObject();
}