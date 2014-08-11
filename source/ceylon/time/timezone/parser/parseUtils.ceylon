import ceylon.time.base {
    years,
    weekdays,
    DayOfWeek,
    months,
    Month
}
import ceylon.time {
    Time,
    time,
    Period
}

"Alias to represent a specific signal:
 * Positive = 1
 * Negative = -1"
shared alias Signal => Integer;

"Parse the year token based on #Rule rules."
Integer parseYear(String year, Integer defaultYear) {
    if ("minimum".startsWith(year.trimmed.lowercased)) {
        return years.minimum;
    } else if ("maximum".startsWith(year.trimmed.lowercased)) {
        return years.maximum;
    } else if (year.equals("only")) {
        return defaultYear;
    }
    
    assert(exists resultYear = parseInteger(year) );
    return  resultYear;
}

"The rules represent the end of day as 24:00 and our ceylon.time.Time 
 does have another semantic for this."
Time adjustToEndOfDayIfNecessary(Integer hours, Integer minutes) {
    //TODO: So, for 24:00 are we going to adjust for 23:59:59.999 ?
    if( hours == 24 && minutes == 0 ) {
        return time(23,59,59,999);
    }
    return time( hours, minutes );
}

"Return the day of week based on #Rule token."
DayOfWeek findDayOfWeek(String dayOfWeek) {
    assert(exists dow = weekdays.find((DayOfWeek elem) => elem.string.lowercased.startsWith(dayOfWeek.trimmed.lowercased)));
    return dow;
}

"Transform time in Period 
 
 P.S.: This is a good case to add this feature to Time. something like:
       time(1,0).period"
Period toPeriod([Time, Integer] time) {
    return Period {
        hours = time[0].hours * time[1];
        minutes = time[0].minutes * time[1];
        seconds = time[0].seconds * time[1];
        milliseconds = time[0].milliseconds * time[1];
    };
}

"Return the time based on #Rule token.
 It does return a Tuple of the Time and its Signal."
[Time, Signal] parseTime(String atTime) {
    if( atTime.equals("-") ) {
        return [time(0, 0), 1];
    }
    value signal = atTime.startsWith("-") then -1 else 1;
    value position = atTime.startsWith("-") then 1 else 0;
    
    if(! atTime.firstOccurrence(':') exists ) {
        assert(exists hours = parseInteger(atTime));
        return [adjustToEndOfDayIfNecessary(hours, 0), signal];
    }
    
    assert( exists index = atTime.firstOccurrence(':') );
    assert( exists hours = parseInteger(atTime.span(position, index-1)));
    //TODO: Here we are discarding last letter if exists, 1:00u or 1:00s
    assert( exists minutes = parseInteger(atTime.span(index +1,index  + 2 )));
    
    return [adjustToEndOfDayIfNecessary( hours, minutes ), signal];
}

"Return the month based on #Rule token."
shared Month parseMonth(String month) {
    "Invalid Month for parse in timeZone"
    assert(exists currentMonth = months.all.find((Month elem) 
        => elem.string.lowercased.startsWith(month.trimmed.lowercased)));
    return currentMonth;
}