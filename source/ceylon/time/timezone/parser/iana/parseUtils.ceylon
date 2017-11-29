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
    weekdays
}
import ceylon.time.timezone.model {
    AtTime
}
import ceylon.time {
    Period
}

DayOfWeek findDayOfWeek(String dayOfWeek) {
    assert(exists dow = weekdays.find((DayOfWeek elem) => elem.string.lowercased.startsWith(dayOfWeek.trimmed.lowercased)));
    return dow;
}

"Transform time in Period 
 
 P.S.: This is a good case to add this feature to Time. something like:
       time(1,0).period"
Period toPeriod([AtTime, Signal] signedTime) {
    let ([atTime, signal] = signedTime);
    return Period {
        hours = atTime.time.hours * signal;
        minutes = atTime.time.minutes * signal;
        seconds = atTime.time.seconds * signal;
        milliseconds = atTime.time.milliseconds * signal;
    };
}

shared Boolean tokenDelimiter(Character char) {
    return char == ' ' || char == '\t';
}
