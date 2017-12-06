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
    MutableList, ArrayList
}
import ceylon.time {
    Time, Date, DateTime
}
import ceylon.time.timezone {
    ZoneDateTime
}

"A TOML Array."
shared final class TomlArray satisfies MutableList<TomlValue> {
    ArrayList<TomlValue> delegate;

    "Create a new [[TomlArray]] containing the given [[elements]]."
    shared new ({TomlValue*} elements = []) {
        delegate = ArrayList { *elements };
    }

    new create(ArrayList<TomlValue> delegate) {
        this.delegate = delegate;
    }

    shared actual TomlArray clone()
        =>  create(delegate.clone());

    lastIndex => delegate.lastIndex;
    set(Integer index, TomlValue element) => delegate.set(index, element);
    add(TomlValue element) => delegate.add(element);
    getFromFirst(Integer index) => delegate.getFromFirst(index);
    insert(Integer index, TomlValue element) => delegate.insert(index, element);
    delete(Integer index) => delegate.delete(index);

    iterator() => delegate.iterator();
    clear() => clear();
    equals(Object other) => delegate.equals(other);
    hash => delegate.hash;

    "Returns a `List<TomlTable>` view of this list. An `AssertionError` will be thrown
     upon accessing any of this array's elements that are not [[TomlTable]]s."
     shared List<TomlArray> tables => ListView<TomlArray>(delegate);

    "Returns a `List<TomlArray>` view of this list. An `AssertionError` will be thrown
     upon accessing any of this array's elements that are not [[TomlArray]]s."
     shared List<TomlArray> arrays => ListView<TomlArray>(delegate);

    "Returns a `List<Time>` view of this list. An `AssertionError` will be thrown
     upon accessing any of this array's elements that are not [[Time]]s."
     shared List<Time> times => ListView<Time>(delegate);

    "Returns a `List<Date>` view of this list. An `AssertionError` will be thrown
     upon accessing any of this array's elements that are not [[Date]]s."
     shared List<Date> dates => ListView<Date>(delegate);

    "Returns a `List<DateTime>` view of this list. An `AssertionError` will be thrown
     upon accessing any of this array's elements that are not [[DateTime]]s."
     shared List<DateTime> dateTimes => ListView<DateTime>(delegate);

    "Returns a `List<ZoneDateTime>` view of this list. An `AssertionError` will be thrown
     upon accessing any of this array's elements that are not [[ZoneDateTime]]s."
     shared List<ZoneDateTime> zoneDateTimes => ListView<ZoneDateTime>(delegate);

    "Returns a `List<Boolean>` view of this list. An `AssertionError` will be thrown
     upon accessing any of this array's elements that are not [[Boolean]]s."
     shared List<Boolean> booleans => ListView<Boolean>(delegate);

    "Returns a `List<Float>` view of this list. An `AssertionError` will be thrown
     upon accessing any of this array's elements that are not [[Float]]s."
     shared List<Float> floats => ListView<Float>(delegate);

    "Returns a `List<Integer>` view of this list. An `AssertionError` will be thrown
     upon accessing any of this array's elements that are not [[Integer]]s."
     shared List<Integer> integers => ListView<Integer>(delegate);

    "Returns a `List<String>` view of this list. An `AssertionError` will be thrown
     upon accessing any of this array's elements that are not [[String]]s."
     shared List<String> strings => ListView<String>(delegate);
}

class ListView<Element>(List<Anything> delegate) satisfies List<Element> {
    shared actual Element? getFromFirst(Integer index) {
        assert (is Element? result = delegate.getFromFirst(index));
        return result;
    }
    lastIndex => delegate.lastIndex;
    equals(Object other) => (super of List<Element>).equals(other);
    hash => (super of List<Element>).hash;
}
