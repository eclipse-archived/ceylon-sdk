/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
import ceylon.time.base {
    ReadableDate,
    ReadableTime,
    sunday
}
import ceylon.time {
    Date,
    date,
    Time,
    time,
    now
}
import ceylon.time.timezone {
    TimeZone,
    OffsetTimeZone
}

"Date, time, currency, and numeric formats for a certain
 [[Locale]]."
shared sealed class Formats(
    shortDateFormat, 
    mediumDateFormat, 
    longDateFormat, 
    shortTimeFormat, 
    mediumTimeFormat, 
    longTimeFormat, 
    integerFormat, 
    floatFormat, 
    percentageFormat, 
    currencyFormat,
    monthNames,
    monthAbbreviations,
    weekdayNames,
    weekdayAbbreviations,
    ampm) {
    
    shared String shortDateFormat;
    shared String mediumDateFormat;
    shared String longDateFormat;
    
    shared String shortTimeFormat;
    shared String mediumTimeFormat;
    shared String longTimeFormat;
    
    shared String integerFormat;
    shared String floatFormat;
    shared String percentageFormat;
    shared String currencyFormat;
    
    [String,String] ampm;
    shared String am => ampm[0];
    shared String pm => ampm[1]; 
    
    shared String[] weekdayNames;
    shared String[] weekdayAbbreviations;
    shared String[] monthNames;
    shared String[] monthAbbreviations;
    
    shared String shortFormatDate(ReadableDate date) 
            => formatDate(shortDateFormat, date);
    shared String mediumFormatDate(ReadableDate date) 
            => formatDate(mediumDateFormat, date);
    shared String longFormatDate(ReadableDate date) 
            => formatDate(longDateFormat, date);
    
    shared String shortFormatTime(ReadableTime time) 
            => formatTime(shortTimeFormat, time);
    shared String mediumFormatTime(ReadableTime time) 
            => formatTime(mediumTimeFormat, time);
    shared String longFormatTime(ReadableTime time, TimeZone timeZone) 
            => formatTimeWithTZ(longTimeFormat, time, timeZone);
    
    String formatDate(String format, ReadableDate date) 
            => applyFormat(format, formatDateToken, date);
    
    String formatTime(String format, ReadableTime time)
            => applyFormat(format, formatTimeToken, time);
    
    String formatTimeWithTZ(String format, ReadableTime time, TimeZone timeZone)
            => applyFormatWithTZ(format, formatTimeToken, time, timeZone);
    
    String applyFormat<Value>(String format, 
        String formatToken(String token, Value val), 
        Value val) {
        function interpolateToken(Integer->String token) 
                => 2.divides(token.key) 
                    then formatToken(token.item, val) 
                    else token.item;
        value tokens = format.split('\''.equals, true, false);
        return String(tokens.indexed.flatMap(interpolateToken));
    }
    
    String applyFormatWithTZ<Value>(String format, 
        String formatToken(String token, Value val, TimeZone timeZone), 
        Value val, TimeZone timeZone) {
        function interpolateToken(Integer->String token) 
                => 2.divides(token.key) 
        then formatToken(token.item, val, timeZone) 
        else token.item;
        value tokens = format.split('\''.equals, true, false);
        return String(tokens.indexed.flatMap(interpolateToken));
    }
    
    String formatDateToken(String token, ReadableDate date) {
        
        value weekdayName 
                => weekdayNames[date.dayOfWeek.integer-1] 
                else date.dayOfWeek.string;
        value weekdayAbbr 
                => weekdayAbbreviations[date.dayOfWeek.integer-1] 
                else date.dayOfWeek.string.initial(3);
        value monthName 
                => monthNames[date.month.integer-1] 
                else date.month.string;
        value monthAbbr 
                => monthAbbreviations[date.month.integer-1] 
                else date.month.string.initial(3);
        value month 
                => date.month.integer.string;
        value twoDigitMonth 
                => month.padLeading(2,'0');
        value day 
                => date.day.string;
        value twoDigitDay 
                => day.padLeading(2,'0');
        value fourDigitYear 
                => date.year.string.padLeading(4,'0');
        value twoDigitYear 
                => date.year.string.padLeading(2,'0').terminal(2);
        value weekOfYear 
                => date.weekOfYear.string;
        value twoDigitWeekOfYear 
                => weekOfYear.padLeading(2,'0');
        value dayNumberInWeek 
                => let (dow=date.dayOfWeek) 
                (dow==sunday then 7 else dow.integer).string;
        
        value result = StringBuilder();
        for (run in runs(token)) {
            value replacement =
                    switch (run)
                    case ("EEEE") weekdayName
                    case ("EEE") weekdayAbbr
                    case ("EE") weekdayAbbr
                    case ("E") weekdayAbbr
                    case ("MMMM") monthName
                    case ("MMM") monthAbbr
                    case ("MM") twoDigitMonth
                    case ("M") month
                    case ("dd") twoDigitDay
                    case ("d") day
                    case ("u") dayNumberInWeek
                    case ("yyyy") fourDigitYear
                    case ("yyy") fourDigitYear
                    case ("yy") twoDigitYear
                    case ("y") fourDigitYear //yes)really
                    case ("W") "" //TODO: week of month
                    case ("F") "" //TODO: day of week in month
                    case ("ww") twoDigitWeekOfYear
                    case ("w") weekOfYear
                    case ("G") "" //TODO: era           
                    else run;
            result.append(replacement);
        }
        return result.string;
    }
    
    function twelveHour(Integer hour)
            => let (modHour = hour % 12) [
                modHour == 0 then 12 else modHour,
                hour < 12 then ampm[0] else ampm[1]
            ];
    
    String formatTimeToken(String token, 
        ReadableTime time, TimeZone? timeZone=null) {
        
        value ampm => twelveHour(time.hours)[1];
        value twelvehour 
                => twelveHour(time.hours)[0].string;
        value weirdTwelvehour 
                => (time.hours<12 then time.hours else time.hours-12).string;
        value twoDigitTwelvehour 
                => twelvehour.padLeading(2, '0');
        value twoDigitWeirdTwelvehour 
                => weirdTwelvehour.padLeading(2, '0');
        value hour 
                => time.hours.string;
        value twoDigitHour 
                => hour.padLeading(2, '0');
        value weirdHour 
                => (time.hours+1).string;
        value twoDigitWeirdHour 
                => weirdHour.padLeading(2, '0');
        value mins 
                => time.minutes.string;
        value twoDigitMins 
                => mins.padLeading(2, '0');
        value secs 
                => time.seconds.string;
        value twoDigitSecs 
                => secs.padLeading(2, '0');
        value millis 
                => time.milliseconds.string;
        value threeDigitMillis 
                => millis.padLeading(3,'0');
        value twoDigitMillis 
                => millis.padLeading(2,'0');
        
        value generalTimeZone 
                => if (exists timeZone) 
                then "GMT" + timeZone.string
                else "";
        
        value simpleTimeZone
                => if (exists timeZone) 
                then timeZone.string
                else "";
        
        value longTimeZone
                => if (exists timeZone) 
                then if (is OffsetTimeZone timeZone, 
                         timeZone.offsetMilliseconds==0)
                    then "Z" 
                    else timeZone.string 
                else "";
        
        value mediumTimeZone
                => longTimeZone.replaceFirst(":", "");
        
        value shortTimeZone
                => let (tz=longTimeZone,
                        col=tz.firstOccurrence(':')) 
                    if (exists col) 
                    then tz[0:col]
                    else tz;
        
        value result = StringBuilder();
        for (run in runs(token)) {
            value replacement =
                    switch (run)
                    case ("hh") twoDigitTwelvehour
                    case ("h") twelvehour
                    case ("KK") twoDigitWeirdTwelvehour
                    case ("K") weirdTwelvehour
                    case ("HH") twoDigitHour
                    case ("H") hour
                    case ("kk") twoDigitWeirdHour
                    case ("k") weirdHour
                    case ("a") ampm
                    case ("mm") twoDigitMins
                    case ("m") mins
                    case ("ss") twoDigitSecs
                    case ("s") secs
                    case ("SSS") threeDigitMillis
                    case ("SS") twoDigitMillis
                    case ("S") millis
                    case ("XXX") longTimeZone
                    case ("XX") mediumTimeZone
                    case ("X") shortTimeZone
                    case ("Z") simpleTimeZone
                    case ("z") generalTimeZone
                    else run;
            result.append(replacement);
        }
        return result.string;
    }
    
    "Given a [[string|text]] expected to represent a 
     formatted date, comprising day, month, and year fields, 
     the [[order|dateOrder]] of the fields in the formatted 
     date, and a list of [[delimiting characters|separators]], 
     return a [[Date]], or `null` if the string cannot be 
     interpreted as a date with the given field order and 
     delimiters. If [[twoDigitCutoffYear]] is non-null, then 
     formatted dates may be written with two-digit years.
     
     For example
     
         au.formats.parseDate(\"3 June 2010\")
     
     produces the date `2010-06-03`, if `au` is the `Locale`
     for `en-AU`. And
     
         us.formats.parseDate(\"01/02/03\", monthDayYear)
     
     produces the date `2003-01-02`, if `us` is the `Locale`
     for `en-US`."
    throws (`class AssertionError`, 
            "if the given [[order|dateOrder]] does not 
             include the day, month, and year")
    shared Date? parseDate(
        "The formatted date."
        String text,
        "The order of the fields of the fomatted date,
         usually [[dayMonthYear]], [[yearMonthDay]], or
         [[monthDayYear]]."
        DateField.Order dateOrder
                //TODO: get the default from the locale! 
                = dayMonthYear,
        "The earliest year which can be written in two-digit
         form, or `null` if two-digit years should be 
         interpreted literally. Defaults to 80 years before
         the current year."
        Integer? twoDigitCutoffYear 
                = now().date().year-80,
        "The characters to recognize as field separators."
        String separators = "/-., ") {
        
        "field order must include day"
        assert (exists dayIndex = 
                dateOrder.firstIndexWhere(DateField.day.equals));
        "field order must include month"
        assert (exists monthIndex = 
                dateOrder.firstIndexWhere(DateField.month.equals));
        "field order must include year"
        assert (exists yearIndex = 
                dateOrder.firstIndexWhere(DateField.year.equals));
        
        value bits = 
                text.split(separators.contains)
                    .map(String.trimmed)
                    .sequence();
            
        Integer day;
        if (exists dayBit = bits[dayIndex]) {
            if (is Integer d = Integer.parse(dayBit)) {
                day = d;
            }
            else {
                return null;
            }
        }
        else {
            return null;
        }
        
        Integer month;
        if (exists monthBit = bits[monthIndex]) {
            if (is Integer m = Integer.parse(monthBit)) {
                month = m;
            }
            else if (exists m = monthNames.locate(monthBit.equalsIgnoringCase)) {
                month = m.key+1;
            }
            else if (exists m = monthAbbreviations.locate(monthBit.equalsIgnoringCase)) {
                month = m.key+1;
            }
            else {
                return null;
            }
        }
        else {
            return null;
        }
        
        Integer year;
        if (exists yearBit = bits[yearIndex]) {
            if (is Integer y = Integer.parse(yearBit)) {
                if (exists twoDigitCutoffYear, y<100) {
                    year = let (century = twoDigitCutoffYear/100,
                                cutoff = twoDigitCutoffYear%100)
                            if (y > cutoff)
                            then century*100 + y 
                            else (century+1)*100 + y;
                }
                else {
                    year = y;
                }
            }
            else {
                return null;
            }
        }
        else {
            return null;
        }
        
        return date {
            year = year;
            month = month;
            day = day;
        };
    }
    
    "Given a [[string|text]] expected to represent a 
     formatted time, comprising an hour, followed by 
     optional minute, second, and millisecond fields, 
     followed by an optional AM or PM marker, and a list of 
     [[delimiting characters|separators]], return a [[Time]], 
     or `null` if the string cannot be interpreted as a time 
     with the given delimiters."
    shared Time? parseTime(
    "The formatted time."
        String text,
        "The characters to recognize as field separators."
        String separators = ":. ") {
        
        value bitsWithAmPm = 
                text.split(separators.contains)
                    .map(String.trimmed)
                    .sequence();
        
        String[] bits;
        Boolean adjust;
        value last = bitsWithAmPm.last;
        value eqPm = pm.equalsIgnoringCase(last);
        value eqAm = am.equalsIgnoringCase(last);
        if (eqPm || eqAm) {
            bits = bitsWithAmPm[0:bitsWithAmPm.size-1];
            adjust = eqPm;
        }
        else {
            bits = bitsWithAmPm;
            adjust = false;
        }

        Integer hour;
        if (exists hourBit = bits[0]) {
            if (is Integer d = Integer.parse(hourBit)) {
                hour = d;
            }
            else {
                return null;
            }
        }
        else {
            return null;
        }
        
        Integer minute;
        if (exists minuteBit = bits[1]) {
            if (is Integer m = Integer.parse(minuteBit)) {
                minute = m;
            }
            else {
                return null;
            }
        }
        else {
            minute = 0;
        }
        
        Integer second;
        if (exists secondBit = bits[2]) {
            if (is Integer y = Integer.parse(secondBit)) {
                second = y;
            }
            else {
                return null;
            }
        }
        else {
            second = 0;
        }
        
        Integer millis;
        if (exists msBit = bits[3]) {
            if (is Integer y = Integer.parse(msBit)) {
                millis = y;
            }
            else {
                return null;
            }
        }
        else {
            millis = 0;
        }
        
        return time {
            hours = adjust then hour+12 else hour;
            minutes = minute;
            seconds = second;
            milliseconds = millis;
        };
    }

}

Formats parseFormats(Iterator<String> lines) {
    
    assert (!is Finished ampmLine = lines.next());
    value ampmCols = columns(ampmLine).iterator();
    assert (is String am=ampmCols.next(), 
        is String pm=ampmCols.next());
    
    assert (!is Finished monthsNameLine = lines.next());
    value monthNames = columns(monthsNameLine).coalesced.sequence();
    assert (!is Finished monthsAbbrLine = lines.next());
    value monthAbbreviations = columns(monthsAbbrLine).coalesced.sequence();
    
    assert (!is Finished dayNameLine = lines.next());
    value dayNames = columns(dayNameLine).coalesced.sequence();
    assert (!is Finished dayAbbrLine = lines.next());
    value dayAbbreviations = columns(dayAbbrLine).coalesced.sequence();
    
    assert (!is Finished dateFormats = lines.next());
    value dateCols = columns(dateFormats).iterator();
    assert (is String shortDateFormat = dateCols.next());
    assert (is String mediumDateFormat = dateCols.next());
    assert (is String longDateFormat = dateCols.next());
    assert (!is Finished timeFormats = lines.next());
    
    value timeCols = columns(timeFormats).iterator();
    assert (is String shortTimeFormat = timeCols.next());
    assert (is String mediumTimeFormat = timeCols.next());
    assert (is String longTimeFormat = timeCols.next());
    assert (!is Finished numberFormats = lines.next());
    
    value numCols = columns(numberFormats).iterator();
    assert (is String integerFormat = numCols.next());
    assert (is String floatFormat = numCols.next());
    assert (is String percentageFormat = numCols.next());
    assert (is String currencyFormat = numCols.next());
    
    assert (!is Finished blankLine1 = lines.next(), 
            blankLine1.empty);
    
    return Formats {
        shortDateFormat = shortDateFormat;
        mediumDateFormat = mediumDateFormat;
        longDateFormat = longDateFormat;
        shortTimeFormat = shortTimeFormat;
        mediumTimeFormat = mediumTimeFormat;
        longTimeFormat = longTimeFormat;
        integerFormat = integerFormat;
        floatFormat = floatFormat;
        percentageFormat = percentageFormat;
        currencyFormat = currencyFormat;
        ampm = [am,pm];
        monthNames = monthNames;
        monthAbbreviations = monthAbbreviations;
        weekdayNames = dayNames;
        weekdayAbbreviations = dayAbbreviations;
    };
}

"Splits a string into 'runs' of the same character."
{String*} runs(String text) 
        => object satisfies {String*} {
    iterator() 
            => object satisfies Iterator<String> {
        variable value i = 0;
        shared actual String|Finished next() {
            value start = i;
            if (exists ch = text[i++]) {
                while (exists next = text[i], 
                        next==ch) {
                    i++;
                }
                return text[start..i-1];
            }
            else {
                return finished;
            }
        }
    };
};
