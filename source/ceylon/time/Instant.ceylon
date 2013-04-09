import ceylon.time.base { ReadableInstant }
import ceylon.time.chronology { unixTime }
import ceylon.time.internal { TimeOfDay, GregorianDateTime, GregorianDate }
import ceylon.time.timezone { TimeZone, ZoneDateTime }

"Obtains the current instant from the system clock."
shared Instant now(Clock? clock = null) {
    if (exists clock) {
        return clock.instant();
    }
    return systemTime.instant();
}

"A specific instant of time on a continuous time-scale.
 
 An instant represents a single point in time irrespective of 
 any time-zone offsets or geographical locations"
shared class Instant(millisecondsOfEra) 
    satisfies ReadableInstant & Comparable<Instant> {

    "Internal value of an instant as a number of milliseconds since 
     1970-01-01T00:00:00.000Z."
    shared actual Integer millisecondsOfEra;

    "Adds a period to this instant"
    shared Instant plus(Duration|Period other){
        switch(other)
        case(is Duration){
            return Instant(this.millisecondsOfEra + other.milliseconds);
        }
        case(is Period){
            return dateTime().plus(other).instant();
        }
    }

    "Subtracts a period to this instant"
    shared Instant minus(Duration|Period other){
        switch(other)
        case(is Duration){
            return Instant(this.millisecondsOfEra - other.milliseconds);
        }
        case(is Period){
            return dateTime().minus(other).instant();
        }
    }

    "Compares this instant to the _other_ instant"
    shared actual Comparison compare(Instant other) {
        return this.millisecondsOfEra <=> other.millisecondsOfEra;
    }

    "Returns this instant as a [[DateTime]] value."
    shared DateTime dateTime(
            "Time zone of the conversion.
             
             If omitted, the current/default time zone of the system will be used.
             
             **Note:** Since time zone support is not implemented yet, this method 
             will return dateTime according to the of the UTC instead of using local 
             time zone."
            TimeZone? zone = null) {
        if (exists zone) {
            //TODO: get [[DateTime]] for this [[Instant]] in the specified time zone. 
            return nothing;
        }
        
        return  GregorianDateTime( date(), time() );
    }

    "Returns this instant as a [[Date]] value"
    shared Date date(
            "Time zone of the conversion.
             
             If omitted the current/default time zone of the system will be used.
             
             **Note:** Since time zone support is not implemented yet, this method 
             will return date according to the of the UTC instead of using local 
             time zone."
            TimeZone? zone = null) {
        if (exists zone) {
            //TODO: get [[Date]] of this [[Instant]] in the specified time zone.
            return nothing;
        }

        return GregorianDate(unixTime.fixedFromTime(millisecondsOfEra));
    }

    "Returns _time of day_ for this instant"
    shared Time time(
            "Time zone of the conversion.
             
             If omitted the current/default time zone of the system will be used.
             
             **Note:** Since time zone support is not implemented yet, this method 
             will return time of day according to the of the UTC-0 instead of using local 
             time zone."
            TimeZone? zone = null) {
        if (exists zone) {
            //TODO: get [[Time]] of this [[Instant]] in the specified time zone.
            return nothing;
        }
        return TimeOfDay( unixTime.timeOfDay(millisecondsOfEra) );
    }

    "Returns ZoneDateTime value for this instant."
    shared ZoneDateTime zoneDateTime(TimeZone zone){
        //TODO: get [[Time]] of this [[Instant]] in the specified time zone.
        return nothing;
    }

    "Returns duration in milliseconds from this instant to the other instant."
    shared Duration durationTo(Instant other) {
        return Duration(other.millisecondsOfEra - this.millisecondsOfEra);
    }
    
    "Returns duration in milliseconds from other instant to this instant."
    shared Duration durationFrom(Instant other) {
        return Duration(this.millisecondsOfEra - other.millisecondsOfEra);
    }

}
