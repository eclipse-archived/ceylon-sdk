import ceylon.time.timezone {
    TimeZone,
    OffsetTimeZone,
    timeZone
}
import ceylon.time.base {
    milliseconds
}

"Timezone offset parser based on ISO-8601, currently it accepts the following 
 time zone offset patterns:
 
 - &plusmn;`[hh]:[mm]`,
 - &plusmn;`[hh][mm]`, and 
 - &plusmn;`[hh]`.
 
 In addition, the special code `Z` is recognized as a shorthand for `+00:00`"
shared TimeZone? parseTimeZone( String offset ) {
    if(offset.equalsIgnoringCase("Z")) {
        return timeZone.utc;
    }
    
    value signal = offset.startsWith("+")
            then 1 
            else (offset.startsWith("-") 
                then -1
                else null);

    value offsetWithoutSignal = offset.spanFrom(1);
    Integer? hours;
    Integer? minutes;
    if(exists signal) {
        
        switch (offsetWithoutSignal.size)
        case(5) {
            hours = parseInteger(offsetWithoutSignal.spanTo(1));
            minutes = parseInteger(offsetWithoutSignal.spanFrom(3));
        }
        case(4) {
            hours = parseInteger(offsetWithoutSignal.spanTo(1));
            minutes = parseInteger(offsetWithoutSignal.spanFrom(2));
        }
        case(2) {
            hours = parseInteger(offsetWithoutSignal);
            minutes = 0;
        }
        else {
            hours = null;
            minutes = null;
        }
        
        if( exists hours, exists minutes ) {
            if( signal == -1 && hours == 0 && minutes == 0) {
                return null;
            }
            else {
                return OffsetTimeZone(
                    signal * 
                         (hours * milliseconds.perHour
                        + minutes * milliseconds.perMinute)
                );
            }
        }        
    }
    
    return null;
}
