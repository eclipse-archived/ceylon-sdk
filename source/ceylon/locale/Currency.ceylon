/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
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

        "missing currency code"
        assert (is String code = langCols.next());
        "missing currency numeric code for ``code``"
        assert (is String numericCode = langCols.next());
        "missing currency name for ``code``"
        assert (is String name = langCols.next());
        "missing currency symbol for ``code``"
        assert (is String symbol = langCols.next());
        "missing currency fractional digits for ``code``"
        assert (is String digits = langCols.next(), 
            is Integer fractionalDigits = Integer.parse(digits));

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
    