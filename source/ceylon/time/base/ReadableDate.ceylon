import ceylon.time { Date, Time, DateTime }
import ceylon.time.timezone { ZoneDateTime }

"A common interface of all date like objects.
 
 This interface is common to all data types that
 either partially or fully represent information 
 that can be interpreted as _date_."
see(`interface Date`,
    `interface Time`,
    `interface DateTime`,
    `interface ZoneDateTime`)
shared interface ReadableDate satisfies ReadableYear & ReadableMonth {

    "Day of month value of the date."
    shared formal Integer day;

    "Day of the week."
    shared formal DayOfWeek dayOfWeek;

    "Number of the week of the date."
    shared formal Integer weekOfYear;

    "Number of the day in year."
    shared formal Integer dayOfYear;

    "Number of calendar days since ERA."
    shared formal Integer dayOfEra;

}
