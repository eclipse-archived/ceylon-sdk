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
    Time
}

"First, the time that something happens (in the AT column) is not necessarily the local wall clock time. 
 
 The time can be suffixed with ‘s’ (for “standard”) to mean local standard time (different from wall clock time when observing daylight saving time); 
 or it can be suffixed with ‘g’, ‘u’, or ‘z’, all three of which mean the standard time at the prime meridan. 
 ‘g’ stands for “GMT”; 
 ‘u’ stands for “UT” or “UTC” (whichever was official at the time); 
 ‘z’ stands for the nautical time zone Z (a.k.a. “Zulu” which, in turn, stands for ‘Z’). 
 The time can also be suffixed with ‘w’ meaning “wall clock time;” 
 but it usually isn’t because that’s the default."
shared abstract class AtTime(time, letter) 
        of AtWallClockTime | AtLocalMeanTime | AtGmtTime | AtUtcTime | AtNauticalTime {
    
    shared Time time;
    shared String letter;
    
    shared actual Boolean equals(Object other) {
        if(is AtTime other) {
            return time == other.time 
                    && letter == other.letter;
        }
        return false;
    }
    
    string => "time: '``time``', letter: '``letter``'";
}

"Wall clock time rule.
 
 Offset from GMT varies depending wether the DST is in effect at the moment or not."
shared class AtWallClockTime(Time time) extends AtTime(time, "u"){}

"Local mean time rule.
 
 This has always a fixed offset from the UTC."
shared class AtLocalMeanTime(Time time) extends AtTime(time, "s"){}

"GMT time rule."
shared class AtGmtTime(Time time) extends AtTime(time, "g"){}

"UTC time rule."
shared class AtUtcTime(Time time) extends AtTime(time, "u"){}

"Nautical time rule."
shared class AtNauticalTime(Time time) extends AtTime(time, "z"){}
