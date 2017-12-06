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
    ...
}
import ceylon.language {
    LangObject=Object
}

"Alternative name for [[Object]] which avoids collision with
 ceylon.language::Object."
shared class JsonObject({<String->Value>*} values) => Object(values);

"Represents a JSON Object"
by("Stéphane Épardaud")
shared class Object({<String->Value>*} values = {}) 
        satisfies MutableMap<String,Value> {
    
    value contents = HashMap<String,Value> { *values };
    
    "Returns a serialised JSON representation"
    shared actual String string {
        StringEmitter p = StringEmitter();
        visit(this, p);
        return p.string;
    }

    "Returns a pretty-printed serialised JSON representation"
    shared String pretty {
        StringEmitter p = StringEmitter(true);
        visit(this, p, true);
        return p.string;
    }
    
    shared actual void clear() => contents.clear();
    
    shared actual Object clone() => Object(contents);
    
    get(LangObject key) => contents[key];
    
    defines(LangObject key) => contents.defines(key);
    
    iterator() => contents.iterator();
    
    put(String key, Value item) => contents.put(key, item);
    
    putAll({<String->Value>*} entries) 
            => contents.putAll(entries);
    
    remove(String key) => contents.remove(key);
    
    size => contents.size;
    
    hash => contents.hash;
    
    equals(LangObject that)
            => if(is Object that)
            then this === that || contents == that.contents
            else contents == that;
    
    // auto-casting
    
    "Returns an [[Integer]] value."
    throws(`class InvalidTypeException`,
        "If the key dot not exist or points to a type that 
         is not [[Integer]].")
    shared Integer getInteger(String key){
        value val = get(key);
        if(is Integer val){
            return val;
        }
        throw InvalidTypeException(
            "Expecting an Integer but got: ``
            val else "null" ``");
    }

    "Returns an [[Float]] value."
    throws(`class InvalidTypeException`,
        "If the key dot not exist or points to a type that 
         is not [[Float]].")
    shared Float getFloat(String key){
        switch (val = get(key))
        case(Float){
            return val;
        }
        case (Integer){
            return val.nearestFloat;
        }
        else {
            throw InvalidTypeException(
                "Expecting a Float but got: ``
                val else "null"``");
        }
    }

    "Returns an [[Boolean]] value."
    throws(`class InvalidTypeException`,
        "If the key dot not exist or points to a type that 
         is not [[Boolean]].")
    shared Boolean getBoolean(String key){
        value val = get(key);
        if(is Boolean val){
            return val;
        }
        throw InvalidTypeException(
            "Expecting a Boolean but got: `` 
            val else "null" ``");
    }

    "Returns an [[String]] value."
    throws(`class InvalidTypeException`,
        "If the key dot not exist or points to a type that 
         is not [[String]].")
    shared String getString(String key){
        value val = get(key);
        if(is String val){
            return val;
        }
        throw InvalidTypeException(
            "Expecting a String but got: `` 
            val else "null" ``");
    }

    "Returns an [[Object]] value."
    throws(`class InvalidTypeException`,
        "If the key dot not exist or points to a type that 
         is not [[Object]].")
    shared Object getObject(String key){
        value val = get(key);
        if(is Object val){
            return val;
        }
        throw InvalidTypeException(
            "Expecting an Object but got: `` 
            val else "null" ``");
    }
    
    "Returns an [[Array]] value."
    throws(`class InvalidTypeException`,
        "If the key dot not exist or points to a type that 
         is not [[Array]].")
    shared Array getArray(String key){
        value val = get(key);
        if(is Array val){
            return val;
        }
        throw InvalidTypeException(
            "Expecting an Array but got: `` 
            val else "null" ``");
    }
    
    // optional auto-casting
    
    "Returns an [[Integer]] value, unless the key does not 
     exist, or the value is null."
    throws(`class InvalidTypeException`,
        "If the key points to a type that is neither 
         [[Integer]] nor [[Null]].")
    shared Integer? getIntegerOrNull(String key){
        value val = get(key);
        if(is Integer? val){
            return val;
        }
        else {
            throw InvalidTypeException(
                "Expecting an Integer but got: ``val``");
        }
    }

    "Returns an [[Float]] value, unless the key does not 
     exist, or the value is null."
    throws(`class InvalidTypeException`,
        "If the key points to a type that is neither 
         [[Float]] nor [[Null]].")
    shared Float? getFloatOrNull(String key){
        switch (val = get(key))
        case (null) {
            return null;
        }
        case(Float){
            return val;
        }
        case (Integer){
            return val.nearestFloat;
        }
        else {
            throw InvalidTypeException(
                "Expecting a Float but got: ``val``");
        }
    }

    "Returns an [[Boolean]] value, unless the key does not 
     exist, or the value is null."
    throws(`class InvalidTypeException`,
        "If the key points to a type that is neither 
         [[Boolean]] nor [[Null]].")
    shared Boolean? getBooleanOrNull(String key){
        value val = get(key);
        if(is Boolean? val){
            return val;
        }
        else {
            throw InvalidTypeException(
                "Expecting a Boolean but got: ``val``");
        }
    }

    "Returns an [[String]] value, unless the key does not 
     exist, or the value is null."
    throws(`class InvalidTypeException`,
        "If the key points to a type that is neither 
         [[String]] nor [[Null]].")
    shared String? getStringOrNull(String key){
        value val = get(key);
        if(is String|Null val){
            return val;
        }
        else {
            throw InvalidTypeException(
                "Expecting a String but got: ``val``");
        }
    }

    "Returns an [[Object]] value, unless the key does not 
     exist, or the value is null."
    throws(`class InvalidTypeException`,
        "If the key points to a type that is neither 
         [[Object]] nor [[Null]].")
    shared Object? getObjectOrNull(String key){
        value val = get(key);
        if(is Object? val){
            return val;
        }
        else {
            throw InvalidTypeException(
                "Expecting an Object but got: ``val``");
        }
    }
    
    "Returns an [[Array]] value, unless the key does not 
     exist, or the value is null."
    throws(`class InvalidTypeException`,
        "If the key points to a type that is neither 
         [[Array]] nor [[Null]].")
    shared Array? getArrayOrNull(String key){
        value val = get(key);
        if(is Array? val){
            return val;
        }
        else {
            throw InvalidTypeException(
                "Expecting an Array but got: ``val``");
        }
    }
}