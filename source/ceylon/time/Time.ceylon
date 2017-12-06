/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
import ceylon.time.base { ReadableTime, TimeBehavior, h=hours, min=minutes, sec=seconds, ms=milliseconds, ReadableTimePeriod }
import ceylon.time.internal { TimeOfDay }

"""Time of day like _6pm_ or _8.30am_.

   This type contains only information about an abstract _time of day_ without 
   referencing any date or timezone.

   You use Time to specify something that has to occur on a specific time of day
   like _"lunch hour starts at 1pm"_ or _"shop opens at 10am"_.
   """
shared interface Time
        satisfies ReadableTime 
                & TimeBehavior<Time>
                & Comparable<Time>
                & Ordinal<Time> & Enumerable<Time> {

    "Adds a period of time to this time of day value.
     
     Result of this operation is another time of day,
     wrapping around 12 a.m. (midnight) if necessary.
     "
    shared formal Time plus(ReadableTimePeriod period);

    "Subtracts a period of time to this time of day value.
     
     Result of this operation is another time of day,
     wrapping around 12 a.m. (midnight) if necessary.
     "
    shared formal Time minus(ReadableTimePeriod period);

    "Returns the period between this and the given time.
     If this time is before the given time then return zero period."
    shared formal Period periodFrom( Time start );

    "Returns the period between this and the given time.
     If this time is after the given time then return zero period."
    shared formal Period periodTo( Time end );

    "Returns the [[TimeRange]] between this and given Time."
    shared formal TimeRange rangeTo( Time other );
    
    "Two `Time`s are considered equals if they the same _milliseconds of day_."
    shared actual default Boolean equals( Object other ) {
        if ( is Time other ) {
            return millisecondsOfDay == other.millisecondsOfDay;
        }
        return false;
    }
    
    "Implementation compatible with [[equals]] method.\n
     This implementation respect the constraint that if `x==y` then `x.hash==y.hash`."
    shared actual Integer hash {
        return millisecondsOfDay.hash;
    }
    
}

"Creates new instance of [[Time]]."
shared Time time(hours, minutes, seconds=0, milliseconds=0) {

    "Hours of the day (0..23)."
    Integer hours;

    "Minutes of the hour (0..59)."
    Integer minutes;

    "Seconds of the minute (0..59)."
    Integer seconds;

    "Milliseconds of the second (0..999)."
    Integer milliseconds;

    "Hours value should be between 0 and 23."
    assert( 0 <= hours < h.perDay );

    "Minutes value should be between 0 and 59."
    assert( 0 <= minutes < min.perHour );

    "Seconds value should be between 0 and 59."
    assert( 0 <= seconds < sec.perMinute );

    "Milliseconds value should be between 0 and 999."
    assert( 0 <= milliseconds < ms.perSecond );

    value hh = hours * ms.perHour;
    value mm = minutes * ms.perMinute;
    value ss = seconds * ms.perSecond;

    return TimeOfDay( hh + mm + ss + milliseconds );
}
