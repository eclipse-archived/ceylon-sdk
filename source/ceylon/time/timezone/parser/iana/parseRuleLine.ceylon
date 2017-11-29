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
    Year,
    Rule
}
"Parse current token using http://www.cstdbill.com/tzdb/tz-how-to.html 
 columns as reference"

shared alias RuleName => String;

shared [RuleName, Rule] parseRuleLine(String line) {
    
    value token = line.split(tokenDelimiter).iterator();
    
    assert( is String rule = token.next(), rule == "Rule" );
    
    assert( is RuleName name = token.next() );
    assert( is String startYearText = token.next() );
    assert( is String endYearText = token.next() );
    assert( is String typeText = token.next() ); //just to discard
    assert( is String monthText = token.next() );
    assert( is String dayRuleText = token.next() );
    assert( is String timeRuleText = token.next() );
    assert( is String savingAmountsText = token.next() );
    assert( is String letterText = token.next() );
    
    Year year = parseYear(startYearText, 0);
    return
    [     name,
    Rule{
        fromYear = year;
        toYear = parseYear(endYearText, year);
        inMonth = parseMonth(monthText);
        onDay = parseOnDay(dayRuleText.trimmed);
        atTime = parseTime(timeRuleText.trimmed)[0];
        save = toPeriod(parseTime(savingAmountsText.trimmed));
        letter = letterText.trimmed;
    }
    ];
}
