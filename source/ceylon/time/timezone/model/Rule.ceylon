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
    Period
}
import ceylon.time.base {
    Month
}

"Alias to represent a specific year."
shared alias Year => Integer;

"Timezone transition rule."
shared class Rule(
    shared Year fromYear, 
    shared Year toYear, 
    shared Month inMonth, 
    shared OnDay onDay, 
    shared AtTime atTime, 
    shared Period save,
    shared String letter) {
    
    shared actual Boolean equals(Object other) {
        if(is Rule other) {
            return fromYear == other.fromYear
                && toYear == other.toYear
                && inMonth == other.inMonth
                && onDay == other.onDay
                && atTime == other.atTime
                && save == other.save
                && letter == other.letter;
        }
        return false;
    }
    
    string => "fromYear: '``fromYear``', toYear: '``toYear``', inMonth: '``inMonth``',
               onDay: '``onDay``', atTime: '``atTime``', save: '``save``', letter: '``letter``'";
    
}
