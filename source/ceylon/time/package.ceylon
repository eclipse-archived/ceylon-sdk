/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
"""Main package for the Ceylon's Date and Time library.

   Like in [JodaTime] and [JSR-310], there is a _machine timeline_ and a _human timeline_.

   [JodaTime]: http://joda-time.sourceforge.net
   [JSR-310]: http://sourceforge.net/apps/mediawiki/threeten/index.php?title=ThreeTen

   ## Machine timeline

   Machine timeline is represented by an [[Instant]] that is basically just an object
   wrapper around an [[Integer]] representing _[Unix time]_ value. A value of an Instant
   uniquely identifies a particular instant of time without needing to take into account
   timezone information and contain no ambiguities associated with [DST] changeover times.

   [Unix time]: http://en.wikipedia.org/wiki/Unix_time
   [DST]: http://en.wikipedia.org/wiki/Daylight_saving_time

   ## Human timeline

   Human timeline is based mostly on Gregorian and ISO-8601 calendar systems and consists of
   the following principal data types:

   * [[Date]] -- A date value without time component.
   * [[Time]] -- A time of day vallue without date component.
   * [[DateTime]] -- A particular time of a particular date.
   * [[ceylon.time.timezone::ZoneDateTime]] -- A particular moment of time identified by date, time of day and
     a time zone.

   **Note:** At the moment, timezone is not fully supported, therefore current
   conversions can uses offsets provided by VMs  and provides some features like [[ceylon.time.timezone::timeZone]]
   object that allows parser and creation of fixed offsets.
   """
by ("Diego Coronel", "Roland Tepp")
shared package ceylon.time;