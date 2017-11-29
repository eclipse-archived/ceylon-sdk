/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
"A Period of time represented as number of _years_, _months_, _days_, 
 _hours_, _minutes_, _seconds_ and/or _milliseconds_."
shared interface ReadablePeriod 
       satisfies ReadableDatePeriod 
               & ReadableTimePeriod {

    "Returns a truncated view of this period that only contains number of 
     _years_, _months_ and _days_."
    shared formal ReadableDatePeriod dateOnly;

    "Returns a truncated view of this period that only contains number of 
     _hours_, _minutes_, _seconds_ and _milliseconds_."
    shared formal ReadableTimePeriod timeOnly;

}

"A period of _days_, _months_ and _years_."
shared interface ReadableDatePeriod {

    "The number of years."
    shared formal Integer years;

    "The number of months."
    shared formal Integer months;

    "The number of days."
    shared formal Integer days;

}

"A period of _hours_, _minutes_, _seconds_ and _milliseconds_."
shared interface ReadableTimePeriod {

    "The number of hours"
    shared formal Integer hours;

    "The number of minutes"
    shared formal Integer minutes;

    "The number of seconds"
    shared formal Integer seconds;

    "The number of milliseconds"
    shared formal Integer milliseconds;

}