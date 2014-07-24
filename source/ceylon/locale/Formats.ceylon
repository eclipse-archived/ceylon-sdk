import ceylon.time {
    Date,
    Time
}

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
    currencyFormat) {
    
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
    
    shared String shortFormatDate(Date date) 
            => formatDate(shortDateFormat, date);
    shared String mediumFormatDate(Date date) 
            => formatDate(mediumDateFormat, date);
    shared String longFormatDate(Date date) 
            => formatDate(longDateFormat, date);
    
    shared String shortFormatTime(Time time) 
            => formatTime(shortTimeFormat, time);
    shared String mediumFormatTime(Time time) 
            => formatTime(mediumTimeFormat, time);
    shared String longFormatTime(Time time) 
            => formatTime(longTimeFormat, time);
    
    String formatDate(String format, Date date) {
        function interpolateToken(Integer->String token) 
                => (2 divides token.key) 
                    then formatDateToken(token.item, date) 
                    else token.item;
        value tokens = format.split('\''.equals, true, false);
        return String(tokens.indexed.flatMap(interpolateToken));
    }
    
    String formatTime(String format, Time time) {
        function interpolateToken(Integer->String token) 
                => (2 divides token.key) 
                    then formatTimeToken(token.item, time) 
                    else token.item;
        value tokens = format.split('\''.equals, true, false);
        return String(tokens.indexed.flatMap(interpolateToken));
    }
    
    String formatDateToken(String token, Date date) 
            => token
                .replaceFirst("MMMM", date.month.string[0..0].uppercased + date.month.string[1...])
                .replaceFirst("MMM", date.month.string[0..0].uppercased + date.month.string[1..2])
                .replaceFirst("MM", date.month.integer.string.padLeading(2,'0'))
                .replaceFirst("M", date.month.integer.string)
                .replaceFirst("dd", date.day.string.padLeading(2,'0'))
                .replaceFirst("d", date.day.string)
                .replaceFirst("yyyy", date.year.string.padLeading(4,'0')) 
                .replaceFirst("yy", date.year.string.padLeading(2,'0').terminal(2));
    
    function twelveHour(Integer hour) {
        if (hour==0) {
            return [12,"AM"];
        }
        else if (hour<=12) {
            return [hour,"AM"];
        }
        else {
            return [hour-12,"PM"];
        }
    }
    
    String formatTimeToken(String token, Time time) 
            => token
            .replaceFirst("hh", twelveHour(time.hours)[0].string.padLeading(2, '0'))
            .replaceFirst("h", twelveHour(time.hours)[0].string)
            .replaceFirst("HH", time.hours.string.padLeading(2, '0'))
            .replaceFirst("H", time.hours.string)
            .replaceFirst("a", twelveHour(time.hours)[1])
            .replaceFirst("mm", time.minutes.string.padLeading(2, '0'))
            .replaceFirst("ss", time.seconds.string.padLeading(2, '0'))
            .replaceFirst("z", "")
            .trimmed; //TimeZone not yet supported
}

Formats parseFormats(Iterator<String> lines) {
    
    assert (!is Finished dateFormats = lines.next());
    value dateCols = columns(dateFormats);
    assert (is String shortDateFormat = dateCols.next());
    assert (is String mediumDateFormat = dateCols.next());
    assert (is String longDateFormat = dateCols.next());
    assert (!is Finished timeFormats = lines.next());
    
    value timeCols = columns(timeFormats);
    assert (is String shortTimeFormat = timeCols.next());
    assert (is String mediumTimeFormat = timeCols.next());
    assert (is String longTimeFormat = timeCols.next());
    assert (!is Finished numberFormats = lines.next());
    
    value numCols = columns(numberFormats);
    assert (is String integerFormat = numCols.next());
    assert (is String floatFormat = numCols.next());
    assert (is String percentageFormat = numCols.next());
    assert (is String currencyFormat = numCols.next());
    
    assert (!is Finished blankLine1 = lines.next(), blankLine1.empty);
    
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
    };
}