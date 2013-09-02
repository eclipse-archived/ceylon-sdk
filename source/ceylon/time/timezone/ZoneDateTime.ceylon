import ceylon.time.timezone { TimeZone }
import ceylon.time.base { ReadableDateTime, DateTimeBehavior, Month }
import ceylon.time { Date, Time, Instant, dateTime, DateTime }
import ceylon.time.internal { GregorianZonedDateTime }
import ceylon.time.chronology { unixTime }

"Instant of time in a specific time zone."
shared interface ZoneDateTime
       satisfies ReadableDateTime
               & DateTimeBehavior<ZoneDateTime, Date, Time> 
               & Comparable<ZoneDateTime>
               & Ordinal<ZoneDateTime>{

    "Time zone information of this date and time value."
    shared formal TimeZone timeZone;

    "Instant used as base."
    shared formal Instant instant;

}

"Returns a [[ZoneDateTime]] based on the specified [[TimeZone]], year, month, day of month, hour, minute, second and millisecond values."
shared ZoneDateTime zoneDateTime(TimeZone timeZone, Integer year, Integer|Month month, Integer date, Integer hour = 0, Integer minutes=0, Integer seconds=0, Integer millis=0) {
    DateTime utcDateTime = dateTime(year, month, date, hour, minutes, seconds, millis);
    value utcMilliseconds = unixTime.timeFromFixed(utcDateTime.dayOfEra) + utcDateTime.millisecondsOfDay;
    value fixedZoneMilliseconds = utcMilliseconds - timeZone.offset(Instant(utcMilliseconds));
    return GregorianZonedDateTime(
        Instant(fixedZoneMilliseconds),
        timeZone
    );
}
