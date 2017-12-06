/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
import ceylon.collection {
    MutableMap, HashMap
}
import ceylon.time {
    Time, Date, DateTime
}
import ceylon.time.timezone {
    ZoneDateTime
}

"A TOML Table."
shared final class TomlTable satisfies MutableMap<String, TomlValue> {
    HashMap<String, TomlValue> delegate;

    "Create a new [[TomlTable]] containing the given [[entries]]."
    shared new ({<String->TomlValue>*} entries = []) {
        delegate = HashMap<String, TomlValue> { *entries };
    }

    new create(HashMap<String, TomlValue> delegate) {
        this.delegate = delegate;
    }

    shared actual TomlTable clone()
        =>  TomlTable.create(delegate.clone());

    "Returns a [[TomlTable]]."
    throws(
        `class AssertionError`,
         "if the key does not exist or points to a type that is not [[TomlTable]]"
    )
    shared TomlTable getTomlTable(String key) {
        "Expecting a TomlTable"
        assert (is TomlTable val = get(key));
        return val;
    }

    "Returns a [[TomlTable]], or [[null]] if the [[key]] does not exist."
    throws(
        `class AssertionError`,
         "if the key does not exist or points to a type that is not [[TomlTable]]"
    )
    shared TomlTable? getTomlTableOrNull(String key) {
        "Expecting a TomlTable or Null"
        assert (is TomlTable? val = get(key));
        return val;
    }

    "Returns a [[TomlArray]]."
    throws(
        `class AssertionError`,
         "if the key does not exist or points to a type that is not [[TomlArray]]"
    )
    shared TomlArray getTomlArray(String key) {
        "Expecting a TomlArray"
        assert (is TomlArray val = get(key));
        return val;
    }

    "Returns a [[TomlArray]], or [[null]] if the [[key]] does not exist."
    throws(
        `class AssertionError`,
        "if the key does not exist or points to a type that is not [[TomlArray]]"
    )
    shared TomlArray? getTomlArrayOrNull(String key) {
        "Expecting a TomlTable or Null"
        assert (is TomlArray? val = get(key));
        return val;
    }

    "Returns a [[Time]]."
    throws(
        `class AssertionError`,
        "if the key does not exist or points to a type that is not [[Time]]"
    )
    shared Time getTime(String key) {
        "Expecting a Time"
        assert (is Time val = get(key));
        return val;
    }

    "Returns a [[Time]], or [[null]] if the [[key]] does not exist."
    throws(
        `class AssertionError`,
        "if the key does not exist or points to a type that is not [[Time]]"
    )
    shared Time? getTimeOrNull(String key) {
        "Expecting a Time or Null"
        assert (is Time? val = get(key));
        return val;
    }

    "Returns a [[Date]]."
    throws(
        `class AssertionError`,
        "if the key does not exist or points to a type that is not [[Date]]"
    )
    shared Date getDate(String key) {
        "Expecting a Date"
        assert (is Date val = get(key));
        return val;
    }

    "Returns a [[Date]], or [[null]] if the [[key]] does not exist."
    throws(
        `class AssertionError`,
        "if the key does not exist or points to a type that is not [[Date]]"
    )
    shared Date? getDateOrNull(String key) {
        "Expecting a Date or Null"
        assert (is Date? val = get(key));
        return val;
    }

    "Returns a [[DateTime]]."
    throws(
        `class AssertionError`,
        "if the key does not exist or points to a type that is not [[DateTime]]"
    )
    shared DateTime getDateTime(String key) {
        "Expecting a DateTime"
        assert (is DateTime val = get(key));
        return val;
    }

    "Returns a [[DateTime]], or [[null]] if the [[key]] does not exist."
    throws(
        `class AssertionError`,
        "if the key does not exist or points to a type that is not [[DateTime]]"
    )
    shared DateTime? getDateTimeOrNull(String key) {
        "Expecting a DateTime or Null"
        assert (is DateTime? val = get(key));
        return val;
    }

    "Returns a [[ZoneDateTime]]."
    throws(
        `class AssertionError`,
        "if the key does not exist or points to a type that is not [[ZoneDateTime]]"
    )
    shared ZoneDateTime getZoneDateTime(String key) {
        "Expecting a ZoneDateTime"
        assert (is ZoneDateTime val = get(key));
        return val;
    }

    "Returns a [[ZoneDateTime]], or [[null]] if the [[key]] does not exist."
    throws(
        `class AssertionError`,
        "if the key does not exist or points to a type that is not [[ZoneDateTime]]"
    )
    shared ZoneDateTime? getZoneDateTimeOrNull(String key) {
        "Expecting a ZoneDateTime or Null"
        assert (is ZoneDateTime? val = get(key));
        return val;
    }

    "Returns a [[Boolean]]."
    throws(
        `class AssertionError`,
        "if the key does not exist or points to a type that is not [[Boolean]]"
    )
    shared Boolean getBoolean(String key) {
        "Expecting a Boolean"
        assert (is Boolean val = get(key));
        return val;
    }

    "Returns a [[Boolean]], or [[null]] if the [[key]] does not exist."
    throws(
        `class AssertionError`,
        "if the key does not exist or points to a type that is not [[Boolean]]"
    )
    shared Boolean? getBooleanOrNull(String key) {
        "Expecting a Boolean or Null"
        assert (is Boolean? val = get(key));
        return val;
    }

    "Returns a [[Float]]."
    throws(
        `class AssertionError`,
        "if the key does not exist or points to a type that is not [[Float]]"
    )
    shared Float getFloat(String key) {
        "Expecting a Float"
        assert (is Float val = get(key));
        return val;
    }

    "Returns a [[Float]], or [[null]] if the [[key]] does not exist."
    throws(
        `class AssertionError`,
        "if the key does not exist or points to a type that is not [[Float]]"
    )
    shared Float? getFloatOrNull(String key) {
        "Expecting a Float or Null"
        assert (is Float? val = get(key));
        return val;
    }

    "Returns a [[Integer]]."
    throws(
        `class AssertionError`,
        "if the key does not exist or points to a type that is not [[Integer]]"
    )
    shared Integer getInteger(String key) {
        "Expecting a Integer"
        assert (is Integer val = get(key));
        return val;
    }

    "Returns a [[Integer]], or [[null]] if the [[key]] does not exist."
    throws(
        `class AssertionError`,
        "if the key does not exist or points to a type that is not [[Integer]]"
    )
    shared Integer? getIntegerOrNull(String key) {
        "Expecting a Integer or Null"
        assert (is Integer? val = get(key));
        return val;
    }

    "Returns a [[String]]."
    throws(
        `class AssertionError`,
        "if the key does not exist or points to a type that is not [[String]]"
    )
    shared String getString(String key) {
        "Expecting a String"
        assert (is String val = get(key));
        return val;
    }

    "Returns a [[String]], or [[null]] if the [[key]] does not exist."
    throws(
        `class AssertionError`,
        "if the key does not exist or points to a type that is not [[String]]"
    )
    shared String? getStringOrNull(String key) {
        "Expecting a Integer or Null"
        assert (is String? val = get(key));
        return val;
    }

    remove(String key) => delegate.remove(key);
    put(String key, TomlValue item) => delegate.put(key, item);
    defines(Object key) => delegate.defines(key);
    get(Object key) => delegate.get(key);

    iterator() => delegate.iterator();
    clear() => clear();
    hash => delegate.hash;

    // workaround https://github.com/ceylon/ceylon-sdk/issues/675
    // and https://github.com/ceylon/ceylon/issues/7131
    // equals(Object other) => delegate.equals(other);
    shared actual Boolean equals(Object that) {
        if (is Map<Object,Anything> that,
            that.size==size) {
            for (key -> thisItem in this) {
                value thatItem = that[key];
                if (exists thatItem) {
                    if (thisItem!=thatItem) {
                        return false;
                    }
                }
                else {
                    return false;
                }
            }
            else {
                return true;
            }
        }
        else {
            return false;
        }
    }
}
