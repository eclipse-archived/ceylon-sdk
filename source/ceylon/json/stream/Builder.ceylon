/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
import ceylon.json {
    JsonObject=Object,
    JsonArray=Array,
    Value,
    Positioned,
    StringTokenizer
}

"Parse the given string of JSON 
 formatted data into an in-memory model, 
 returning the model."
Value parse(String json) {
    return buildValue(StreamParser(StringTokenizer(json)));
}

"Recursively builds a [[model|Value]] from events produced from the given iterator."
Value buildValue(Iterator<Event>&Positioned events) {
    value event = events.next();
    switch (event)
    case(String|Integer|Float|Boolean|Null) {
        return event;
    }
    case(ObjectStartEvent) {
        return buildObject(events);
    }
    case(KeyEvent) {
        "unexpected key"
        assert(false);
    }
    case(ObjectEndEvent) {
        "unexpected object end"
        assert(false);
    }
    case(ArrayStartEvent) {
        return buildArray(events);
    }
    case(ArrayEndEvent) {
        "unexpected array end"
        assert(false);
    }
    case(Finished) {
        "unexpected end of input"
        assert(false);
    }
}

JsonObject buildObject(Iterator<Event>&Positioned events) {
    JsonObject result = JsonObject();
    variable String? key=null;
    while (true) {
        value event = events.next();
        switch (event)
        case(String|Integer|Float|Boolean|Null) {
            "no key in object"
            assert(exists k=key);
            result.put(k, event);
            key = null;
        }
        case(ObjectStartEvent) {
            "no key in object"
            assert(exists k=key);
            result.put(k, buildObject(events));
            key = null;
        }
        case(KeyEvent) {
            "two consecutive keys in object"
            assert(!key exists);
            key = event.key;
        }
        case(ObjectEndEvent) {
            return result;
        }
        case(ArrayStartEvent) {
            "no key in object"
            assert(exists k=key);
            result.put(k, buildArray(events));
            key = null;
        }
        case(ArrayEndEvent) {
            "object ended by array end"
            assert(false);
        }
        case(Finished) {
            "unexpected end of input"
            assert(false);
        }
    }
}
JsonArray buildArray(Iterator<Event>&Positioned events) {
    JsonArray result = JsonArray();
    while (true) {
        value event = events.next();
        switch (event)
        case(String|Integer|Float|Boolean|Null) {
            result.add(event);
        }
        case(ObjectStartEvent) {
            result.add(buildObject(events));
        }
        case(KeyEvent) {
            "key unexpected in array"
            assert(false);
        }
        case(ObjectEndEvent) {
            "array ended by object end"
            assert(false);
        }
        case(ArrayStartEvent) {
            result.add(buildArray(events));
        }
        case(ArrayEndEvent) {
            return result;
        }
        case(Finished) {
            "unexpected end of input"
            assert(false);
        }
    }
}