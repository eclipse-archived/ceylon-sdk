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

"""Whether daylight saving time is being observed:
   
   * [[standardZoneRule]]: A hyphen, a kind of `null` value, 
     means that we have not set our clocks ahead of standard time.
   * [[PeriodZoneRule]]: An amount of time (usually but not necessarily `1:00` meaning one hour)
     means that we have set our clocks ahead by that amount.
   * [[BasedZoneRule]]: Some alphabetic string means that we might have set our clocks ahead;
     and we need to check the rule the name of which is the given alphabetic string."""
shared abstract class ZoneRule() of standardZoneRule | PeriodZoneRule | BasedZoneRule {}

shared object standardZoneRule extends ZoneRule(){}

shared class PeriodZoneRule(period) extends ZoneRule(){
    shared Period period;
}

shared class BasedZoneRule(ruleName) extends ZoneRule(){
    shared String ruleName;
}
