import ceylon.time.timezone.parser {
    parseTime
}
import ceylon.time.timezone.model {
    ZoneTimeline
}

shared [String, ZoneTimeline] parseZoneLine(Iterator<String> token, String? ruleName = null) {
    String name;
    if(exists ruleName) {
        name = ruleName;
    } else {
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
            zoneRule = parseZoneRule(ruleText.trimmed);
            format = parseZoneFormat(formatText.trimmed);
            until = parseUntil(untilTokens.reversed);
        }
    ];
}
