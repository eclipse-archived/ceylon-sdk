import ceylon.time { createDate=date, createTime=time }
import ceylon.time.base { Month, DateTimeBehavior, ReadableDateTime, ReadablePeriod }
import ceylon.time.internal { GregorianDateTime }
import ceylon.time.timezone { tz = timeZone, TimeZone }

"An abstract moment in time (like _4pm, October 21. 2012_).
 
 DateTime does not contain a time zone information, so You can not use it to record or 
 schedule events."
shared interface DateTime 
    satisfies ReadableDateTime
            & DateTimeBehavior<DateTime, Date, Time> 
            & Ordinal<DateTime> & Enumerable<DateTime>
            & Comparable<DateTime> {

    "Adds a specified period to this date and time."
    shared formal DateTime plus(ReadablePeriod period);

    "Subtracts a specified period to this date and time."
    shared formal DateTime minus(ReadablePeriod period);

    "Returns the period between this and the given DateTime.
     
     If this date is before the given date then return zero period."
    shared formal Period periodFrom( DateTime start );

    "Returns the period between this and the given DateTime.
     
     If this DateTime is after the given DateTime then return zero period."
    shared formal Period periodTo( DateTime end );

    "Returns the [[DateTimeRange]] between this and given [[DateTime]]."
    shared formal DateTimeRange rangeTo( DateTime other );

    "Returns an instant from this [[DateTime]]."
    shared formal Instant instant(TimeZone timeZone = tz.system);

}
 
"Returns a date based on the specified year, month and day of month values."
shared DateTime dateTime(
        Integer year, 
        Integer|Month month, 
        Integer day, 
        Integer hours = 0, 
        Integer minutes=0, 
        Integer seconds=0, 
        Integer milliseconds=0){
    return GregorianDateTime( 
        createDate( year, month, day), 
        createTime( hours, minutes, seconds, milliseconds )
    );
}
