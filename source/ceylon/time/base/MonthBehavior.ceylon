/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
"Common behavior for month types."
shared interface MonthBehavior<Element>
       given Element satisfies ReadableMonth {

    "Returns a copy of this instance with the specified month of year."
    shared formal Element withMonth(Month month);

    "Returns a copy of this instance with the specified number of months added."
    shared formal Element plusMonths(Integer months);

    "Returns a copy of this instance with the specified number of months subtracted."
    shared formal Element minusMonths(Integer months);

}