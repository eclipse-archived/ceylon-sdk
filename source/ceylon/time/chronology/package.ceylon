/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
"Package containing supported chronologies in ceylon.time library.
 
 A _Chronology_ is a set of functions and methods that define the calendar system. 
 A Chronology is tightly coupled to the actual date implementation of that chronology.
 
 Generally speaking, a chronology is an implementation detail of a calendar system that 
 should not be overly visible to the users of the library unless they wish to implement 
 their own calendrical systems.
 
 Initial implementation contains only implementation for gregorian (and julian) chronologies. 
 This API is considered experimental and can change significantly between releases, so dependency 
 on this package is not advisable for general use.
 "
by ("Diego Coronel", "Roland Tepp")
shared package ceylon.time.chronology;