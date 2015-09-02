import ceylon.time {
    ...
}
import ceylon.time.base {
    ...
}

"""The [[Date]] value of the given [[string representation|String]] 
   of a [ISO 8601](https://en.wikipedia.org/wiki/ISO_8601) date format 
   or `null` if the string does not contain valid ISO 8601 formatted 
   date value or the date is not formatted according to ISO standard.
   
   More specifically, this method parses any input that conforms to any of the 
   following date formats:
   
   - `YYYY-MM-DD` or `YYYYMMDD`
   - `YYYY-Www-D` or `YYYYWwwD`
   - `YYYY-DDD`   or `YYYYDDD`
    
    
   Where: `YYYY` stands for a full (four digit) year number,
   `MM` is a number of a month of year (ranging from `01` for January to `12` for December),
   `DD` is a number of a day of month (ranging from `01` to `31`),
   `Www` stands for a single uppercase character `'W'` followed by two digit number of a week (ranging from `01` to `53`)
   and `D` stands for a single digit day of week.
   
   **Note:** This function accepts only four digit full year date formats. 
   There is no support for abbreviated 2 digit format or year values larger than 4 digits.
   """
shared Date? parseDate(String input) {
    value dashes = input.indexesWhere(function(c) => c == '-').sequence();
    
    if (input.size == 10) {
        if (dashes == [4,7],
            exists Integer year  = parseInteger(input[0..3]),
            exists Integer month = parseInteger(input[5..6]),
            exists Integer day   = parseInteger(input[8..9])) {
            
            return date(year, month, day);
        }
        else if (dashes == [4,8], exists ch = input[5], ch == 'W',
                 exists Integer year = parseInteger(input[0..3]),
                 exists Integer week = parseInteger(input[6..7]),
                 exists Integer day  = parseInteger(input[9..9])) {
            
            return date(year, 1, 1).withWeekOfYear(week)
                                   .withDayOfWeek(dayOfWeek(day));
        }
    }
    else if (input.size == 8) {
        if (nonempty dashes) {
            if (dashes == [4],
                exists Integer year      = parseInteger(input[0..3]),
                exists Integer dayOfYear = parseInteger(input[5..7])) {
                
                return date(year, 1, 1).withDayOfYear(dayOfYear);
            }
        }
        // dashes is empty
        else if (exists ch = input[4], ch == 'W',
                 exists Integer year = parseInteger(input[0..3]),
                 exists Integer week = parseInteger(input[5..6]),
                 exists Integer day  = parseInteger(input[7..7])) {
            
            return date(year, 1, 1).withWeekOfYear(week)
                                   .withDayOfWeek(dayOfWeek(day));
        }
        else if (exists Integer year  = parseInteger(input[0..3]),
                 exists Integer month = parseInteger(input[4..5]),
                 exists Integer day   = parseInteger(input[6..7])) {
            
            return date(year, month, day);
        }
    }
    else if (input.size == 7, dashes.empty,
             exists Integer year      = parseInteger(input[0..3]),
             exists Integer dayOfYear = parseInteger(input[4..6])) {
        
        return date(year, 1, 1).withDayOfYear(dayOfYear);
    }
    
    // if we get here, this is most likely not in any format we recognize
    return null;
}
