"Contract for a tokenizer"
shared abstract class Tokenizer() {
    variable Integer index = 0;
    variable Integer line_ = 1;
    variable Integer column_ = 1;
    
    shared Integer position => index;
    
    shared Integer line => line_;
    shared Integer column => column_;
    
    "Whether there is another character"
    shared formal Boolean hasMore;
    
    "The character at the current index, or throw"
    shared formal Character char();
    
    shared void moveOne() {
        value c = char();
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
    
    shared void eatSpaces(){
        while(hasMore
            && isSpace(char())){
            moveOne();
        } 
    }
    
    shared void eatSpacesUntil(Character c){
        eatSpaces();
        eat(c);
    }
    
    shared Boolean check(Character c){
        if(char() != c){
            return false;
        }
        moveOne();
        return true;
    }
    
    shared void eat(Character c){
        if(char() != c){
            throw ParseException(
                "Expected `` c `` but got `` char()``", 
                line_, column_);
        }
        moveOne();
    }
    
    
    
    "The character at the current index, and move one"
    shared Character eatChar(){
        Character c = char();
        moveOne();
        return c;
    }
    
    shared Boolean isSpace(Character c)
            => c == ' ' 
            || c == '\n'
            || c == '\r'
            || c == '\t';
    
    shared Boolean isDigit(Character c){
        Integer codePoint = c.integer;
        return codePoint >= '0'.integer && 
                codePoint <= '9'.integer; 
    }
}

"An implementation of Tokenizer using a String"
shared class StringTokenizer(String chars) extends Tokenizer() {
    
    "Whether there is another character"
    shared actual Boolean hasMore => position < chars.size;
    
    "The character at the current index, or throw"
    shared actual Character char(){
        if(exists Character c = chars[position]){
            return c;
        }
        throw ParseException(
            "Unexpected end of string", 
            line, column);
    }
    
}


