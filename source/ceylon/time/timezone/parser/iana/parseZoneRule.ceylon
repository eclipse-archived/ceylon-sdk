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
    PeriodZoneRule,
    ZoneRule,
    standardZoneRule
}

shared ZoneRule parseZoneRule(String token) {
    if(token == "-") {
        return standardZoneRule;
    }
    
    value indexes = "".indexesWhere(':'.equals).sequence();
    if(nonempty indexes) {
        return PeriodZoneRule(toPeriod(parseTime(token)));
    } else {
        return standardZoneRule;
    }
}