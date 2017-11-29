/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
import ceylon.toml {
    TomlValue
}
import ceylon.time.timezone {
    ZoneDateTime
}
import ceylon.time {
    Time, Date, DateTime
}

shared TomlValueType elementTypeOf(TomlValue | Map<Anything, Anything> | List<Anything> tv)
    =>  switch (tv)
        case (Boolean) TomlValueType.boolean
        case (Float) TomlValueType.float
        case (Integer) TomlValueType.integer
        case (String) TomlValueType.str
        case (Map<Anything, Anything>) TomlValueType.table
        else case (List<Anything>) TomlValueType.array
        else case (ZoneDateTime) TomlValueType.zoneDateTime
        else case (DateTime) TomlValueType.dateTime
        else case (Date) TomlValueType.date
        else case (Time) TomlValueType.time;
