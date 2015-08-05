import ceylon.time { ... }
import ceylon.time.base { ... }

shared object iso8601 {
    "Parses a string containing a Date values formatted in ISO 8601 format, returning the provided date.
    
     This will recognize dates formatted as `20141229` or `2014-12-29` both as 
     _December 29. 2014_.
    "
    shared ReadableDate parseDate(String input) => 
            let ([year, month, day, _] = ISO8601DateParser().parseDate(input))
            date(year, month, day);
}

class ISO8601DateParser() {
    
    shared [Integer, Integer, Integer, String] parseDate(String input) {
        assert(exists year  = parseInteger(input[0..3]));
        assert(exists month = parseInteger(input[4..5]));
        assert(exists day   = parseInteger(input[6..7]));
        return [year, month, day, input[8...]];
    }

}