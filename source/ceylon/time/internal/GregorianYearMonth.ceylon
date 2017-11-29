/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
import ceylon.time.base {
    Month,
    monthOf
}
import ceylon.time {
    YearMonth
}
import ceylon.time.chronology {
    impl=gregorian
}

shared serializable class GregorianYearMonth(year, month) extends Object() satisfies YearMonth {

    shared actual Integer year;

    shared actual Month month;

    shared actual Comparison compare(YearMonth other) => 
            switch(year <=> other.year) 
    case(equal) month <=> other.month
    case(smaller) smaller
    case(larger) larger;

    shared actual Boolean leapYear => impl.leapYear(year);

    shared actual YearMonth plusMonths(Integer months) {
        if ( months == 0 ) {
            return this;
        }

        value o = month.add(months);
        value newYear = year + o.years;

        return GregorianYearMonth(newYear, o.month);
    }

    shared actual YearMonth minusMonths(Integer months) => plusMonths(-months);

    shared actual YearMonth withMonth(Month month) {
        if(this.month == month) {
            return this;
        }
        return GregorianYearMonth(year, month);
    }

    shared actual YearMonth plusYears(Integer years) {
        if ( years == 0 ) {
            return this;
        }
        return GregorianYearMonth(year + years, month);
    }

    shared actual YearMonth minusYears(Integer years) => plusYears(-years);

    shared actual YearMonth withYear(Integer year) {
        if( this.year == year ) {
            return this;
        }
        return GregorianYearMonth(year, month);
    }

    shared actual YearMonth neighbour(Integer offset) => plusMonths(offset);

    shared actual Integer offset(YearMonth other) => countInMonths(this) - countInMonths(other);

    Integer countInMonths(YearMonth yearMonth) => yearMonth.year * 12 + yearMonth.month.integer;

    "Returns ISO-8601 formatted String representation of this year and month moment.\n
     Reference: https://en.wikipedia.org/wiki/ISO_8601"
    shared actual String string 
            => "``year.string.padLeading(4, '0')``-``month.integer.string.padLeading(2, '0')``";
}

"Returns a gregorian year and month calendar according to the specified year and month values."
shared YearMonth gregorianYearMonth(year, month) {
    "Year number of the date"
    Integer year;

    "Month of the year"
    Integer|Month month; 

    impl.checkDate([year, monthOf(month).integer, 1]);
    return GregorianYearMonth(year, monthOf(month));
}
