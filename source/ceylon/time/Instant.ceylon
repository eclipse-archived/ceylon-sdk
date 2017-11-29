/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
import ceylon.time.base { ReadableInstant }
import ceylon.time.chronology { unixTime }
import ceylon.time.internal { TimeOfDay, GregorianDateTime, GregorianDate, GregorianZonedDateTime }
import ceylon.time.timezone { TimeZone, ZoneDateTime, tz = timeZone }

"Obtains the current instant from the system clock."
shared Instant now(Clock? clock = null) {
    if (exists clock) {
        return clock.instant();
    }
    return systemTime.instant();
}

"A specific instant of time on a continuous time-scale.
 
 An instant represents a single point in time irrespective of 
 any time-zone offsets or geographical locations."
shared serializable class Instant(millisecondsOfEpoch)
    satisfies ReadableInstant & Comparable<Instant> & Enumerable<Instant> {

    "Internal value of an instant as a number of milliseconds since
     1970-01-01T00:00:00.000Z."
    shared actual Integer millisecondsOfEpoch;

    "Adds a period to this instant."
    shared Instant plus(Duration|Period other){
        switch(other)
        case(Duration){
            return Instant(this.millisecondsOfEpoch + other.milliseconds);
        }
        case(Period){
            return dateTime().plus(other).instant();
        }
    }

    "Subtracts a period to this instant."
    shared Instant minus(Duration|Period other){
        switch(other)
        case(Duration){
            return Instant(this.millisecondsOfEpoch - other.milliseconds);
        }
        case(Period){
            return dateTime().minus(other).instant();
        }
    }

    "Compares this instant to the _other_ instant."
    shared actual Comparison compare(Instant other) {
        return this.millisecondsOfEpoch <=> other.millisecondsOfEpoch;
    }

    "Returns this instant as a [[DateTime]] value."
    shared DateTime dateTime( TimeZone timeZone = tz.system ) {
        return  GregorianDateTime( date(timeZone), time(timeZone) );
    }

    "Returns this instant as a [[Date]] value."
    shared Date date( TimeZone timeZone = tz.system ) {
        return GregorianDate( unixTime.fixedFromTime(millisecondsOfEpoch + timeZone.offset(this)) );
    }

    "Returns _time of day_ for this instant."
    shared Time time( TimeZone timeZone = tz.system ) {
        return TimeOfDay( unixTime.timeOfDay(millisecondsOfEpoch + timeZone.offset(this)) );
    }

    "Returns ZoneDateTime value for this instant."
    shared ZoneDateTime zoneDateTime(TimeZone timeZone = tz.system){
        return GregorianZonedDateTime(this, timeZone);
    }

    "Returns duration in milliseconds from this instant to the other instant."
    shared Duration durationTo(Instant other) {
        return Duration(other.millisecondsOfEpoch - this.millisecondsOfEpoch);
    }

    "Returns duration in milliseconds from other instant to this instant."
    shared Duration durationFrom(Instant other) {
        return Duration(this.millisecondsOfEpoch - other.millisecondsOfEpoch);
    }

    "Returns _true_ if given value is same type and milliseconds of epoch."
    shared actual Boolean equals( Object other ) {
        if ( is Instant other ) {
            return millisecondsOfEpoch == other.millisecondsOfEpoch;
        }
        return false;
    }

    "This implementation respect the constraint that if `x==y` then `x.hash==y.hash`."
    shared actual Integer hash {
        return 31 + millisecondsOfEpoch.hash;
    }

    "Returns ISO-8601 formatted String representation of this _time of day_ in UTC.\n
     Reference: [ISO-8601 Time Offsets from UTC](https://en.wikipedia.org/wiki/ISO_8601#Time_offsets_from_UTC)"
    shared actual String string => zoneDateTime(tz.utc).string;

    shared actual Instant neighbour(Integer offset) => Instant(millisecondsOfEpoch+offset);

    shared actual Integer offset(Instant other) => millisecondsOfEpoch - other.millisecondsOfEpoch;

}
