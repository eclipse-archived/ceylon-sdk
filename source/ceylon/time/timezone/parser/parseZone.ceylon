import ceylon.time.timezone.parser {
    parseTime
}
import ceylon.time.timezone.model {
    ZoneTimeline
}

shared [String, ZoneTimeline] parseZoneLine(String line, String? ruleName = null) {
    value token = line.split(tokenDelimiter).iterator();
    
    String name;
    if(exists ruleName) {
        name = ruleName;
    } else {
        assert(is String zone = token.next(), zone == "Zone");
        assert(is String nameText = token.next());
        name = nameText;
    }
    
    assert(is String offsetText = token.next());
    assert(is String ruleText = token.next());
    assert(is String formatText     = token.next());
    variable [String*] untilTokens = [];
    while(is String t = token.next() ) {
        untilTokens = [t, *untilTokens];
    }
    
    return [
        name,
        ZoneTimeline {
            offset = toPeriod(parseTime(offsetText.trimmed));
            rule = parseZoneRule(ruleText.trimmed);
            format = parseZoneFormat(formatText.trimmed);
            until = parseUntil(untilTokens.reversed);
        }
    ];
}