import ceylon.time.timezone.model {
    Year,
    Rule
}
"Parse current token using http://www.cstdbill.com/tzdb/tz-how-to.html 
 columns as reference"
shared [String, Rule] parseRuleLine(String line) {
    
    value token = line.split(tokenDelimiter).iterator();
    
    assert( is String rule = token.next(), rule == "Rule" );
    
    assert( is String name = token.next() );
    assert( is String startYearText = token.next() );
    assert( is String endYearText = token.next() );
    assert( is String typeText = token.next() ); //just to discard
    assert( is String monthText = token.next() );
    assert( is String dayRuleText = token.next() );
    assert( is String timeRuleText = token.next() );
    assert( is String savingAmountsText = token.next() );
    assert( is String letterText = token.next() );
    
    Year year = parseYear(startYearText, 0);
    return
    [     name,
    Rule{
        fromYear = year;
        toYear = parseYear(endYearText, year);
        inMonth = parseMonth(monthText);
        onDay = parseOnDay(dayRuleText.trimmed);
        atTime = parseAtTime(timeRuleText.trimmed);
        save = toPeriod(parseTime(savingAmountsText.trimmed));
        letter = letterText.trimmed;
    }
    ];
}
