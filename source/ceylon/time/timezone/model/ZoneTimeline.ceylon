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

shared class ZoneTimeline(offset, rule, format, until) {
    shared Period offset;
    shared ZoneRule rule;
    shared ZoneFormat format;
    shared ZoneUntil until;
    
    shared actual Boolean equals(Object other) {
        if(is ZoneTimeline other) {
            return offset == other.offset
                    && rule == other.rule
                    && format == other.format
                    && until == other.until;
        }
        return false;
    }
    
}