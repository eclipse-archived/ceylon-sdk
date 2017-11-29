/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
"An [[Event]] that has a corresponding other event"
shared sealed interface NestingEvent<Self, out Other> 
        given Other satisfies NestingEvent<Other, Self>
        given Self satisfies NestingEvent<Self, Other> {
    "The value associated with this event"
    shared formal Other other;
}

"The start of a JSON object/hash, emitted when `{` is parsed."
shared abstract class ObjectStartEvent()
        of objectStart
        satisfies NestingEvent<ObjectStartEvent,ObjectEndEvent>{
}
"The start of an object encountered when processing JSON data"
shared object objectStart extends ObjectStartEvent() {
    shared actual String string => "{";
    shared actual ObjectEndEvent other => objectEnd;
    
}

"The end of a JSON object/hash, emitted when `}` is parsed."
shared abstract class ObjectEndEvent() 
        of objectEnd
        satisfies NestingEvent<ObjectEndEvent,ObjectStartEvent>{
}
"The end of the current object encountered when processing JSON data"
shared object objectEnd extends ObjectEndEvent() {
    shared actual String string => "}";
    shared actual ObjectStartEvent other => objectStart;
    
}

"The start of a JSON array, emitted when `[` is parsed."
shared abstract class ArrayStartEvent() 
        of arrayStart
        satisfies NestingEvent<ArrayStartEvent,ArrayEndEvent> {
}
"The start of an array encountered when processing JSON data"
shared object arrayStart extends ArrayStartEvent() {
    shared actual String string => "[";
    shared actual ArrayEndEvent other => arrayEnd;
    
}

"The end of a JSON array, emitted when `]` is parsed."
shared abstract class ArrayEndEvent() 
        of arrayEnd
        satisfies NestingEvent<ArrayEndEvent,ArrayStartEvent>{
}
"The end of the current array encountered when processing JSON data"
shared object arrayEnd extends ArrayEndEvent() {
    shared actual String string => "]";
    shared actual ArrayStartEvent other => arrayStart;
    
}

"A key encountered when processing JSON data"
shared class KeyEvent(key) {
    shared String key;
    shared actual String string => "\"``key``\":";
}

"An event encountered when processing JSON data"
shared alias Event => ObjectStartEvent|ObjectEndEvent|ArrayStartEvent|ArrayEndEvent
        |KeyEvent|String|Float|Integer|Boolean|Null;