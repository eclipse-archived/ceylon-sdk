/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
"Common behavior of objects representing a period."
shared interface PeriodBehavior<Self> of Self
       satisfies ReadablePeriod 
       given Self satisfies PeriodBehavior<Self>
                             & ReadablePeriod {

    "Returns a copy of this period with the specified amount of years."
    shared formal Self withYears(Integer year);

    "Returns a copy of this period with the specified amount of months."
    shared formal Self withMonths(Integer month);

    "Returns a copy of this period with the specified amount of days."
    shared formal Self withDays(Integer daysOfMonth);

    "Returns a copy of this period with the specified number of years added."
    shared formal Self plusYears(Integer years);

    "Returns a copy of this period with the specified number of months added."
    shared formal Self plusMonths(Integer months);

    "Returns a copy of this period with the specified number of days added."
    shared formal Self plusDays(Integer days);

    "Returns a copy of this period with the specified number of years subtracted."
    shared formal Self minusYears(Integer years);

    "Returns a copy of this period with the specified number of months subtracted."
    shared formal Self minusMonths(Integer months);

    "Returns a copy of this period with the specified number of days subtracted."
    shared formal Self minusDays(Integer days);

    "Returns a copy of this period with the specified amount of hours."
    shared formal Self withHours(Integer hours);

    "Returns a copy of this period with the specified amount of minutes."
    shared formal Self withMinutes(Integer minutes);

    "Returns a copy of this period with the specified amount of seconds."
    shared formal Self withSeconds(Integer seconds);

    "Returns a copy of this period with the specified amount of milliseconds."
    shared formal Self withMilliseconds(Integer milliseconds);

    "Returns a copy of this period with the specified number of hours added."
    shared formal Self plusHours(Integer hours);

    "Returns a copy of this period with the specified number of minutes added."
    shared formal Self plusMinutes(Integer minutes);

    "Returns a copy of this period with the specified number of seconds added."
    shared formal Self plusSeconds(Integer seconds);

    "Returns a copy of this period with the specified number of milliseconds added."
    shared formal Self plusMilliseconds(Integer milliseconds);

    "Returns a copy of this period with the specified number of hours subtracted."
    shared formal Self minusHours(Integer hours);

    "Returns a copy of this period with the specified number of minutes subtracted."
    shared formal Self minusMinutes(Integer minutes);

    "Returns a copy of this period with the specified number of seconds subtracted."
    shared formal Self minusSeconds(Integer seconds);

    "Returns a copy of this period with the specified number of milliseconds subtracted."
    shared formal Self minusMilliseconds(Integer milliseconds);

    "Returns a copy of this period with all amounts normalized to the 
     standard ranges for date-time fields.
     
     Two normalizations occur, one for years and months, and one for
     hours, minutes, seconds and nanoseconds.
     
     Days are not normalized, as a day may vary in length at daylight savings cutover.
     
     Neither is days normalized into months, as number of days per month varies from 
     month to another and depending on the leap year."
    shared formal PeriodBehavior<Self> normalized();

}
