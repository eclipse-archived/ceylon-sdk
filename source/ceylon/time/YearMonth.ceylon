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
    YearBehavior,
    MonthBehavior,
    ReadableYear,
    ReadableMonth,
    Month
}
import ceylon.time.internal {
    gregorianYearMonth
}

"An interface for year and month objects representation in the ISO-8601 calendar system.
 
 A YearMonth is often viewed as pair of year-month values. 
 "
shared interface YearMonth
        satisfies ReadableYear & ReadableMonth 
                & YearBehavior<YearMonth> & MonthBehavior<YearMonth>
                & Ordinal<YearMonth> 
                & Comparable<YearMonth> 
                & Enumerable<YearMonth> {

    shared actual Boolean equals(Object that) {
        if (is YearMonth that) {
            return year==that.year && 
                month==that.month;
        }
        else {
            return false;
        }
    }
    
    shared actual Integer hash {
        variable value hash = 1;
        hash = 31*hash + year;
        hash = 31*hash + month.hash;
        return hash;
    }
    
}

"Returns a year and month representation based on the specified values."
shared YearMonth yearMonth(Integer year, Integer|Month month) => gregorianYearMonth(year, month);