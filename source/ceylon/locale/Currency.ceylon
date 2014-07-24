import ceylon.collection {
    HashMap
}

shared sealed class Currency(String code, 
    shared String numericCode, 
    shared String displayName, 
    shared String symbol,
    shared Integer fractionalDigits) {
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
        currencies.put(code,
            Currency {
                code = code;
                numericCode = numericCode;
                displayName = name;
                symbol = symbol;
                fractionalDigits = fractionalDigits;
            });
    }
    return currencies;
}
    