import ceylon.time {
    Time,
    time
}
import ceylon.time.base {
    minutes,
    seconds
}

"""The [[Time]] value of the given [[string representation|String]] 
   of a [ISO 8601](https://en.wikipedia.org/wiki/ISO_8601) date format 
   or `null` if the string does not contain valid ISO 8601 formatted 
   date value or the date is not formatted according to ISO standard.
   
   More specifically, this method parses any input that conforms to any 
   of the following date formats:
   
   - `hh:mm:ss.sss` (or `hhmmss.sss`),
   - `hh:mm:ss` (or `hhmmss`),
   - `hh:mm` (or `hhmm`)
   - and `hh`
   
   Where `hh` stands for 2 digit 24 hour clock hour value between 
   `00` and `24` (where `24` is only used to denote midnight at the 
   end of a calendar day)
   
   """
shared Time? parseTime(String input) => convertToTime(parseTimeComponents(input));

shared Time? convertToTime([Integer, Integer, Integer, Integer]? timeComponents) {
    if (exists [hh, mm, ss, sss] = timeComponents) {
        if ([24, 00, 00, 000] == [hh, mm, ss, sss]) {
            return time(00, 00);
        }
        if (00 <= hh <= 23, 00 <= mm <= 59, 00 <= ss <= 59, 000 <= sss <= 999) {
            return time(hh, mm, ss, sss);
        }
    }
    return null;
}

[Integer, Integer, Integer, Integer]? parseTimeComponents(String input) {
    function calculateFraction(Integer magnitude, String fractionPart) 
            => if (fractionPart.empty)
               then 00 else let (Float? fraction = parseFloat("0."+fractionPart))
                    if (exists fraction) then (magnitude * fraction).integer else null;

    function parseMilliseconds(String fractionPart)
            => if (fractionPart.empty) then 000 
               else if (exists sss = parseInteger(fractionPart)) 
                        then sss else null;
     
    String timePart;
    String fractionPart;
    if (exists i = input.firstIndexWhere((c) => c in ['.', ','])) {
        timePart = input[...i-1];
        fractionPart = input[i+1...];
    }
    else {
        timePart = input;
        fractionPart = "";
    }
    
    if (timePart.size == 2) {
        if (exists hh = parseInteger(timePart),
            exists mm = calculateFraction(minutes.perHour, fractionPart)) {
            
            return [hh, mm, 00, 000];
        }
    }
    else if (timePart.size == 8) {
        if (timePart.occursAt(2, ':'),
            timePart.occursAt(5, ':')) {
            
            if (exists hh  = parseInteger(timePart[0..1]),
                exists mm  = parseInteger(timePart[3..4]),
                exists ss  = parseInteger(timePart[6..7]),
                exists sss = parseMilliseconds(fractionPart)) {
                
                return [hh, mm, ss, sss];
            }
        }
    }
    else if (timePart.size == 6) {
        if (exists hh  = parseInteger(timePart[0..1]),
            exists mm  = parseInteger(timePart[2..3]),
            exists ss  = parseInteger(timePart[4..5]),
            exists sss = parseMilliseconds(fractionPart)) {
            
            return [hh, mm, ss, sss];
        }
    }
    else if (timePart.size == 5) {
        if (timePart.occursAt(2, ':')) {
            
            if (exists hh = parseInteger(timePart[0..1]),
                exists mm = parseInteger(timePart[3..4]),
                exists ss = calculateFraction(seconds.perMinute, fractionPart)) {
                
                return [hh, mm, ss, 000];
            }
        }
    }
    else if (timePart.size == 4) {
        if (exists hh = parseInteger(timePart[0..1]),
            exists mm = parseInteger(timePart[2..3]),
            exists ss = calculateFraction(seconds.perMinute, fractionPart)) {
            
            return [hh, mm, ss, 000];
        }
    }
    return null;
}

