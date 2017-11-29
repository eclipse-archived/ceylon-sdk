/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
import ceylon.time.timezone {
    TimeZone,
    OffsetTimeZone,
    timeZone
}
import ceylon.time.base {
    ms = milliseconds
}

"Timezone offset parser based on ISO-8601, currently it accepts the following 
 time zone offset patterns:
 
 - &plusmn;`[hh]:[mm]`,
 - &plusmn;`[hh][mm]`, and 
 - &plusmn;`[hh]`.
 
 In addition, the special code `Z` is recognized as a shorthand for `+00:00`"
shared TimeZone? parseTimeZone( String offset ) {
    if(offset == "Z") {
        return timeZone.utc;
    }
    
    value signal =
            switch(offset[0])
    case ('+')  1
    case ('-') -1
    else null;
    
    if(exists signal) {
        function offsetTimeZone(Integer hh, Integer mm) 
                => let (value milliseconds = hh * ms.perHour + mm * ms.perMinute) 
        if (signal == -1, milliseconds == 0) then null 
        else OffsetTimeZone(signal * milliseconds);
        
        value rest = offset[1...];
        
        if (rest.size == 5,
            is Integer hh = Integer.parse(rest[...1]),
            is Integer mm = Integer.parse(rest[3...])) {
            return offsetTimeZone(hh, mm);
        }   
        else if (rest.size == 4,
            is Integer hh = Integer.parse(rest[...1]),
            is Integer mm = Integer.parse(rest[2...])) {
            return offsetTimeZone(hh, mm);
        }   
        else if (rest.size == 2,
            is Integer hh = Integer.parse(rest[...1])) {
            return offsetTimeZone(hh, 0);
        }      
    }
    
    return null;
}
