import ceylon.time.timezone { TimeZone }
import ceylon.time.base { ReadableDateTime, DateTimeBehavior }
import ceylon.time { Date, Time }

"Instant of time in a specific time zone."
shared interface ZoneDateTime
       satisfies ReadableDateTime
               & DateTimeBehavior<ZoneDateTime, Date, Time> 
               & Comparable<ZoneDateTime>
               & Ordinal<ZoneDateTime>{

    "Time zone information of this date and time value."
    shared formal TimeZone timeZone;

}