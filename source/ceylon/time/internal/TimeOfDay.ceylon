/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
import ceylon.time { Time, time, Period, TimeRange }
import ceylon.time.base { ms=milliseconds, sec=seconds, ReadableTimePeriod }
import ceylon.time.internal.math { floorMod }

"Basic implementation of [[Time]] interface, representing an abstract 
 _time of day_ such as _10am_ or _3.20pm_ with a precision of milliseconds."
shared serializable class TimeOfDay(millisecondsOfDay) extends Object() satisfies Time {

    "Number of milliseconds since last midnight."
    shared actual Integer millisecondsOfDay;

    "Number of full hours elapsed since last midnight."
    shared actual Integer hours => millisecondsOfDay / ms.perHour;

    "Number of minutes since last full hour."
    shared actual Integer minutes => floorMod(millisecondsOfDay, ms.perHour) / ms.perMinute;

    "Number of seconds since last minute."
    shared actual Integer seconds => floorMod(millisecondsOfDay, ms.perMinute) / ms.perSecond;

    "Number of milliseconds since last full second."
    shared actual Integer milliseconds => floorMod(millisecondsOfDay, ms.perSecond);

    "Number of seconds since last midnight."
    shared actual Integer secondsOfDay => millisecondsOfDay / ms.perSecond;

    "Number of minutes since last midnight."
    shared actual Integer minutesOfDay => secondsOfDay / sec.perMinute;

    "Compare two instances of _time of day_."
    shared actual Comparison compare(Time other) {
        return millisecondsOfDay <=> other.millisecondsOfDay;
    }

    "For predecessor its used the lowest unit of time, this way we can benefit
     from maximum precision. In this case the predecessor is the current value minus 1 millisecond."
    shared actual Time predecessor => minusMilliseconds(1);

    "For successor its used the lowest unit of time, this way we can benefit
     from maximum precision. In this case the successor is the current value plus 1 millisecond."
    shared actual Time successor => plusMilliseconds(1);

    "Returns ISO-8601 formatted String representation of this _time of day_.\n
     Reference: https://en.wikipedia.org/wiki/ISO_8601#Times"
    shared actual String string 
            => "``hours.string.padLeading(2, '0')``:``minutes.string.padLeading(2, '0')``:``seconds.string.padLeading(2, '0')``.``milliseconds.string.padLeading(3, '0')``";

    "Adds specified number of hours to this time of day
     and returns the result as new time of day."
    shared actual Time plusHours(Integer hours) => plusMilliseconds( hours * ms.perHour );

    "Subtracts specified number of hours from this time of day 
     and returns the result as new time of day."
    shared actual Time minusHours(Integer hours) => minusMilliseconds( hours * ms.perHour );

    "Adds specified number of minutes to this time of day 
     and returns the result as new  time of day."
    shared actual Time plusMinutes(Integer minutes) => plusMilliseconds( minutes * ms.perMinute );

    "Subtracts specified number of minutes from this time of day 
     and returns the result as new  time of day."
    shared actual Time minusMinutes(Integer minutes) => minusMilliseconds( minutes * ms.perMinute );

    "Adds specified number of seconds to this time of day
     and returns the result as new time of day."
    shared actual Time plusSeconds(Integer seconds) => plusMilliseconds( seconds * ms.perSecond );

    "Subtracts specified number of seconds from this time of day
     and returns the result as new time of day."
    shared actual Time minusSeconds(Integer seconds) => minusMilliseconds( seconds * ms.perSecond );

    "Adds specified number of milliseconds to this time of day
     and returns the result as new time of day."
    shared actual Time plusMilliseconds(Integer milliseconds) {
        if (milliseconds == 0) {
            return this;
        }

        value newMillisOfDay = floorMod(millisecondsOfDay + milliseconds, ms.perDay);
        return newMillisOfDay == this.millisecondsOfDay
               then this else TimeOfDay(newMillisOfDay);
    }

    "Subtracts specified number of milliseconds from this time of day
     and returns the result as new time of day."
    shared actual Time minusMilliseconds(Integer milliseconds) => plusMilliseconds( -milliseconds );

    "Adds specified time period to this time of day
     and returns the result as new time of day."
    shared actual Time plus(ReadableTimePeriod period){
        value totalMillis = millisecondsOfDay
                          + period.milliseconds
                          + period.seconds * ms.perSecond
                          + period.minutes * ms.perMinute
                          + period.hours * ms.perHour;

        value time = floorMod(totalMillis, ms.perDay);
        return (time == this.millisecondsOfDay) 
               then this else TimeOfDay(time);
    }

    "Subtracts specified time period from this time of day
     and returns the result as new time of day."
    shared actual Time minus(ReadableTimePeriod period) {
        value totalMillis = millisecondsOfDay
                          - period.milliseconds
                          - period.seconds * ms.perSecond
                          - period.minutes * ms.perMinute
                          - period.hours * ms.perHour;

        value time = floorMod(totalMillis, ms.perDay);
        return (time == this.millisecondsOfDay) 
               then this else TimeOfDay(time);
    }

    "Returns a copy of this Time replacing the _hours_ value.\n
     **Note:** It should be a valid _hour_."
    shared actual Time withHours(Integer hours) {
        if (this.hours == hours) {
            return this;
        }
        return time(hours, minutes, seconds, milliseconds);
    }

    "Returns a copy of this Time replacing the _minutes_ value.\n
     **Note:** It should be a valid _minute_."
    shared actual Time withMinutes(Integer minutes) {
        if (this.minutes == minutes) {
            return this;
        }

        return time(hours, minutes, seconds, milliseconds);
    }

    "Returns a copy of this Time replacing the _seconds_ value.\n
     **Note:** It should be a valid _second_."
    shared actual Time withSeconds(Integer seconds) {
        if (this.seconds == seconds) {
            return this;
        }

        return time(hours, minutes, seconds, milliseconds );
    }

    "Returns a copy of this Time replacing the _milliseconds_ value.\n
     **Note:** It should be a valid _millisecond_."
    shared actual Time withMilliseconds(Integer milliseconds) {
        if (this.milliseconds == milliseconds) {
            return this;
        }

        return time(hours, minutes, seconds, milliseconds);
    }

    "Returns the period between this and the given time.\n
     If this time is before the given time then return zero period."
    shared actual Period periodFrom(Time start) {
        value from = this < start then this else start;
        value to = this < start then start else this;

        variable value total = to.millisecondsOfDay - from.millisecondsOfDay;
        value hh = total / ms.perHour;
        total =  total % ms.perHour;

        value mm = total / ms.perMinute;
        total =  total % ms.perMinute;

        value ss = total / ms.perSecond;

        Boolean positive = start < this; 
        return Period {
            hours = positive then hh else -hh;
            minutes = positive then mm else -mm;
            seconds = positive then ss else -ss;
            milliseconds = positive then total % ms.perSecond else -(total % ms.perSecond);
        }; 
    }

    "Returns the period between this and the given time.\n
     If this time is after the given time then return zero period."
    shared actual Period periodTo(Time end) => end.periodFrom(this); 

    "Returns the [[TimeRange]] between this and given Time."
    shared actual TimeRange rangeTo( Time other ) => TimeRange(this, other);

    shared actual Time neighbour(Integer offset) => plusMilliseconds(offset);

    shared actual Integer offset(Time other) => millisecondsOfDay - other.millisecondsOfDay;
    
}
