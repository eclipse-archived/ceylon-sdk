import ceylon.time.math { floorDiv }

"Common properties and constraints of _year_ unit"
shared object years {

    "The minimum supported year for instances of `Date`, -283_457."
    // the least that can be represented by an Instant
    shared Integer minimum = -283_456; 

    "The maximum supported year for instances of `Date`, 999,999,999."
    // the most that can be represented by an Instant
    shared Integer maximum = 287_396;
}

"Common properties and constraints of months"
shared object months {

    "Ordered list of all months of Gregorian and Julian calendar system from January to December"
    shared Month[] all = [january, february, march, april, may, june, july, august, september, october, november, december];

    "Number of months per year"
    shared Integer perYear = all.size;

}

"Common properties and constraints of _day_ unit"
shared object days {

    "Returns the number of days per year"
    shared Integer perYear(Boolean leapYear=false) => leapYear then 366 else 365;

    "Returns the number of days per month"
    shared Integer perMonth(Month month, Boolean leapYear=false) => month.numberOfDays(leapYear);

    "Returns the number of days from the start of the year to the first of the month"
    shared Integer toMonth(Month month, Boolean leapYear=false) => month.fisrtDayOfYear(leapYear) - 1;

    shared DayOfWeek[] ofWeek = [sunday, monday, tuesday, wednesday, thursday, friday, saturday];

    "Number of days per week (7)"
    shared Integer perWeek = ofWeek.size;

    "The number of days in a 400 year cycle."
    shared Integer perCycle = 146097;

    "The number of days in a 400 year cycle."
    shared Integer perFourCenturies => perCycle;

    "The number of days from year zero to year 1970.
     There are five 400 year cycles from year zero to 2000.
     There are 7 leap years from 1970 to 2000."
    shared Integer toEpoch => (perCycle * 5) - (30 * 365 + 7);

    "Number of days in four years"
    shared Integer inFourYears = 1461;

    "Number of of per century (100 years)"
    shared Integer perCentury = 36524;

    "Returns number of days from the number of milliseconds."
    shared Integer fromMillis(Integer millis = 0) => floorDiv(millis, milliseconds.perDay);

}

"Common properties of _hour_ time unit"
shared object hours {

    "Number of hours per day"
    shared Integer perDay = 24;

}

"Common properties of _minute_ time unit"
shared object minutes {

    "Number of minutes per hour"
    shared Integer perHour = 60;

    "Number of minutes per day"
    shared Integer perDay => hours.perDay * minutes.perHour;
}

"Common properties of _second_ time unit"
shared object seconds {

    "Number of seconds per minute"
    shared Integer perMinute = 60;

    "Number of seconds per hour"
    shared Integer perHour => minutes.perHour * seconds.perMinute;

    "Number of seconds per day"
    shared Integer perDay => hours.perDay * seconds.perHour;
}

"Common properties of _millisecond_ time unit"
shared object milliseconds {

    "Number of milliseconds per second (1000)"
    shared Integer perSecond = 1000;

    "Milliseconds per minute (60000)"
    shared Integer perMinute => seconds.perMinute * milliseconds.perSecond;

    "Number of milliseconds per hour"
    shared Integer perHour => minutes.perHour * milliseconds.perMinute;

    "Number of milliseconds per day"
    shared Integer perDay =>  hours.perDay * milliseconds.perHour;
}
