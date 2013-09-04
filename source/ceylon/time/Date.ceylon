import ceylon.time.base { ReadableDate, Month, DateBehavior, ReadableDatePeriod }
import ceylon.time.internal { gregorianDate }
import ceylon.time.timezone { TimeZone, tz = timeZone }

"An interface for date objects in the ISO-8601 calendar system.
 
 A date is often viewed as triple of year-month-day values. 
 This interface also defines access to other date fields such as 
 day-of-year, day-of-week and week-of-year."
shared interface Date
       satisfies ReadableDate & DateBehavior<Date>
               & Ordinal<Date> & Comparable<Date> & Enumerable<Date> {

    "Adds a specified period to this date."
    shared formal Date plus( ReadableDatePeriod period );

    "Subtracts a specified period to this date."
    shared formal Date minus( ReadableDatePeriod period );

    "Returns the period between this and the given date.
     
     If this date is before the given date then return zero period."
    shared formal Period periodFrom( Date start );

    "Returns the period between this and the given date.
     
     If this date is after the given date then return zero period."
    shared formal Period periodTo( Date end );

    "Returns new DateTime value based on this date and a specified time."
    shared formal DateTime at( Time time );

    "Returns the [[DateRange]] between this and given [[Date]]."
    shared formal DateRange rangeTo( Date other );

}

"Returns current date according to the provided system clock and time zone."
shared Date today(Clock clock = systemTime, TimeZone timeZone = tz.system){
    return clock.instant().date(timeZone);
}

"Returns a date based on the specified year, month and day of month values."
shared Date date(Integer year, Integer|Month month, Integer day){
    return gregorianDate(year, month, day);
}
