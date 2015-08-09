import ceylon.time {
    Time,
    time
}
import ceylon.time.base {
    ReadableTime
}

"""The [[Time]] value of the given [[string representation|String]] 
   of a [ISO 8601](https://en.wikipedia.org/wiki/ISO_8601) date format 
   or `null` if the string does not contain valid ISO 8601 formatted 
   date value or the date is not formatted according to ISO standard.

   """
shared Time? parseTime(String input) {
    if (input.size == 2) {
        if (exists hh = parseInteger(input)) {
            return time(hh, 00);
        }
    }
    else if (input.size == 12) {
        if (exists c1 = input[2], c1 == ':',
            exists c2 = input[5], c2 == ':',
            exists c3 = input[8], c3 == '.') {
            
            if (exists hh = parseInteger(input[0..1]),
                exists mm = parseInteger(input[3..4]),
                exists ss = parseInteger(input[6..7]),
                exists sss = parseInteger(input[9..11])) {
                
                return time(hh, mm, ss, sss);
            }
        }
    }
    else if (input.size == 10) {
        if (exists c3 = input[6], c3 == '.') {
            if (exists hh = parseInteger(input[0..1]),
                exists mm = parseInteger(input[2..3]),
                exists ss = parseInteger(input[4..5]),
                exists sss = parseInteger(input[7..9])) {
                
                return time(hh, mm, ss, sss);
            }
        }
    }
    else if (input.size == 8) {
        if (exists c1 = input[2], c1 == ':',
            exists c2 = input[5], c2 == ':') {
            
            if (exists hh = parseInteger(input[0..1]),
                exists mm = parseInteger(input[3..4]),
                exists ss = parseInteger(input[6..7])) {
                
                return time(hh, mm, ss);
            }
        }
    }
    else if (input.size == 6) {
        if (exists hh = parseInteger(input[0..1]),
            exists mm = parseInteger(input[2..3]),
            exists ss = parseInteger(input[4..5])) {
            
            return time(hh, mm, ss);
        }
    }
    else if (input.size == 5) {
        if (exists c1 = input[2], c1 == ':') {
            
            if (exists hh = parseInteger(input[0..1]),
                exists mm = parseInteger(input[3..4])) {
                
                return time(hh, mm);
            }
        }
    }
    else if (input.size == 4) {
        if (exists hh = parseInteger(input[0..1]),
            exists mm = parseInteger(input[2..3])) {
            
            return time(hh, mm);
        }
    }
    return null;
}