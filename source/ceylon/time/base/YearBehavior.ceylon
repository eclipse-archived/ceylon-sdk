/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
"Common behavior for year types."
shared interface YearBehavior<Element>
       given Element satisfies ReadableYear {

    "Returns a copy of this instance with the specified year."
    shared formal Element withYear(Integer year);

    "Returns a copy of this instance with the specified number of years added."
    shared formal Element plusYears(Integer years);

    "Returns a copy of this instance with the specified number of years subtracted."
    shared formal Element minusYears(Integer years);

}