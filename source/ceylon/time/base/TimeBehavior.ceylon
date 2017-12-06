/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
"Common behavior for the types that represent time."
shared interface TimeBehavior<Element>
       given Element satisfies ReadableTime {

    "Returns a copy of this period with the specified amount of hours.\n
     Result must be a valid time of day."
    shared formal Element withHours(Integer hours);

    "Returns a copy of this period with the specified amount of minutes."
    shared formal Element withMinutes(Integer minutes);

    "Returns a copy of this period with the specified amount of seconds."
    shared formal Element withSeconds(Integer seconds);

    "Returns a copy of this period with the specified amount of milliseconds."
    shared formal Element withMilliseconds(Integer milliseconds);

    "Returns a copy of this period with the specified number of hours added."
    shared formal Element plusHours(Integer hours);

    "Returns a copy of this period with the specified number of minutes added."
    shared formal Element plusMinutes(Integer minutes);

    "Returns a copy of this period with the specified number of seconds added."
    shared formal Element plusSeconds(Integer seconds);

    "Returns a copy of this period with the specified number of milliseconds added."
    shared formal Element plusMilliseconds(Integer milliseconds);

    "Returns a copy of this period with the specified number of hours subtracted."
    shared formal Element minusHours(Integer hours);

    "Returns a copy of this period with the specified number of minutes subtracted."
    shared formal Element minusMinutes(Integer minutes);

    "Returns a copy of this period with the specified number of seconds subtracted."
    shared formal Element minusSeconds(Integer seconds);

    "Returns a copy of this period with the specified number of milliseconds subtracted."
    shared formal Element minusMilliseconds(Integer milliseconds);

}
