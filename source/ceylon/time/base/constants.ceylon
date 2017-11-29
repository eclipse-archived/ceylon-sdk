/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
import ceylon.time.internal.math { floorDiv }

"Represents units of Date"
shared interface UnitOfDate of UnitOfYear | UnitOfMonth | UnitOfDay{}
shared abstract class UnitOfYear()  of years  satisfies UnitOfDate{}
shared abstract class UnitOfMonth() of months satisfies UnitOfDate{}
shared abstract class UnitOfDay()   of days   satisfies UnitOfDate{}

"Represents units of Time"
shared interface UnitOfTime of UnitOfHour | UnitOfMinute | UnitOfSecond | UnitOfMillisecond{}
shared abstract class UnitOfHour()        of hours        satisfies UnitOfTime{}
shared abstract class UnitOfMinute()      of minutes      satisfies UnitOfTime{}
shared abstract class UnitOfSecond()      of seconds      satisfies UnitOfTime{}
shared abstract class UnitOfMillisecond() of milliseconds satisfies UnitOfTime{}

"Common properties and constraints of _year_ unit."
shared object years extends UnitOfYear() {

    "The minimum supported year for instances of `Date`, -283_457."
    // the least that can be represented by an Instant
    shared Integer minimum = -283_456; 

    "The maximum supported year for instances of `Date`, 999,999,999."
    // the most that can be represented by an Instant
    shared Integer maximum = 287_396;
}

"Common properties and constraints of months."
shared object months extends UnitOfMonth() {

    "Ordered list of all months of Gregorian and Julian calendar system from January to December."
    shared Month[] all = `Month`.caseValues;

    "Number of months per year."
    shared Integer perYear = 12;

    "Returns month with the specified ordinal number or `null` if provided number is not a valid month number."
    shared Month? valueOf(Integer number) => all[number - 1];
}

"Common properties and constraints of _day_ unit."
shared object days extends UnitOfDay() {

    "Number of days per normal year."
    shared Integer perYear => 365;

    "Number of days per leap year."
    shared Integer perLeapYear => 366;
    
    "Returns the number of days per month."
    shared Integer perMonth(Month month, Boolean leapYear=false) => month.numberOfDays(leapYear);

    "Returns the number of days from the start of the year to the first of the month."
    shared Integer toMonth(Month month, Boolean leapYear=false) => month.firstDayOfYear(leapYear) - 1;

    shared DayOfWeek[] ofWeek = [sunday, monday, tuesday, wednesday, thursday, friday, saturday];

    "Number of days per week (7)."
    shared Integer perWeek = ofWeek.size;

    "The number of days in a 400 year cycle."
    shared Integer perCycle = 146097;

    "The number of days in a 400 year cycle."
    shared Integer perFourCenturies => perCycle;

    "Number of days in four years."
    shared Integer inFourYears = 1461;

    "Number of of per century (100 years)."
    shared Integer perCentury = 36524;

    "Returns number of days from the number of milliseconds."
    shared Integer fromMilliseconds(Integer millisecondsIn = 0) => floorDiv(millisecondsIn, milliseconds.perDay);

}

"Common properties of _hour_ time unit."
shared object hours extends UnitOfHour() {

    "Number of hours per day."
    shared Integer perDay = 24;

}

"Common properties of _minute_ time unit."
shared object minutes extends UnitOfMinute() {

    "Number of minutes per hour."
    shared Integer perHour = 60;

    "Number of minutes per day."
    shared Integer perDay => hours.perDay * minutes.perHour;
}

"Common properties of _second_ time unit."
shared object seconds extends UnitOfSecond() {

    "Number of seconds per minute."
    shared Integer perMinute = 60;

    "Number of seconds per hour."
    shared Integer perHour => minutes.perHour * seconds.perMinute;

    "Number of seconds per day."
    shared Integer perDay => hours.perDay * seconds.perHour;
}

"Common properties of _millisecond_ time unit."
shared object milliseconds extends UnitOfMillisecond() {

    "Number of milliseconds per second."
    shared Integer perSecond = 1000;

    "Milliseconds per minute."
    shared Integer perMinute => seconds.perMinute * milliseconds.perSecond;

    "Number of milliseconds per hour."
    shared Integer perHour => minutes.perHour * milliseconds.perMinute;

    "Number of milliseconds per day."
    shared Integer perDay =>  hours.perDay * milliseconds.perHour;

}
