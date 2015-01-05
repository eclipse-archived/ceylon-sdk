import ceylon.time.timezone.parser.iana {
    parseTime
}
import ceylon.time.timezone.model {
    ZoneTimeline
}

shared alias ZoneName => String;

shared [ZoneName, ZoneTimeline] parseZoneLine(String line, ZoneName? zoneName = null) {
    value token = line.split(tokenDelimiter).iterator();
    
    ZoneName name;
    if(exists zoneName) {
        name = zoneName;
    } else {
        assert(is String zone = token.next(), zone == "Zone");
        assert(is ZoneName nameText = token.next());
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