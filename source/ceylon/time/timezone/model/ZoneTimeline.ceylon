import ceylon.time {
    Period
}

shared class ZoneTimeline(offset, rule, format, until) {
    shared Period offset;
    shared ZoneRule rule;
    shared ZoneFormat format;
    shared ZoneUntil until;
    
    shared actual Boolean equals(Object other) {
        if(is ZoneTimeline other) {
            return offset == other.offset
                    && rule == other.rule
                    && format == other.format
                    && until == other.until;
        }
        return false;
    }
    
}