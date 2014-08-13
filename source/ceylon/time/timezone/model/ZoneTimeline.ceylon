import ceylon.time {
    Period
}

"
 
 All the models are intended to be unrelated of the database origin.
 
 P.S.: Its not intended to be used outside of ceylon.time and currently
 its as shared because we need to test it."
shared class ZoneTimeline(offset, zoneRule, format, until) {
    shared Period offset;
    shared ZoneRule zoneRule;
    shared ZoneFormat format;
    shared ZoneUntil until;
    
    shared actual Boolean equals(Object other) {
        if(is ZoneTimeline other) {
            return offset == other.offset
                && zoneRule == other.zoneRule
                && format == other.format
                && until == other.until;
        }
        return false;
    }
    
}