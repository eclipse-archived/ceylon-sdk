import ceylon.time {
    Period
}
import ceylon.time.base {
    Month
}

"Alias to represent a specific year."
shared alias Year => Integer;

"Model to holds every column as its original form.
 
  P.S.: Its not intended to be used outside of ceylon.time and currently
 its as shared because we need to test it."
shared class Rule(fromYear, toYear, type, month, onDay, atTime, offset, letter) {

    shared Year fromYear;
    shared Year toYear;
    shared String type;
    shared Month month;
    shared DayRule onDay;
    shared TimeRule atTime;
    shared Period offset;
    shared String letter;

    shared actual Boolean equals(Object other) {
        if(is Rule other) {
            return        fromYear == other.fromYear
                    &&    toYear == other.toYear
                    &&    type == other.type
                    &&    month == other.month
                    &&    onDay == other.onDay
                    &&    atTime == other.atTime
                    &&    offset == other.offset
                    &&    letter == other.letter;
        }
        return false;
    }

}