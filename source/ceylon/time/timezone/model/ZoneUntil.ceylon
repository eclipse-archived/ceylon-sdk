/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
import ceylon.time {
    Date,
    date,
    time
}
import ceylon.time.base {
    years,
    december
}

shared ZoneUntil untilPresent = ZoneUntil(date(years.maximum, december, 31), AtWallClockTime(time(23,59,59,999)));

"To represent a [[ZoneTimeline]] that continues until the present you should 
 use [[untilPresent]]"
shared class ZoneUntil(date, ruleDefinition) {
    shared Date date;
    shared AtTime ruleDefinition;
    
    shared actual Boolean equals(Object other) {
        if(is ZoneUntil other) {
            return date == other.date
                && ruleDefinition == other.ruleDefinition;
        }
        return false;
    }
}