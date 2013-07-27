import ceylon.time.timezone { TimeZone }
import ceylon.time.base { ReadableDateTime, DateTimeBehavior, Month }
import ceylon.time { Date, Time, Instant, dateTime }
import ceylon.time.internal { GregorianZonedDateTime, millisecondsOfEraFrom }

"Instant of time in a specific time zone."
shared interface ZoneDateTime
       satisfies ReadableDateTime
               & DateTimeBehavior<ZoneDateTime, Date, Time> 
               & Comparable<ZoneDateTime>
               & Ordinal<ZoneDateTime>{

    "Time zone information of this date and time value."
    shared formal TimeZone timeZone;

    shared formal Instant instant;

}

shared ZoneDateTime zoneDateTime(TimeZone zone, Integer year, Integer|Month month, Integer date, Integer hour = 0, Integer minutes=0, Integer seconds=0, Integer millis=0){
    return GregorianZonedDateTime(
        Instant(millisecondsOfEraFrom(dateTime(year, month, date, hour, minutes, seconds, millis), zone)),
        zone
    );
}
