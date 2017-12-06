/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
"""A day of week, such as 'tuesday'.

   This class satisfies `Enumerable<DayOfWeek>`, which means that you can
   create ranges of days of week:

   E.g:
       value week = monday..sunday;
       value weekend = saturday..sunday;

   Note that ranges created this way are always in _increasing_ order, wrapping
   once last day of week is reached. This means that when you create a range of `tuesday..monday`,
   this is equivalent to the following sequence: `[tuesday, wednesday, thursday, friday, saturday, sunday, monday]`

   In order to get the reverse order range, you can use either span operator:
       value reverseDaysOfWeek = tuesday:-1;

   or explicitly reverse the order of the range like this:
       calue reverseDaysOfWeek = (monday..tuesday).reverse();

   """
shared abstract class DayOfWeek(integer)
       of monday | tuesday | wednesday | thursday | friday | saturday | sunday
       satisfies Ordinal<DayOfWeek> & Comparable<DayOfWeek> & Enumerable<DayOfWeek> {

    "Numeric value of the DayOfWeek."
    shared Integer integer;

    "Returns a day of week that comes specified number of days after this DayOfWeek."
    shared DayOfWeek plusDays(Integer number){
        if (-7 < number < 7) {
            value wd = (7 + integer + number) % 7;
            assert (exists dow = weekdays[wd]);
            return dow;
        }
        else {
            return plusDays(number % 7);
        }
    }

    "Returns a day of week that comes number of days before this DayOfWeek."
    shared DayOfWeek minusDays(Integer number) => plusDays(-number);

    "Compare days of week."
    shared actual Comparison compare(DayOfWeek other) => this.integer <=> other.integer;

    "Returns the offset of the other _day of week_ compared to this.

     This will always return positive integer such that given any
     two days of week `a` and `b`, the following is always true:

         assert(0 <= a.offset(b) <= 6);
     "
    shared actual default Integer offset(DayOfWeek other)
            => let (diff = integer - other.integer)
                    if (diff<0) then diff+7 else diff;

    "returns `n`-th neighbour of this _day of week_.

     For example:

         assert(sunday.neighbour(0)  == sunday);
         assert(sunday.neighbour(1)  == monday);
         assert(sunday.neighbour(-1) == saturday);
     "
    shared actual DayOfWeek neighbour(Integer offset) => plusDays(offset);

}

"List of all available weekdays."
shared DayOfWeek[] weekdays = [ sunday, monday, tuesday, wednesday, thursday, friday, saturday ];

"Returns [[DayOfWeek]] from the input."
shared DayOfWeek dayOfWeek(Integer|DayOfWeek dayOfWeek){
    switch(dayOfWeek)
    case (DayOfWeek) { return dayOfWeek; }
    case (Integer) {
        assert (0 <= dayOfWeek < 7);
        assert (exists DayOfWeek dow = weekdays[dayOfWeek]);
        return dow;
    }
}

"Parses a string into a DayOfWeek.

 Expected inputs and outputs are:
 * \"sunday\"    results in [[sunday]]
 * \"monday\"    results in [[monday]]
 * \"tuesday\"   results in [[tuesday]]
 * \"wednesday\" results in [[wednesday]]
 * \"thursday\"  results in [[thursday]]
 * \"friday\"    results in [[friday]]
 * \"saturday\"  results in [[saturday]]"
shared DayOfWeek? parseDayOfWeek(String dayOfWeek){
    value wd = dayOfWeek.lowercased;
    for (dow in weekdays) {
        if (dow.string.lowercased == wd) {
            return dow;
        }
    }

    return null;
}

"_Sunday_ is the day of the week that follows Saturday and precedes Monday."
shared object sunday extends DayOfWeek(0) {
    shared actual String string = "sunday";
    shared actual DayOfWeek predecessor => saturday;
    shared actual DayOfWeek successor => monday;
}

"_Monday_ is the day of the week that follows Sunday and precedes Tuesday."
shared object monday extends DayOfWeek(1) {
    shared actual String string = "monday";
    shared actual DayOfWeek predecessor => sunday;
    shared actual DayOfWeek successor => tuesday;
}

"_Tuesday_ is the day of the week that follows Monday and precedes Wednesday."
shared object tuesday extends DayOfWeek(2) {
    shared actual String string = "tuesday";
    shared actual DayOfWeek predecessor => monday;
    shared actual DayOfWeek successor => wednesday;
}

"_Wednesday_ is the day of the week that follows Tuesday and precedes Thursday."
shared object wednesday extends DayOfWeek(3) {
    shared actual String string = "wednesday";
    shared actual DayOfWeek predecessor => tuesday;
    shared actual DayOfWeek successor => thursday;
}

"_Thursday_ is the day of the week that follows Wednesday and precedes Friday."
shared object thursday extends DayOfWeek(4) {
    shared actual String string = "thursday";
    shared actual DayOfWeek predecessor => wednesday;
    shared actual DayOfWeek successor => friday;
}

"_Friday_ is the day of the week that follows Thursday and precedes Saturday."
shared object friday extends DayOfWeek(5) {
    shared actual String string = "friday";
    shared actual DayOfWeek predecessor => thursday;
    shared actual DayOfWeek successor => saturday;
}

"_Saturday_ is the day of the week that follows Friday and precedes Sunday."
shared object saturday extends DayOfWeek(6) {
    shared actual String string = "saturday";
    shared actual DayOfWeek predecessor => friday;
    shared actual DayOfWeek successor => sunday;
}
