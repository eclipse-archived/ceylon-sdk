/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
import ceylon.time.base { days, ms=milliseconds, years }
import ceylon.time.internal.math { floor, fdiv=floorDiv, mod=floorMod }

"Converts _Rata Die_ day number to a fixed date value.

 _Rata Die_ is fixed at Monday, January 1st, 1. (Gregorian)."
shared Integer rd( Integer t ) {
    value epoch = 0; // origin of all calculations
    return t - epoch;
}

"Common properties of _Unix time_."
shared object unixTime {

    "Fixed date value of the _Unix time_ epoch (1970-01-01)."
    shared Integer epoch => gregorian.fixedFrom([1970, 1, 1]);

    "Returns a _fixed date_ from the _unix time_ value."
    shared Integer fixedFromTime(Integer time) {
        return fdiv(time, ms.perDay) + epoch;
    }

    "Return milliseconds elapsed from 1970-01-01 00:00:00."
    shared Integer timeFromFixed( Integer date ) {
        return (date - epoch) * ms.perDay;
    }

    "Returns _time of day_ in milliseconds for the specified _unix time_ value."
    shared Integer timeOfDay( Integer time ) {
        return mod(time, ms.perDay);
    }
}

"Generic base interface of a _calendar system_.
 Chronology serves as a computational backend to 
 a Date representation of the same calendar system."
shared interface Chronology<Fields>
       given Fields satisfies Anything[] {

    "Epoch is the offset of the _fixed date_ day number that defines 
     the beginning of the calendar."
    shared formal Integer epoch;

    "Converts date tuple of this calendar system to an equivalent _fixed date_
     representation of the day of era."
    shared formal Integer fixedFrom( Fields date );

    "Converts a _fixed day_ number to a calendar date tuple."
    shared formal Fields dateFrom( Integer fixed );

    "Validate the given date."
    shared formal void checkDate( Fields date );

}

"An interface for calendar system that defines leap year rules.
 
 *Note:* This interface is meant to convey a Calendar that has some sort of leap year syntax."
shared interface LeapYear<Self, Fields> of Self
       satisfies Chronology<Fields>
       given Self satisfies Chronology<Fields>
       given Fields satisfies Anything[] {

    "Returns true if the specified year is a leap year according to the leap year rules of the given chronology."
    shared formal Boolean leapYear( Integer leapYear );
}

"Base class for a gregorian calendar chronology."
abstract shared class GregorianCalendar() of gregorian
         satisfies Chronology<[Integer, Integer, Integer]>
                 & LeapYear<GregorianCalendar, [Integer, Integer, Integer]> {}

"Represents the implementation of all calculations for
 the rules based on Gregorian Calendar."
shared object gregorian extends GregorianCalendar() {

    "Epoch of the gregorian calendar."
    shared actual Integer epoch = rd(1);

    shared Integer january = 1;
    shared Integer february = 2;
    shared Integer march = 3;
    shared Integer april = 4;
    shared Integer may = 5;
    shared Integer june = 6;
    shared Integer july = 7;
    shared Integer august = 8;
    shared Integer september = 9;
    shared Integer october = 10;
    shared Integer november = 11;
    shared Integer december = 12;

    "Gregorian leap year rule states that every fourth year
     is a leap year except century years not divisible by 400."
    shared actual Boolean leapYear(Integer year) {
        return (year % 100 == 0) then year % 400 == 0
                                 else year % 4 == 0;
    }

    "Return the _day of era_ from a given date."
    Integer fixed(Integer year, Integer month, Integer day) {
        return epoch - 1 + 365 * (year - 1) + floor((year - 1) / 4.0)
               - floor((year - 1) / 100.0) + floor((year - 1) / 400.0)
               + floor((367 * month - 362) / 12.0)
               + ((month > 2) then (leapYear(year) then -1 else -2) else 0)
               + day;
    }

    "Return the _day of era_ from a given date."
    shared actual Integer fixedFrom([Integer, Integer, Integer] date) {
        return fixed(date[0], date[1], date[2]);
    }

    "Assert that specified date has it conjunction of year, month and day as valid gregorian values."
    shared actual void checkDate([Integer, Integer, Integer] date) {
        "Invalid year value"
        assert(years.minimum <= date[0] && date[0] <= years.maximum);

        "Invalid date value"
        assert( date == dateFrom( fixedFrom(date) ) );
    }

    "Returns fixed date value of the first day of the gregorian year."
    shared Integer newYear(Integer year){
        return fixed(year, january, 1);
    }

    "Returns fixed date value of the last day of the gregorian year."
    shared Integer yearEnd(Integer year){
        return fixed(year, december, 31);
    }

    "Returns a gregorian year number of the fixed date value."
    shared Integer yearFrom(Integer fixed) {
        value d0 = fixed - epoch;
        value n400 = fdiv(d0, days.perFourCenturies);
        value d1 = mod(d0, days.perFourCenturies);
        value n100 = fdiv(d1, days.perCentury);
        value d2 = mod(d1, days.perCentury);
        value n4 = fdiv(d2, days.inFourYears);
        value d3 = mod(d2, days.inFourYears);
        value n1 = fdiv(d3, days.perYear);
        value year = 400 * n400 + 100 * n100 + 4 * n4 + n1;
        return (n100 == 4 || n1 == 4) then year else year + 1;
    }

    "Converts the fixed date value to an equivalent gregorian date."
    shared actual [Integer, Integer, Integer] dateFrom(Integer date) {
        value year = yearFrom(date);
        value priorDays = date - newYear(year);
        value correction = (date < fixed(year, march, 1)) 
                then 0 else (leapYear(year) then 1 else 2);
        value month = fdiv(12 * (priorDays + correction) + 373, 367);
        value day = 1 + date - fixed(year, month, 1);
        return [year, month, day];
    }

    "Returns the month number of the gregorian calendar from the fixed date value."
    shared Integer monthFrom(Integer date){
        return dateFrom(date)[1];
    }

    "Returns day of month value of the fixed date value."
    shared Integer dayFrom(Integer date){
        return dateFrom(date)[2];
    }

    "Returns _day of week_ value for the specified fixed date value."
    shared Integer dayOfWeekFrom(Integer date) {
        return mod(date, 7);
    }

}
