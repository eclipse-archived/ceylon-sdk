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
    DateTime,
    dateTime,
    Date,
    Time
}

"""The [[DateTime]] value of the given [[string representation|String]] 
   of a [ISO 8601](https://en.wikipedia.org/wiki/ISO_8601) datetime format 
   or `null` if the string does not contain valid ISO 8601 formatted 
   datetime value or the datetime is not formatted according to ISO standard."""
see (`function parseDate`, `function parseTime`)
shared DateTime? parseDateTime(String input) {
    if (exists t = input.firstOccurrence('T')) {
        if (exists date = parseDate(input[0..t-1]),
            exists timeComponents = parseTimeComponents(input[t+1...])) {
            
            if (exists time = convertToTime(timeComponents)) {
                if (timeComponents[0] == 24) {
                    return createDateTime(date.successor, time);
                }
                else {
                    return createDateTime(date, time);
                }
            }
        }
    }
    
    return null;
}

DateTime createDateTime(Date date, Time time) => dateTime { 
    year = date.year; 
    month = date.month; 
    day = date.day; 
    hours = time.hours; 
    minutes = time.minutes; 
    seconds = time.seconds; 
    milliseconds = time.milliseconds; 
};
