/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
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
    
    "Two `DateTime`s are considered equals if they represent the same 
     [[Date]] and [[Time]]."
    shared actual default Boolean equals(Object other) {
        if (is DateTime other) {
            return date == other.date 
                && time == other.time;
        }
        return false;
    }
    
    "Implementation compatible with [[equals]] method.\n
     This implementation respect the constraint that if `x==y` then `x.hash==y.hash`."
    shared default actual Integer hash {
        value prime = 31;
        variable Integer result = 11;
        result = prime * result + date.hash;
        result = prime * result + time.hash;
        return result;
    }

}
 
"Returns a date based on the specified year, month and day of month values."
shared DateTime dateTime(
        Integer year, 
        Integer|Month month, 
        Integer day, 
        Integer hours = 0, 
        Integer minutes=0, 
        Integer seconds=0, 
        Integer milliseconds=0)
        => GregorianDateTime {
            date = createDate( year, month, day);
            time = createTime( hours, minutes, seconds, milliseconds );
        };
