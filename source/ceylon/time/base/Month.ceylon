/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
import ceylon.time.chronology { gregorian }
import ceylon.time.internal.math { mod=floorMod, fdiv=floorDiv }

"A month in a Gregorian or Julian calendar system."
shared abstract class Month(integer)
       of january | february | march | april | may | june | july 
        | august | september | october | november | december
       satisfies Ordinal<Month> & Comparable<Month> & Enumerable<Month>{

    "Ordinal number of the month of year.
        Where:\n
        january  = 1\n
        february = 2\n
        ...\n
        december = 12"
    shared Integer integer;

    "Returns number of days in this month."
    shared default Integer numberOfDays(Boolean leapYear = false) {
        switch(this)
        case (february) { return leapYear then 29 else 28; }
        case (april | june | september | november) { return 30; } 
        case (january | march | may | july | august | october | december) { return 31; }
    }

    "Returns the _day of year_ value for first of this month."
    shared default Integer firstDayOfYear(Boolean leapYear = false){
        assert(exists day = firstDayOfMonth[this.integer-1]);
        if (leapYear && this > february){
            return day + 1;
        }
        return day;
    }

    "Compares ordinal numbers of two instances of `Month`."
    shared actual Comparison compare(Month other)
        => integer.compare(other.integer);

    "Returns month of year that comes specified number of months after this month."
    shared Month plusMonths(Integer number)
        => (number == 0) then this else add(number).month;

    "Returns month of year that comes specified number of months before this month."
    shared Month minusMonths(Integer number) 
        => (number == 0) then this else add(-number).month;

    "A result of adding or subtracting a month to another amount."
    shared class Overflow(month, years){
        "New month value."
        shared Month month;

        "Number of years overflowed by calculation."
        shared Integer years;
    }

    "Adds number of months to this month and returns the result 
     as new month value and number of times the operation overflowed."
    shared Overflow add(Integer numberOfMonths){
        value next = (integer - 1 + numberOfMonths);
        value nextMonth = mod(next, months.perYear);
        assert (exists month = months.all[nextMonth]);

        Integer years = fdiv(next, 12);
        return Overflow(month, years); 
    }
    
    "Returns the offset of the other _month_ compared to this.
     
     This will always return positive integer such that given any
     two months `a` and `b`, the following is always true:
     
        assert(0 <= a.offset(b) <= 11);
     "
    shared actual default Integer offset(Month other)
            => let (diff = integer - other.integer)
               if (diff<0) then diff + 12 else diff;
    
    "returns `n`-th neighbour of this _day of week_.
     
     For example:
     
         assert(january.neighbour(0)  == january);
         assert(january.neighbour(1)  == february);
         assert(january.neighbour(-1) == december);
     "
    shared actual Month neighbour(Integer offset) => add(offset).month;

}

"Table of _day of year_ values for the first day of each month."
Integer[] firstDayOfMonth = [1, 32, 60, 91, 121, 152, 182, 213, 244, 274, 305, 335];

"Returns month of year specified by the input argument.
 
 If input is an Integer, this method returns a month according to the integer 
 value of the [[Month]] (i.e. 1=[[january]], 2=[[february]], ... 12=[[december]])
 Any invalid values will throw an [[AssertionError]].
 
 If the input value is a [[Month]], the input value is returned as is."
shared Month monthOf(Integer|Month month){
    switch (month)
    case (Month) { return month; }
    case (Integer) {
        "Invalid month."
        assert ( january.integer <= month <= december.integer );
        assert ( exists m = months.all[month-1] );
        return m;
    }
}

"January. The first month of a gregorian calendar system."
shared object january extends Month(gregorian.january) {
    shared actual String string = "january";
    shared actual Month predecessor => december;
    shared actual Month successor => february;
}

"February. The second month of a gregorian calendar system."
shared object february extends Month(gregorian.february) {
    shared actual String string = "february";
    shared actual Month predecessor => january;
    shared actual Month successor => march;
}

"March. The third month of a gregorian calendar system."
shared object march extends Month(gregorian.march) {
    shared actual String string = "march";
    shared actual Month predecessor => february;
    shared actual Month successor => april;
}

"April. The fourth month of a gregorian calendar system."
shared object april extends Month(gregorian.april) {
    shared actual String string = "april";
    shared actual Month predecessor => march;
    shared actual Month successor => may;
}

"May. The fifth month of a gregorian calendar system."
shared object may extends Month(gregorian.may) {
    shared actual String string = "may";
    shared actual Month predecessor => april;
    shared actual Month successor => june;
}

"June. The sixth month of a gregorian calendar system."
shared object june extends Month(gregorian.june) {
    shared actual String string = "june";
    shared actual Month predecessor => may;
    shared actual Month successor => july;
}

"July. The seventh month of a gregorian calendar system."
shared object july extends Month(gregorian.july) {
    shared actual String string = "july";
    shared actual Month predecessor => june;
    shared actual Month successor => august;
}

"August. The eighth month of a gregorian calendar system."
shared object august extends Month(gregorian.august) {
    shared actual String string = "august";
    shared actual Month predecessor => july;
    shared actual Month successor => september;
}

"September. The ninth month of a gregorian calendar system."
shared object september extends Month(gregorian.september) {
    shared actual String string = "september";
    shared actual Month predecessor => august;
    shared actual Month successor => october;
}

"October. The tenth month of a gregorian calendar system."
shared object october extends Month(gregorian.october) {
    shared actual String string = "october";
    shared actual Month predecessor => september;
    shared actual Month successor => november;
}

"November. The eleventh month of a gregorian calendar system."
shared object november extends Month(gregorian.november) {
    shared actual String string = "november";
    shared actual Month predecessor => october;
    shared actual Month successor => december;
}

"December. The twelfth (last) month of a gregorian calendar system."
shared object december extends Month(gregorian.december) {
    shared actual String string = "december";
    shared actual Month predecessor => november;
    shared actual Month successor => january;
}
