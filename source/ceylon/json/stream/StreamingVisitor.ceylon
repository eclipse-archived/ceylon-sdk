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
    Visitor,
    JsonValue=Value,
    JsonArray=Array,
    JsonObject=Object
}
import ceylon.collection {
    ArrayList
}
"Calls a visitor according to the events obtained from a stream."
shared void streamToVisitor(Iterator<Event> stream, Visitor visitor) {
    while (!is Finished event=stream.next()) {
        switch(event)
        case (ObjectStartEvent) {
            visitor.onStartObject();
        }
        case (KeyEvent) {
            visitor.onKey(event.key);
        }
        case (ObjectEndEvent) {
            visitor.onEndObject();
        }
        case (ArrayStartEvent) {
            visitor.onStartArray();
        }
        case (ArrayEndEvent) {
            visitor.onEndArray();
        }
        case (String) {
            visitor.onString(event);
        }
        case (Boolean) {
            visitor.onBoolean(event);
        }
        case (Integer|Float) {
            visitor.onNumber(event);
        }
        case (null) {
            visitor.onNull();
        }
    }
}

"A unit type used internally because we can't use null"
abstract class None() of none {}
object none extends None() {}

class PushIterator<out T>(Iterator<T> it) satisfies Iterator<T> {
    variable T|None pushed = none;
    shared void push(Anything pushed) {
        "cannot push more than one item"
        assert (is None p=pushed);
        assert (is T p);
        this.pushed = p;
    }
    shared actual T|Finished next() {
        if (!is None p=pushed) {
            pushed = none;
            return p;
        } else {
            return it.next();
        }
    }
}

"Produces a stream of events from the descendents of the given root value."
shared class StreamingVisitor(JsonValue root) satisfies Iterator<Event> {
    value stack = ArrayList<PushIterator<JsonValue|<String->JsonValue>>>();
    value pi = PushIterator<JsonValue|<String->JsonValue>>(emptyIterator);
    pi.push(root);
    stack.push(pi);
    shared actual Event|Finished next() {
        if (exists p = stack.pop()) {
            value n = p.next();
            switch(n)
            case (String|Boolean|Integer|Float|Null) {
                return n;
            }
            case (JsonObject) {
                stack.push(PushIterator(n.iterator()));
                return objectStart;
            } 
            case (JsonArray) {
                stack.push(PushIterator(n.iterator()));
                return arrayStart;
            }
            case (String->JsonValue) {
                p.push(n.item);
                return KeyEvent(n.key);
            }
            case (Finished) {
                switch (p)
                case (Iterator<String|Boolean|Integer|Float|JsonObject|JsonArray|Null>) {
                    return arrayEnd;
                }
                else {
                    return objectEnd;
                }
                
            }
        } else {
            return finished;
        }
    }
}