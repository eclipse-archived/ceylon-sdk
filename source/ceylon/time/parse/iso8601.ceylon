import ceylon.time { ... }
import ceylon.time.base { ... }

shared class ParseError(shared String message) {
    string = message;
}

shared object iso8601 {
    """Parses a string containing a Date values formatted in ISO 8601 format, returning the provided date.
    
     The parses recognizes dates 
     
     """
    shared ReadableDate|ParseError parseDate(String input) => ISO8601DateParser().parseDate(input);
    
}

alias ParseResult => [Integer, Integer, Integer, String];

Integer dashedForm = $00000001;
Integer yyyymmdd   = $00000010;
Integer yyyyWwwd   = $00000100;
Integer yyyyddd    = $00001000;
Integer yymmdd     = $00010000;

class ISO8601DateParser() {
    
    """The `Date` value of the given string representation of a date,
       or `null` if the string does not represent a valid date.
       
       The date accepted by this function must be formatted according to [ISO 8601]
       (https://en.wikipedia.org/wiki/ISO_8601) date format or it will not be recognized
       by this function.
       
       h2. Recognized Date formats
       
       h3. Calendar dates
       
       
       Calendar date representations are in the following form.
       ```
       YYYY-MM-DD	or	YYYYMMDD
       YYYY-MM	(but not YYYYMM)
       ``` 
       
       - `YYYY` indicates a four-digit year, `0000` through `9999`. 
       - `MM` indicates a two-digit month of the year, `01` through `12`. 
       - `DD` indicates a two-digit day of that month, `01` through `31`. 
    
       For example, "5 April 1981" may be represented as either "1981-04-05" in the extended format 
       or "19810405" in the basic format.
       
       The standard also allows for calendar dates to be written with reduced precision. 
       For example, one may write "1981-04" to mean "1981 April", and one may simply write "1981" to 
       refer to that year or "19" to refer to the century from 1900 to 1999 inclusive. Although the 
       standard allows both the YYYY-MM-DD and YYYYMMDD formats for complete calendar date 
       representations, if the day [DD] is omitted then only the YYYY-MM format is allowed. 
       By disallowing dates of the form YYYYMM, the standard avoids confusion with the truncated 
       representation YYMMDD (still often used).
       
       h3. Week Dates
       
       
       """
    shared ReadableDate|ParseError parseDate(String input) {
        
        variable Integer index = 0;
        variable Integer separator1 = -1;
        variable Integer separator2 = -1;
                
        for (Character c in input) {
            if (c == '-') {
                if (separator1 == -1) {
                    if (index == 2 || 4 <= index <= 6) {
                        separator1 = index;
                    }
                    else {
                        return ParseError("Unexpected separator at ``index``");
                    }
                }
                else if (separator2 == -1) {
                    if (index == separator1 + 2) {
                        seaparator2 = index;
                    }
                    else {
                        return ParseError("Unexpected separator at ``index``!");
                    }
                }
                else if (index == separator2 + 2) {
                    break;
                }
                else {
                    return ParseError("Unexpected separator at ``index``!");
                }
            }
            if (c.digit) {
                if (index - separator1 > 3) {
                }
            }
            index += 1;
        }
    }
}