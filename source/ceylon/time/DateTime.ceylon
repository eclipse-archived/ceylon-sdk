import ceylon.time { createDate=date, createTime=time }
import ceylon.time.base { Month, DateTimeBehavior, ReadableDateTime, ReadablePeriod }
import ceylon.time.impl { GregorianDateTime }

doc "An abstract moment in time (like _4pm, October 21. 2012_).
     
     DateTime does not contain a time zone information, so You can not use it to record or 
     schedule events."
shared interface DateTime 
    satisfies ReadableDateTime
            & DateTimeBehavior<DateTime, Date, Time> 
            & Ordinal<DateTime>
            & Comparable<DateTime> {

    shared formal DateTime plus(ReadablePeriod period);

    shared formal DateTime minus(ReadablePeriod period);

}
 
doc "Returns a date based on the specified year, month and day-of-month values"
shared DateTime dateTime(Integer year, Integer|Month month, Integer date, Integer hour = 0, Integer minutes=0, Integer seconds=0, Integer millis=0){
    return GregorianDateTime( createDate( year, month, date), createTime( hour, minutes, seconds, millis ));
}