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
shared interface ReadableDate {

    "The year of the date."
    shared formal Integer year;

    "Month of the year value of the date."
    shared formal Month month;

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

    "True if the year of the date is a leap year."
    shared formal Boolean leapYear;

}
