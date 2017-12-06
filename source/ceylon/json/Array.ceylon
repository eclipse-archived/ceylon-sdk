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

"Alternative name for [[Array]] which avoids collision with
 ceylon.language::Array."
shared class JsonArray({Value*} values) => Array(values);

"Represents a JSON Array"
by("Stéphane Épardaud")
shared class Array({Value*} values = {}) 
    satisfies MutableList<Value> {
    
    value list = LinkedList<Value>(values);
    
    iterator() => list.iterator();
    
    getFromFirst(Integer index) => list.getFromFirst(index);
    
    "Adds a new value at the end of this array"
    shared actual void add(Value val) => list.add(val);
    
    "Returns the number of elements in this array"
    shared actual Integer size => list.size;

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

    shared actual Array clone() => Array(list);

    shared actual Integer? lastIndex => list.lastIndex;
    
    shared actual Array reversed => Array(list.reversed);
    
    shared actual Array rest => Array(list.rest);
    
    shared actual Array measure(Integer from, Integer length) 
            => Array(list.measure(from, length));
    
    shared actual Array span(Integer from, Integer to) 
            => Array(list.span(from, to));
    
    shared actual Array spanFrom(Integer from) 
            => Array(list.spanFrom(from));
    
    shared actual Array spanTo(Integer to) 
            => Array(list.spanTo(to));
    
    addAll({Value*} values) => list.addAll(values);
    
    clear() => list.clear();
    
    insert(Integer index, Value val) 
            => list.insert(index, val);
    
    insertAll(Integer index, {Value*} elements)
            => list.insertAll(index, elements);
    
    delete(Integer index) => list.delete(index);
    
    deleteMeasure(Integer from, Integer length) 
            => list.deleteMeasure(from, length);
    
    deleteSpan(Integer from, Integer to) 
            => list.deleteSpan(from, to);
    
    remove(ObjectValue val) => list.remove(val);
    
    removeAll({ObjectValue*} elements) => list.removeAll(elements);
    
    removeFirst(ObjectValue element) => list.removeFirst(element);
    
    removeLast(ObjectValue element) => list.removeLast(element);
    
    prune() => list.prune();
    
    truncate(Integer size) => list.truncate(size);
    
    replace(ObjectValue val, Value newVal) 
            => list.replace(val, newVal);
    
    replaceFirst(ObjectValue element, Value replacement) 
            => list.replaceFirst(element, replacement);
    
    replaceLast(ObjectValue element, Value replacement) 
            => list.replaceLast(element, replacement);
    
    infill(Value replacement) => list.infill(replacement);
    
    set(Integer index, Value val) => list.set(index, val);
    
    hash => list.hash;
    
    equals(LangObject that)
            => if(is Array that)
            then this === that || list == that.list
            else list == that;
    
    // auto-casting
    
    throws(`class InvalidTypeException`)
    Object checkObject(Value val){
        if(is Object val){
            return val;
        }
        throw InvalidTypeException(
            "Expecting Object but got `` val else "null" ``");
    }

    "Returns this array as a sequence of [[Object]] elements."
    throws(`class InvalidTypeException`,
        "If one element in this array is not an [[Object]].")
    shared Iterable<Object> objects 
            => { for (elem in list) checkObject(elem) };

    throws(`class InvalidTypeException`)
    String checkString(Value val){
        if(is String val){
            return val;
        }
        throw InvalidTypeException(
            "Expecting String but got `` val else "null" ``");
    }

    "Returns this array as a sequence of [[String]] elements."
    throws(`class InvalidTypeException`,
        "If one element in this array is not a [[String]].")
    shared Iterable<String> strings 
            => { for (elem in list) checkString(elem) };

    throws(`class InvalidTypeException`)
    Integer checkInteger(Value val){
        if(is Integer val){
            return val;
        }
        throw InvalidTypeException(
            "Expecting Integer but got `` val else "null" ``");
    }

    "Returns this array as a sequence of [[Integer]] elements."
    throws(`class InvalidTypeException`,
        "If one element in this array is not a [[Integer]].")
    shared Iterable<Integer> integers 
            => { for (elem in list) checkInteger(elem) };

    throws(`class InvalidTypeException`)
    Float checkFloat(Value val){
        if(is Float val){
            return val;
        }
        throw InvalidTypeException(
            "Expecting Float but got `` val else "null" ``");
    }

    "Returns this array as a sequence of [[Float]] elements."
    throws(`class InvalidTypeException`,
        "If one element in this array is not a [[Float]].")
    shared Iterable<Float> floats 
            => { for (elem in list) checkFloat(elem) };

    throws(`class InvalidTypeException`)
    Boolean checkBoolean(Value val){
        if(is Boolean val){
            return val;
        }
        throw InvalidTypeException(
            "Expecting Boolean but got `` val else "null" ``");
    }

    "Returns this array as a sequence of [[Boolean]] elements."
    throws(`class InvalidTypeException`,
        "If one element in this array is not a [[Boolean]].")
    shared Iterable<Boolean> booleans 
            => { for (elem in list) checkBoolean(elem) };

    throws(`class InvalidTypeException`)
    Array checkArray(Value val){
        if(is Array val){
            return val;
        }
        throw InvalidTypeException(
            "Expecting Array but got `` val else "null" ``");
    }

    "Returns this array as a sequence of [[Array]] elements."
    throws(`class InvalidTypeException`,
        "If one element in this array is not an [[Array]].")
    shared Iterable<Array> arrays 
            => { for (elem in list) checkArray(elem) };
    
    findAndRemoveFirst(Boolean selecting(Value&LangObject element)) 
            => list.findAndRemoveFirst(selecting);
    
    findAndRemoveLast(Boolean selecting(Value&LangObject element)) 
            => list.findAndRemoveLast(selecting);
    
    findAndReplaceFirst(Boolean selecting(Value&LangObject element), Value replacement) 
            => list.findAndReplaceFirst(selecting, replacement);
    
    findAndReplaceLast(Boolean selecting(Value&LangObject element), Value replacement) 
            => list.findAndReplaceLast(selecting, replacement);
    
    removeWhere(Boolean selecting(Value&LangObject element)) 
            => list.removeWhere(selecting);
    
    replaceWhere(Boolean selecting(Value&LangObject element), Value replacement) 
            => list.replaceWhere(selecting, replacement);
    
    
}