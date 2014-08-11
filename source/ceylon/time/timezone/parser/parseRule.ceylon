"Parse current token using http://www.cstdbill.com/tzdb/tz-how-to.html 
 columns as reference"
shared [String, Rule] parseRuleLine(Iterator<String> token) {
    assert( is String name = token.next() );
    assert( is String startYearText = token.next() );
    assert( is String endYearText = token.next() );
    assert( is String typeText = token.next() );
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
            type = typeText.trimmed;
            month = parseMonth(monthText);
            onDay = DayRule(dayRuleText.trimmed);
            atTime = TimeRule(timeRuleText.trimmed);
            offset = toPeriod(parseTime(savingAmountsText.trimmed));
            letter = letterText.trimmed;
        }
    ];
}