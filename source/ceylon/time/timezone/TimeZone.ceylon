import ceylon.time { Instant }
import ceylon.time.base { ms = milliseconds }

"The interface representing a timezone."
shared interface TimeZone of OffsetTimeZone | RuleBasedTimezone {

    "Returns offset in milliseconds of the specified instant according to this time zone."
    shared formal Integer offset(Instant instant);

}

"A simple time zone with a constant offset from UTC."
shared class OffsetTimeZone(offsetMilliseconds) satisfies TimeZone {

    "The value that represents this constant offset."
    Integer offsetMilliseconds;

    "Always returns a constant offset."
    shared actual Integer offset(Instant instant) => offsetMilliseconds;

    "Returns _true_ if given value is same type and offset milliseconds."
    shared actual Boolean equals( Object other ) {
        if ( is OffsetTimeZone other ) {
            return this.offsetMilliseconds == other.offsetMilliseconds;
        }
        return false;
    }

    "This implementation respect the constraint that if `x==y` then `x.hash==y.hash`."
    shared actual Integer hash {
        value prime = 31;
        value result = 11;
        return prime * result + (offsetMilliseconds.xor((offsetMilliseconds.rightLogicalShift(32))));
    }

}

"This represents offsets based on daylight saving time."
shared interface RuleBasedTimezone satisfies TimeZone {
    //TODO: Implement complex rule based time zones
}

"This constant represents common operations for time zone.
 
 At same time it hold objects references for most commons used time zones around world.
 
 Examples:
 * UTC
 * System (current machine offset)"
shared object timeZone {

    "Represents machine offset based on current VM."
    shared object system extends OffsetTimeZone(process.timezoneOffset) {}

    "Represents Coordinated Universal Time."
    shared object utc extends OffsetTimeZone(0) {}

    "Timezone offset parser based on ISO-8601, currently it accepts the following time zone offset patterns:
     &plusmn;`[hh]:[mm]`, &plusmn;`[hh][mm]`, and &plusmn;`[hh]`.
 
     In addition, the special code `Z` is recognized as a shorthand for `+00:00`."
    shared TimeZone|ParserError parse(String zone) {
        return parseTimeZone(zone);
    }

    "Represents fixed timeZone created based on given values."
    shared TimeZone offset(Integer hours, Integer minutes = 0, Integer milliseconds = 0) {
        return OffsetTimeZone(hours * ms.perHour + minutes * ms.perMinute + milliseconds);
    }

}
