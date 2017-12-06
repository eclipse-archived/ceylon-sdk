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
    Date,
    DateTime
}
import ceylon.time.timezone {
    ZoneDateTime
}
"A common interface of all month like objects.
 
 This interface is common to all data types that
 either partially or fully represent information 
 that can be interpreted as _month_."
see(`interface Date`,
    `interface DateTime`,
    `interface ZoneDateTime`)
shared interface ReadableMonth {

    "Month of the year value of the date."
    shared formal Month month;

}