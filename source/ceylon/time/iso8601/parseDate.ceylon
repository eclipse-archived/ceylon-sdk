/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
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
    value dashes = input.indexesWhere('-'.equals).sequence();
    
    if (input.size == 10) {
        if (dashes == [4,7],
            exists year  = parseYear(input[0..3]),
            exists month = parseMonth(input[5..6]),
            exists day   = parseDayOfMonth(input[8..9], year, month)) {
            
            return date(year, month, day);
        }
        else if (dashes == [4,8], exists ch = input[5], ch == 'W',
                 exists year = parseYear(input[0..3]),
                 exists week = parseWeek(input[6..7]),
                 exists day  = parseDay(input[9..9])) {
            
            return date(year, 1, 1).withWeekOfYear(week)
                                   .withDayOfWeek(dayOfWeek(day));
        }
    }
    else if (input.size == 8) {
        if (nonempty dashes) {
            if (dashes == [4],
                exists year      = parseYear(input[0..3]),
                exists dayOfYear = parseDay(input[5..7])) {
                
                return date(year, 1, 1).withDayOfYear(dayOfYear);
            }
        }
        // dashes is empty
        else if (exists ch = input[4], ch == 'W',
                 exists year = parseYear(input[0..3]),
                 exists week = parseWeek(input[5..6]),
                 exists day  = parseDay(input[7..7])) {
            
            return date(year, 1, 1).withWeekOfYear(week)
                                   .withDayOfWeek(dayOfWeek(day));
        }
        else if (exists year  = parseYear(input[0..3]),
                 exists month = parseMonth(input[4..5]),
                 exists day   = parseDay(input[6..7])) {
            
            return date(year, month, day);
        }
    }
    else if (input.size == 7, dashes.empty,
             exists year      = parseYear(input[0..3]),
             exists dayOfYear = parseDay(input[4..6])) {
        
        return date(year, 1, 1).withDayOfYear(dayOfYear);
    }
    
    // if we get here, this is most likely not in any format we recognize
    return null;
}

Integer? parseInteger(String string)
        => if (is Integer result = Integer.parse(string))
        then result else null;

Integer? parseWeek(String string) => parseInteger(string);
Integer? parseDay(String string) => parseInteger(string);
Integer? parseYear(String string) => parseInteger(string);

Month? parseMonth(String string) =>
    if (exists integer = parseInteger(string),
        exists month = months.valueOf(integer))
    then month else null;

Integer? parseDayOfMonth(String string, Integer year, Month month) =>
    let (value ym = yearMonth(year, month))
    if (exists day = parseInteger(string),
        1 <= day <= month.numberOfDays(ym.leapYear))
    then day else null;
