/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
"A JSON Printer"
by("Stéphane Épardaud")
shared abstract class Printer(Boolean pretty = false){
    
    variable Integer level = 0;
    
    void enter(){
        level++;
    }
    
    void leave(){
        level--;
    }
    
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

    "Prints an `Object`"
    shared default void printObject(Object o){
        print("{");
        enter();
        variable Boolean once = true;
        for(entry in o.sort(compareKeys)){
            if(once){
                once = false;
            }else{
                print(",");
            }
            indent();
            printString(entry.key);
            print(":");
            if(pretty){
                print(" ");
            }
            printValue(entry.item);
        }
        leave();
        if(!once){
            indent();
        }
        print("}");
    }

    "Prints an `Array`"
    shared default void printArray(Array o){
        print("[");
        enter();
        variable Boolean once = true; 
        for(elem in o){
            if(once){
                once = false;
            }else{
                print(",");
            }
            indent();
            printValue(elem);
        }
        leave();
        if(!once){
            indent();
        }
        print("]");
    }

    "Prints a `String`"
    shared default void printString(String s){
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
    
    "Prints an `Integer|Float`"
    shared default void printNumber(Integer|Float n) {
        print(formatNumber(n));
    }

    "Prints a `Boolean`"
    shared default void printBoolean(Boolean v)
            => print(v.string);

    "Prints `null`"
    shared default void printNull()
            => print("null");
    
    "Prints a JSON value"
    shared default void printValue(Value val){
        switch(val)
        case (String){
            printString(val);
        }
        case (Integer){
            printNumber(val);
        }
        case (Float){
            printNumber(val);
        }
        case (Boolean){
            printBoolean(val);
        }
        case (Object){
            printObject(val);
        }
        case (Array){
            printArray(val);
        }
        case (Null){
            printNull();
        }
    }
    
}

"Formats a `Number`, handling infinity and undefined Floats."
String formatNumber(Integer|Float n) {
    String s;
    if (is Float n) {
        if (n.infinite || n.undefined) {
            s = "null";
        } else {
            s = n.string;
        }
    } else {
        s = n.string;
    }
    return s;
}

Comparison compareKeys(String->Value x, String->Value y)
        => x.key<=>y.key; 
