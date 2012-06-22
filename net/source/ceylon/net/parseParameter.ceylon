doc "Parses a raw percent-encoded path parameter"
shared Parameter parseParameter(String part){
    Integer? sep = part.firstCharacterOccurrence(`=`);
    if(exists sep){
        return Parameter(decodePercentEncoded(part.initial(sep)), 
            decodePercentEncoded(part.terminal(part.size - sep - 1)));
    }else{
        return Parameter(decodePercentEncoded(part));
    }
}