import ceylon.time {
    Instant
}

"
 
 All the models are intended to be unrelated of the database origin.
 
 P.S.: Its not intended to be used outside of ceylon.time and currently
 its as shared because we need to test it."
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