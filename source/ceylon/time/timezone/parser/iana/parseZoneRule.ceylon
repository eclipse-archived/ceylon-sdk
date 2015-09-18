import ceylon.time.timezone.model {
    PeriodZoneRule,
    ZoneRule,
    standardZoneRule
}

shared ZoneRule parseZoneRule(String token) {
    if(token == "-") {
        return standardZoneRule;
    }
    
    value indexes = "".indexesWhere(':'.equals).sequence();
    if(nonempty indexes) {
        return PeriodZoneRule(toPeriod(parseTime(token)));
    } else {
        return standardZoneRule;
    }
}