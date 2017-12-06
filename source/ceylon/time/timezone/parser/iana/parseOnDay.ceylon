/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
import ceylon.time.timezone.model {
    OnLastOfMonth,
    OnFixedDay,
    OnFirstOfMonth,
    OnDay,
    DayOfMonth
}
import ceylon.time.base {
    DayOfWeek
}

shared OnDay parseOnDay(String token) {
    //Split all values
    value result = parseOnDayToken(token);
    
    //now apply correct type
    if(exists day = result[0]) {
        if(exists dayOfWeek = result[1]) {
            return OnFirstOfMonth(dayOfWeek, day);
        } else {
            return OnFixedDay(day);
        }
    } 
    assert(exists dayOfWeek = result[1]);
    return OnLastOfMonth(dayOfWeek);
}

[DayOfMonth?, DayOfWeek?, Comparison] parseOnDayToken(String token) {
    variable [DayOfMonth?, DayOfWeek?, Comparison] result = [null,null, equal];
    if (token.startsWith("last")) {
        result = [null, findDayOfWeek(token.spanFrom(4)), larger];
    } else {
        function parseInteger(String string)
            => if (is Integer int = Integer.parse(string))
            then int else null;
        value gtIdx = token.firstInclusion(">=");
        value stIdx = token.firstInclusion("<=");
        if (exists gtIdx , gtIdx > 0) {
            result = [parseInteger(token.spanFrom(gtIdx + 2).trimmed), findDayOfWeek(token.span(0, gtIdx -1)), larger];
        } else if( exists stIdx, stIdx > 0) {
            result = [parseInteger(token.spanFrom(stIdx + 2)), findDayOfWeek(token.span(0, stIdx-1)), smaller];
        } else {
            result = [parseInteger(token), null, equal];
        }
    }
    return result;
}