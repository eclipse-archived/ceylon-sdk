import ceylon.collection {
    HashMap
}

"Localized information about the currency with the given 
 ISO 4217 currency [[code]]."
shared sealed class Currency(code, numericCode, 
        displayName, symbol,fractionalDigits) {
    
    "The ISO 4217 code for this currency, for example,
     `USD`, or `EUR`."
    shared String code;
    
    shared Integer fractionalDigits;
    
    "A localized symbol for this currency, for example, `$`,
     or \{EURO SIGN}."
    shared String symbol;
    
    "A localized displayable name for this currency, for 
     example, `dólar estadounidense`."
    shared String displayName;
    
    "ISO 4217 numeric code for this currency, for example,
     `840`, or `978`."
    shared String numericCode;
    
    string => code;
}

HashMap<String,Currency> parseCurrencies(Iterator<String> lines) {
    value currencies = HashMap<String,Currency>();
    while (!is Finished currencyLine = lines.next(), 
           !currencyLine.empty) {
        value langCols = columns(currencyLine).iterator();
        assert (is String code = langCols.next());
        assert (is String numericCode = langCols.next());
        assert (is String name = langCols.next());
        assert (is String symbol = langCols.next());
        assert (is String digits = langCols.next(), 
            exists fractionalDigits=parseInteger(digits));
        currencies[code]
            = Currency {
                code = code;
                numericCode = numericCode;
                displayName = name;
                symbol = symbol;
                fractionalDigits = fractionalDigits;
            };
    }
    return currencies;
}
    