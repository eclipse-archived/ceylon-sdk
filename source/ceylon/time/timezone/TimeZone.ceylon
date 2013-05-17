import ceylon.time { Instant }
import ceylon.time.base { milliseconds }

"The interface representing a timezone"
shared interface TimeZone of OffsetTimeZone | RuleBasedTimezone {

    "Returns offset in milliseconds of the specified instant according to this time zone."
    shared formal Integer offset(Instant instant);

}

shared TimeZone timeZone(Integer minutes) {
    return OffsetTimeZone(minutes * milliseconds.perMinute);
}

"A simple time zone with a constant offset from UTC."
shared class OffsetTimeZone(offsetMilliseconds) satisfies TimeZone {

    "The value that represents this constant offset"
    Integer offsetMilliseconds;

    "Always returns a constant offset"
    shared actual Integer offset(Instant instant) => offsetMilliseconds;

    shared actual Boolean equals( Object other ) {
        if ( is OffsetTimeZone other ) {
            return this.offsetMilliseconds == other.offsetMilliseconds;
        }
        return false;
    }

}

interface RuleBasedTimezone satisfies TimeZone {
    //TODO: Implement complex rule based time zones
}

//TODO: Waiting for some decision about how to handle it
shared object systemZone extends OffsetTimeZone(-4 * milliseconds.perHour) {
}

//TODO: Waiting for some decision about how to handle it
shared object utcZone extends OffsetTimeZone(0) {
}
