import ceylon.time {
    Period,
	Instant
}
import ceylon.time.base {
    Month
}
import ceylon.time.timezone {
	timeZone
}


"Alias to represent a specific year."
shared alias Year => Integer;

"Model to #Rule rules, then we can read from any source.
 
 All the models are intended to be unrelated of the database origin.
 
 P.S.: Its not intended to be used outside of ceylon.time and currently
 its as shared because we need to test it."
shared class Rule(fromYear, toYear, inMonth, onDay, atTime, save, letter) {

    shared Year fromYear;
    shared Year toYear;
    shared Month inMonth;
    shared OnDay onDay;
    shared AtTime atTime;
    shared Period save;
    shared String letter;
    
    "True, if the provided instant matches the given rule"
    shared Boolean matches(Instant instant) {
        value dateTime = instant.dateTime(timeZone.utc);
        
        value matchesYear = fromYear <= dateTime.year <= toYear;
        value matchesMonth = inMonth == dateTime.month;
        value matchesDay = onDay.matches(dateTime.date);
        
        //TODO: How does timeDefinition should be handled here?
        value matchesTime = dateTime.time >= atTime.time;
        
        return matchesYear && matchesMonth && matchesDay && matchesTime;
    }

    shared actual Boolean equals(Object other) {
        if(is Rule other) {
            return        fromYear == other.fromYear
                    &&    toYear == other.toYear
                    &&    inMonth == other.inMonth
                    &&    onDay == other.onDay
                    &&    atTime == other.atTime
                    &&    save == other.save
                    &&    letter == other.letter;
        }
        return false;
    }

}