import ceylon.time {
    Instant
}

shared class ZoneUntil(instant, ruleDefinition) {
    shared Instant instant;
    shared AtTimeDefinition ruleDefinition;
    
    shared actual Boolean equals(Object other) {
        if(is ZoneUntil other) {
            return         instant == other.instant
                   &&   ruleDefinition == other.ruleDefinition;
        }
        return false;
    }
}