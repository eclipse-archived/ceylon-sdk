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
    DayOfWeek,
    Month
}
import ceylon.time {
    Date,
    newDate = date
}
import ceylon.time.chronology {
	gregorian
}

"Alias to represent a specific day."
shared alias DayOfMonth => Integer;

"Rule describing the day a rule applieds to."
shared abstract class OnDay() of OnFixedDay | OnFirstOfMonth | OnLastOfMonth {
    
    shared formal Date date(Year year, Month month);
    
}

"Represents a fixed day of month.
 
 For example, a value `3` on February, 2004, means exactly _February 3. 2004_.
 "
shared class OnFixedDay(fixedDate) extends OnDay() {
    shared DayOfMonth fixedDate;
    
    shared actual Boolean equals(Object other) {
        if(is OnFixedDay other) {
            return fixedDate == other.fixedDate;
        }
        return false;
    }
    
    shared actual Date date(Year year, Month month) {
        return newDate(year, month, fixedDate);
    }
    
}

"Represents a day equal to or higher than a day of week.
 
 For example, given the rule `Sun>=1` it can mean one of the following:
 either _June 1. 2014_ or _June 7. 2015_ (or anything in between) 
 depending on the year and month of the overall rule.
 "
shared class OnFirstOfMonth(dayOfWeek, onDateOrAfter) extends OnDay() {
    
    shared DayOfWeek dayOfWeek;
    shared DayOfMonth onDateOrAfter;
    
    shared actual Boolean equals(Object other) {
        if(is OnFirstOfMonth other) {
            return onDateOrAfter == other.onDateOrAfter
                && dayOfWeek == other.dayOfWeek;
        }
        return false;
    }
    
    shared actual Date date(Year year, Month month) {
        value initial = newDate(year, month, onDateOrAfter);
        
        "onDateOrAfter should always be a valid day for the month"
        assert(exists result = initial.rangeTo(initial.withDay(month.numberOfDays(initial.leapYear))).find(matchesDayOfWeekAndDay));
        return result;
    }
    
    Boolean matchesDayOfWeekAndDay(Date dateTime) {
        return dateTime.day >= onDateOrAfter
            && dateTime.dayOfWeek == dayOfWeek;
    }
    
}

"Represents the last day of week, for example:
 * `lastSun`
 * `lastSat`
 
 For example, `lastSun` of February 2015 is _February 22, 2015_"
shared class OnLastOfMonth(dayOfWeek) extends OnDay() {
    
    shared DayOfWeek dayOfWeek;
    
    shared actual Boolean equals(Object other) {
        if(is OnLastOfMonth other) {
            return dayOfWeek == other.dayOfWeek;
        }
        return false;
    }
    shared actual Date date(Year year, Month month) {
        value initial = newDate(year, month, month.numberOfDays(gregorian.leapYear(year)));
        
        Date? result =
                initial.rangeTo(initial.withDay(1))
                .find((Date element) => element.dayOfWeek == dayOfWeek);
        assert(exists result);
        
        return result;
    }

}