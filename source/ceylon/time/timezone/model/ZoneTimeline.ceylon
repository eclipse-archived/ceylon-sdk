import ceylon.time {
    Period
}

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