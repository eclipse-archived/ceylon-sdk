import ceylon.time.timezone {
    TimeZone,
    OffsetTimeZone
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
    value signal = offset.startsWith("+") || offset.equalsIgnoringCase("Z")
            then 1 
            else (offset.startsWith("-") 
                then -1
                else null);
    value offsetWithoutSignal = offset.spanFrom(1);
    Integer? hours;
    Integer? minutes;
    if( exists signal, exists index = offsetWithoutSignal.firstIndexWhere(':'.equals), offsetWithoutSignal.size == 5 ) {
        value composed = offsetWithoutSignal.split{
            ':'.equals;
            discardSeparators = true;
        }.sequence();
        
        hours = parseInteger(composed[0] else "");
        minutes = parseInteger(composed[1] else "");
    }
    else if( exists signal, !offsetWithoutSignal.firstIndexWhere(':'.equals) exists, offsetWithoutSignal.size == 4 ) {
        hours = parseInteger(offsetWithoutSignal.spanTo(1));
        minutes = parseInteger(offsetWithoutSignal.spanFrom(2));
    }
    else if( exists signal, offsetWithoutSignal.size == 2 ) {
        hours = parseInteger(offsetWithoutSignal.string);
        minutes = 0;
    }
    else if( offset.equalsIgnoringCase("Z") ) {
        hours = 0;
        minutes = 0;
    }
    else {
        hours = null;
        minutes = null;
    }
    
    if( exists signal, exists hours, exists minutes ) {
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
    
    return null;
}
