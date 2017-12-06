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
    ArrayList
}
"A [[Visitor]] which emits formatted 
 JSON to the [[print]] method."
by("Tom Bentley")
shared abstract class Emitter(Boolean pretty) satisfies Visitor {
    "A stack of states. The top of the stack corresponds to the 
     current thing we're emitting. If it's > 0 we're emitting an Object,
     if it's < 0 we're emitting an Array. The magnitude -1 is the number 
     of elements of the Object or Array that have been emitted so far."
    ArrayList<Integer> state = ArrayList<Integer>();
    
    value level => state.size;
    
    void indent(){
        if(pretty){
            print("\n");
            if(level > 0){
                for(i in 0..level-1){
                    print(" ");
                }
            }
        }
    }
    
    "Override to implement the printing part"
    shared formal void print(String string);
    
    "Updates the top element on the stack, and 
     adds comma separators if emitting an array."
    void emitValue() {
        if (exists top = state.last) {
            if (top < -1) {
                print(",");
                indent();
            } else if (top == -1) {
                indent();
            }
            if (top < 0) {
                state[state.size-1] = top-1;
            } else {
                state[state.size-1] = top+1;
            }
        }
    }
    
    "Prints an `Object`"
    shared actual void onStartObject(){
        emitValue();
        print("{");
        state.push(1);
        
    }
    
    shared actual void onKey(String key) {
        if (exists top = state.last,
            top > 1) {
            print(",");
        }
        indent();
        printString(key);
        print(":");
        if(pretty){
            print(" ");
        }
    }
    
    shared actual void onEndObject() {
        if(exists st = this.state.pop(), 
            st != 1) {
            indent();
        }
        print("}");
    }
    
    shared actual void onStartArray(){
        emitValue();
        print("[");
        state.push(-1);
    }
    
    shared actual void onEndArray() {
        if(exists st = this.state.pop(), 
            st != -1){
            indent();
        }
        print("]");
    }
    
    shared actual void onString(String s){
        emitValue();
        printString(s);
    }
    
    "Prints a `String`"
    void printString(String s) {
        print("\"");
        for(c in s){
            if(c == '"'){
                print("\\" + "\"");
            }else if(c == '\\'){
                print("\\\\");
            }else if(c == '/'){
                print("\\" + "/");
            }else if(c == 8.character){
                print("\\" + "b");
            }else if(c == 12.character){
                print("\\" + "f");
            }else if(c == 10.character){
                print("\\" + "n");
            }else if(c == 13.character){
                print("\\" + "r");
            }else if(c == 9.character){
                print("\\" + "t");
            }else{
                print(c.string);
            }
        }
        print("\"");
    }
    
    shared actual void onNumber(Integer|Float n) {
        emitValue();
        print(formatNumber(n));
    }
    
    shared actual void onBoolean(Boolean v) {
        emitValue();
        print(v.string);
    }
    
    shared actual void onNull() {
        emitValue();
        print("null");
    }
}

"A JSON Emitter that prints to a [[String]]."
by("Tom Bentley")
shared class StringEmitter(Boolean pretty = false) 
        extends Emitter(pretty){
    
    value builder = StringBuilder();
    
    "Appends the given value to our `String` representation"
    shared actual void print(String string)
            => builder.append(string);
    
    "Returns the printed JSON"
    shared actual default String string => builder.string;
}
