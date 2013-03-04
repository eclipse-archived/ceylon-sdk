import ceylon.time.base { ReadableDate, Month, DateBehavior, ReadableDatePeriod }
import ceylon.time.impl { gregorianDate }
import ceylon.time.timezone { TimeZone }

"An interface for date objects in the ISO-8601 calendar system.
 
 A date is often viewed as triple of year-month-day values. 
 This interface also defines access to other date fields such as 
 day-of-year, day-of-week and week-of-year."
shared interface Date
       satisfies ReadableDate & DateBehavior<Date>
               & Ordinal<Date> & Comparable<Date> {

    "Adds a specified period to this date."
    shared formal Date plus( ReadableDatePeriod period );

    "Subtracts a specified period to this date."
    shared formal Date minus( ReadableDatePeriod period );

    "Returns new DateTime value based on this date and a specified time"
    shared formal DateTime at( Time time );

}

"Returns current date according to the provided system clock and time zone."
shared Date today(Clock clock = systemTime, TimeZone? zone = null){
    return clock.instant().date(zone);
}

"Returns a date based on the specified year, month and day-ofMonth values"
shared Date date(Integer year, Integer|Month month, Integer day){
    return gregorianDate(year, month, day);
}
