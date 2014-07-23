shared sealed class Formats(
    shortDateFormat, 
    mediumDateFormat, 
    longDateFormat, 
    shortTimeFormat, 
    mediumTimeFormat, 
    longTimeFormat, 
    integerFormat, 
    floatFormat, 
    percentageFormat, 
    currencyFormat) {
    
    shared String shortDateFormat;
    shared String mediumDateFormat;
    shared String longDateFormat;
    
    shared String shortTimeFormat;
    shared String mediumTimeFormat;
    shared String longTimeFormat;
    
    shared String integerFormat;
    shared String floatFormat;
    shared String percentageFormat;
    shared String currencyFormat;
    
}

Formats parseFormats(Iterator<String> lines) {
    
    assert (!is Finished dateFormats = lines.next());
    value dateCols = columns(dateFormats);
    assert (is String shortDateFormat = dateCols.next());
    assert (is String mediumDateFormat = dateCols.next());
    assert (is String longDateFormat = dateCols.next());
    assert (!is Finished timeFormats = lines.next());
    
    value timeCols = columns(timeFormats);
    assert (is String shortTimeFormat = timeCols.next());
    assert (is String mediumTimeFormat = timeCols.next());
    assert (is String longTimeFormat = timeCols.next());
    assert (!is Finished numberFormats = lines.next());
    
    value numCols = columns(numberFormats);
    assert (is String integerFormat = numCols.next());
    assert (is String floatFormat = numCols.next());
    assert (is String percentageFormat = numCols.next());
    assert (is String currencyFormat = numCols.next());
    
    assert (!is Finished blankLine1 = lines.next(), blankLine1.empty);
    
    return Formats {
        shortDateFormat = shortDateFormat;
        mediumDateFormat = mediumDateFormat;
        longDateFormat = longDateFormat;
        shortTimeFormat = shortTimeFormat;
        mediumTimeFormat = mediumTimeFormat;
        longTimeFormat = longTimeFormat;
        integerFormat = integerFormat;
        floatFormat = floatFormat;
        percentageFormat = percentageFormat;
        currencyFormat = currencyFormat;
    };
}