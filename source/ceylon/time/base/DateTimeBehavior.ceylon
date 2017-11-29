/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
import ceylon.time { DateTime }

"Common behavior of the [[DateTime]] types."
see (`interface DateTime`,
     `interface ReadableDateTime`,
     `interface ReadableDate`,
     `interface ReadableTime`)
shared interface DateTimeBehavior<Element, out DateType, out TimeType>
       satisfies DateBehavior<Element>
               & TimeBehavior<Element>
       given Element satisfies ReadableDateTime
       given DateType satisfies ReadableDate
       given TimeType satisfies ReadableTime {

    "Returns Time portion of this [[DateTime]] value."
    shared formal TimeType time;

    "Returns Date portion of this [[DateTime]] value."
    shared formal DateType date;

}
