import ceylon.time {
    Period
}
import ceylon.time.base {
    Month
}

"Alias to represent a specific year."
shared alias Year => Integer;

shared class Rule(fromYear, toYear, inMonth, onDay, atTime, save, letter) {

    shared Year fromYear;
    shared Year toYear;
    shared Month inMonth;
    shared OnDay onDay;
    shared AtTime atTime;
    shared Period save;
    shared String letter;

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