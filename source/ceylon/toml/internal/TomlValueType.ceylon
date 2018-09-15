/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
shared final class TomlValueType
        of table | array | time | date | dateTime| zoneDateTime
            | boolean | float | integer | str {

    shared actual String string;

    shared new table {
        string = "Table";
    }
    shared new array {
        string = "Array";
    }
    shared new time {
        string = "Local Time";
    }
    shared new date {
        string = "Local Date";
    }
    shared new dateTime {
        string = "Local Date-Time";
    }
    shared new zoneDateTime {
        string = "Offset Date-Time";
    }
    shared new boolean {
        string = "Boolean";
    }
    shared new float {
        string = "Float";
    }
    shared new integer {
        string = "Integer";
    }
    shared new str {
        string = "String";
    }
}
