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
import ceylon.time.timezone.model {
    OnLastOfMonth,
    AtWallClockTime,
    untilPresent,
    AtTime,
    OnFixedDay,
    OnFirstOfMonth,
    ZoneUntil
}
import ceylon.time.base {
    january
}

shared ZoneUntil parseUntil([String*] token) {
    variable Date result = date(0, january, 1);
    if( exists yearText = token[0], yearText != "") {
        assert(is Integer year = Integer.parse(yearText));
        result = result.withYear(year);
    } else {
        return untilPresent;
    }
    
    if( exists monthText = token[1], monthText != "") {
        result = result.withMonth(parseMonth(monthText));
    }
    
    if( exists dayText = token[2], dayText != "") {
        value parsed = parseOnDay(dayText);
        switch(parsed)
        case(OnFixedDay){
            result = result.withDay(parsed.fixedDate);
        }
        case(OnFirstOfMonth){
            result = result.withDay(parsed.date(result.year, result.month).day);
        }
        case(OnLastOfMonth){
            result = result.withDay(parsed.date(result.year, result.month).day);
        }
    }
    
    AtTime definition;
    if( exists timeText = token[3], timeText != "") {
        value timeResult = parseTime(timeText);
        definition = timeResult[0];
    } else {
        definition = AtWallClockTime(time(0,0));
    }
    
    return ZoneUntil(result, definition);
}