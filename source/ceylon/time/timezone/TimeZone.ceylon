<<<<<<< Upstream, based on ceylon/master
import ceylon.time { Instant }
=======
import ceylon.time { DateTime, Instant }
>>>>>>> 026d7bd initial beginnings of TimeZone implementation
import ceylon.time.base { milliseconds }

"The interface representing a timezone"
shared interface TimeZone of OffsetTimeZone | RuleBasedTimezone {

    "Returns offset in milliseconds of the specified instant according to this time zone."
    shared formal Integer offset(Instant instant);

}

<<<<<<< Upstream, based on ceylon/master
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

shared object timeZone {

    shared object system extends OffsetTimeZone(process.timezoneOffset) {}

    shared object utc extends OffsetTimeZone(0) {}

    shared TimeZone|ParserError fromMinutes(Integer offset) {
        return OffsetTimeZone(offset * milliseconds.perMinute);
    }

    shared TimeZone|ParserError parse(String zone) {
        return parseTimeZone(zone);
    }
}
=======
shared TimeZone timeZone(Integer|String? zone = null) {
    if (exists zone) {
        if (is Integer offset = zone) {
            //TODO: Should we?
            return OffsetTimeZone(offset * milliseconds.perMinute);
        }
        if (is String zone) {
            return parseTimeZone(zone);
        }
    }
    
    return nothing;
}

"A simple time zone with a constant offset from UTC."
shared class OffsetTimeZone(shared Integer offsetMilliseconds) satisfies TimeZone {

    "Always returns a constant offset"
    shared actual Integer offset(Instant instant) => offsetMilliseconds;

}

interface RuleBasedTimezone satisfies TimeZone {
    //TODO: Implement complex rule based time zones
}
>>>>>>> 026d7bd initial beginnings of TimeZone implementation
