import ceylon.time.base {
    DayOfWeek,
    weekdays
}
import ceylon.time.timezone.model {
    AtTime
}
import ceylon.time {
    Period
}

DayOfWeek findDayOfWeek(String dayOfWeek) {
    assert(exists dow = weekdays.find((DayOfWeek elem) => elem.string.lowercased.startsWith(dayOfWeek.trimmed.lowercased)));
    return dow;
}

"Transform time in Period 
 
 P.S.: This is a good case to add this feature to Time. something like:
       time(1,0).period"
Period toPeriod([AtTime, Signal] signedTime) {
    value [atTime, signal] = signedTime;
    return Period {
        hours = atTime.time.hours * signal;
        minutes = atTime.time.minutes * signal;
        seconds = atTime.time.seconds * signal;
        milliseconds = atTime.time.milliseconds * signal;
    };
}

shared Boolean tokenDelimiter(Character char) {
    return char == ' ' || char == '\t';
}
