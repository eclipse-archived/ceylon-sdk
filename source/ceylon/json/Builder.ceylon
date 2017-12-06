/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
import ceylon.language.meta {
    type
}
import ceylon.collection {
    ArrayList
}
"A [[Visitor]] that constructs a [[Value]].
 
 This would usually be used in conjunction with 
 a [[StringParser]]."
by("Tom Bentley")
shared class Builder() satisfies Visitor {
    
    ArrayList<Value> stack = ArrayList<Value>();
    
    //variable Value? current = null;
    variable String? currentKey = null;
    
    "The constructed [[Value]]."
    throws(`class AssertionError`, 
        "The builder has not yet seen enough input to return a fully formed JSON value.")
    shared Value result {
        if (stack.size == 1,
            ! currentKey exists) {
            return stack.pop();
        } else {
            throw AssertionError("currenyKey=``currentKey else "null" ``, stack=``stack``");
        }
    }
    
    void addToCurrent(Value v) {
        value current = stack.last;
        switch(current)
        case (Object) {
            if (exists ck=currentKey) {
                if (exists old = current.put(ck, v)) {
                    throw AssertionError("duplicate key ``ck``");
                }
                currentKey = null;
            } else {
                "value within object without key"
                assert(false);
            }
        }
        case (Array) {
            current.add(v);
        }
        case (Null) {
            
        }
        else {
            throw AssertionError("cannot add value to ``type(current)``");
        }
    }
    
    void push(Value v) {
        if (stack.empty) {
            stack.push(v);
        }
        if (v is Object|Array) {
            stack.push(v);
        }
    }
    
    void pop() {
        stack.pop();
    }
    
    shared actual void onStartObject() {
        Object newObj = Object{};
        addToCurrent(newObj);
        push(newObj);
    }
    shared actual void onKey(String key) {
        this.currentKey = key;
    }
    
    shared actual void onEndObject() {
        pop();
    }
    shared actual void onStartArray() {
        Array newArray = Array();
        addToCurrent(newArray);
        push(newArray);
    }
    
    shared actual void onEndArray() {
        pop();
    }
    shared actual void onNumber(Integer|Float num) {
        addToCurrent(num);
        push(num);
    }
    shared actual void onBoolean(Boolean bool) {
        addToCurrent(bool);
        push(bool);
    }
    shared actual void onNull() {
        addToCurrent(null);
        push(null);
    }
    
    shared actual void onString(String string) {
        addToCurrent(string);
        push(string);
    }
}
