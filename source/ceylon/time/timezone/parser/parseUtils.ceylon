import ceylon.time.base {
    years,
    Month,
    months,
    DayOfWeek,
    weekdays
}
import ceylon.time.timezone.model {
    AtTime,
    OnDay,
    AtTimeDefinition,
    wallClockDefinition,
    OnFirstOfMonth,
    OnFixedDay,
    OnLastOfMonth,
    standardTimeDefinition,
    utcTimeDefinition,
    DayOfMonth
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

shared Month parseMonth(String month) {
    "Invalid Month for parse in timeZone"
    assert(exists currentMonth = months.all.find((Month elem) 
        => elem.string.lowercased.startsWith(month.trimmed.lowercased)));
    return currentMonth;
}

[Time, Signal, AtTimeDefinition] parseTime(String atTime) {
    if( atTime.equals("-") ) {
        return [time(0, 0), 1, wallClockDefinition];
    }
    value signal = atTime.startsWith("-") then -1 else 1;
    value position = atTime.startsWith("-") then 1 else 0;
    
    if(! atTime.firstOccurrence(':') exists ) {
        assert(exists hours = parseInteger(atTime.spanFrom(position)));
        return [adjustToEndOfDayIfNecessary(hours, 0), signal, wallClockDefinition];
    }
    
    value indexes = atTime.indexesWhere(':'.equals).sequence();
    
    assert( exists firstIndex = indexes[0] );
    assert( exists hours = parseInteger(atTime.span(position, firstIndex-1)));
    assert( exists minutes = parseInteger(atTime.span(firstIndex +1,firstIndex  + 2 )));
    variable value partialTime = adjustToEndOfDayIfNecessary( hours, minutes ); 
    AtTimeDefinition ruleDefinition;
    if( indexes.size == 1 ) {
        ruleDefinition = parseAtTimeDefinition(atTime.spanFrom(firstIndex + 3));
    } else {
        assert( exists secondIndex = indexes[1] );  
        assert( exists seconds = parseInteger(atTime.span(secondIndex + 1 ,secondIndex  + 2 ))); 
        
        partialTime = partialTime.plusSeconds(seconds);   
        ruleDefinition = parseAtTimeDefinition(atTime.spanFrom(secondIndex + 3));
    }
    
    return [partialTime, signal, ruleDefinition ];
}

shared AtTime parseAtTime(String token) {
    value result = parseTime(token);
    return AtTime(result[0], result[2]);
}

shared OnDay parseOnDay(String token) {
    //Split all values
    value result = parseOnDayToken(token);
    
    //now apply correct type
    if(exists day = result[0]) {
        if(exists dayOfWeek = result[1]) {
            return OnFirstOfMonth(dayOfWeek, day);
        } else {
            return OnFixedDay(day);
        }
    } 
    assert(exists dayOfWeek = result[1]);
    return OnLastOfMonth(dayOfWeek);
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

shared AtTimeDefinition parseAtTimeDefinition(String token) {
    switch (token)
    case("s", "S") {
        return standardTimeDefinition;
    }
    case("g", "G", "u", "U", "z", "Z") {
        return utcTimeDefinition;
    }
    case("w", "W") {
        return wallClockDefinition;
    } 
    else {
        return wallClockDefinition;
    }
}

[DayOfMonth?, DayOfWeek?, Comparison] parseOnDayToken(String token) {
    variable [DayOfMonth?, DayOfWeek?, Comparison] result = [null,null, equal];
    if (token.startsWith("last")) {
        result = [null, findDayOfWeek(token.spanFrom(4)), larger];
    } else {
        value gtIdx = token.firstInclusion(">=");
        value stIdx = token.firstInclusion("<=");
        if (exists gtIdx , gtIdx > 0) {
            result = [parseInteger(token.spanFrom(gtIdx + 2).trimmed), findDayOfWeek(token.span(0, gtIdx -1)), larger];
        } else if( exists stIdx, stIdx > 0) {
            result = [parseInteger(token.spanFrom(stIdx + 2)), findDayOfWeek(token.span(0, stIdx-1)), smaller];
        } else {
            result = [parseInteger(token), null, equal];
        }
    }
    return result;
}

DayOfWeek findDayOfWeek(String dayOfWeek) {
    assert(exists dow = weekdays.find((DayOfWeek elem) => elem.string.lowercased.startsWith(dayOfWeek.trimmed.lowercased)));
    return dow;
}

"Transform time in Period 
 
 P.S.: This is a good case to add this feature to Time. something like:
       time(1,0).period"
Period toPeriod([Time, Signal, AtTimeDefinition] time) {
    return Period {
        hours = time[0].hours * time[1];
        minutes = time[0].minutes * time[1];
        seconds = time[0].seconds * time[1];
        milliseconds = time[0].milliseconds * time[1];
    };
}

shared Boolean tokenDelimiter(Character char) {
    return char == ' ' || char == '\t';
}
