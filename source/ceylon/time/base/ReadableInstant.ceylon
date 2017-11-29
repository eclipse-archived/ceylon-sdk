/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
import ceylon.time { Instant }

"An abstraction for data that can represent an instant of time."
see(`class Instant`)
shared interface ReadableInstant {

    "Internal value of an instant as a number of milliseconds 
     since beginning of an _epoch_ (january 1st 1970 UTC)"
    shared formal Integer millisecondsOfEpoch;

}
