/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
import ceylon.time.timezone { TimeZone }
import ceylon.time.base { ReadableDateTime, DateTimeBehavior, Month }
import ceylon.time { Date, Time, Instant, dateTime, DateTime }
import ceylon.time.internal { GregorianZonedDateTime }
import ceylon.time.chronology { unixTime }

"Instant of time in a specific time zone."
shared interface ZoneDateTime
       satisfies ReadableZoneDateTime
               & ReadableDateTime & ReadableTimeZone
               & DateTimeBehavior<ZoneDateTime, Date, Time> 
               & Comparable<ZoneDateTime>
               & Ordinal<ZoneDateTime> & Enumerable<ZoneDateTime> {

    "Instant used as base."
    shared formal Instant instant;
    
    "Returns current time zone offset from UTC in milliseconds"
    shared default Integer currentOffsetMilliseconds => timeZone.offset(instant);
    
    "Local date and time according to the current time zone of this instance.
     
     **Note:** The resulting [[DateTime]], is a local representation of 
     this date and time stripped of any time zone information."
    shared formal DateTime dateTime;
    
    "Returns _true_ if given value is same date, time and timezone."
    shared actual Boolean equals( Object other ) {
        if (is ZoneDateTime other) {
            return instant  == other.instant 
                && timeZone == other.timeZone;
        }
        return false;
    }
    
    "Implementation compatible with [[equals]] method.\n
     This implementation respect the constraint that if `x==y` then `x.hash==y.hash`."
    shared default actual Integer hash {
        value prime = 31;
        variable Integer result = 21;
        result = prime * result + instant.hash;
        result = prime * result + timeZone.hash;
        return result;
    }
    
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
