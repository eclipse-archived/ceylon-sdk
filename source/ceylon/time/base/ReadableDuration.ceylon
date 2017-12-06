/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
import ceylon.time { Duration }

"An abstraction of data representing a specific duration of time.
 
 A duration is a fixed delta of time between two instants 
 measured in number of milliseconds."
see(`class Duration`)
shared interface ReadableDuration {

    "Number of milliseconds."
    shared formal Integer milliseconds;

}
