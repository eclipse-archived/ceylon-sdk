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
    Period, zero
}
alias State => Integer;
shared Period? parsePeriod(String string) {
    if (exists first = string.first, first == 'P',
        !string.rest.empty) {
        
        variable Period period = zero;
        variable Integer integer = 0;
        variable Integer state = 0;
        
        for (index -> ch in string.rest.indexed) {
            if (ch.digit, state < 7, state != 3) {
                integer = integer*10 + (ch.integer - '0'.integer);
                continue;
            }
			if (ch == 'W', state < 1) {
				period = period.withDays(7 * integer);
				integer = 0;
				state = 7;
				continue;
			}
            if (ch == 'Y', state < 1) {
                period = period.withYears(integer);
                integer = 0;
                state = 1;
                continue;
            }
            if (ch == 'M', state < 2) {
                period = period.withMonths(integer);
                integer = 0;
                state = 2;
                continue;
            }
            if (ch == 'D', state < 3) {
                period = period.withDays(integer);
                integer = 0;
                state = 3;
                continue;
            }
            if (ch == 'T', state < 4) {
                if (integer != 0) {
                    return null;
                }
                state = 4;
                continue;
            }
            if (ch == 'H', state == 4) {
                period = period.withHours(integer);
                integer = 0;
                state = 5;
                continue;
            }
            if (ch == 'M', 4 <= state < 6) {
                period = period.withMinutes(integer);
                integer = 0;
                state = 6;
                continue;
            }
            if (ch == 'S', 4 <= state < 7) {
                period = period.withSeconds(integer);
                integer = 0;
                state = 7;
                continue;
            }
            
            return null;
        }
        
        if (integer == 0) {
            return period;
        }
    }
    return null;
}
