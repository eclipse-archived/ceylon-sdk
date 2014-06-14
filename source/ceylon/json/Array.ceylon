import ceylon.collection {
    ...
}
import ceylon.language {
    LangObject=Object
}

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
        StringPrinter p = StringPrinter();
        p.printArray(this);
        return p.string;
    }

    "Returns a pretty-printed serialised JSON representation"
    shared String pretty {
        StringPrinter p = StringPrinter(true);
        p.printArray(this);
        return p.string;
    }

    shared actual Array clone() => Array(list);

    shared actual Integer? lastIndex => list.lastIndex;
    
    shared actual Array reversed => Array(list.reversed);
    
    shared actual Array rest => Array(list.rest);
    
    shared actual Array segment(Integer from, Integer length) 
            => Array(list.segment(from, length));
    
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
    
    delete(Integer index) => list.delete(index);
    
    deleteSegment(Integer from, Integer length) 
            => list.deleteSegment(from, length);
    
    deleteSpan(Integer from, Integer to) 
            => list.deleteSpan(from, to);
    
    remove(Value val) => list.remove(val);
    
    removeAll({Value*} elements) => list.removeAll(elements);
    
    removeFirst(Value element) => list.removeFirst(element);
    
    removeLast(Value element) => list.removeLast(element);
    
    prune() => list.prune();
    
    truncate(Integer size) => list.truncate(size);
    
    replace(Value val, Value newVal) 
            => list.replace(val, newVal);
    
    replaceFirst(Value element, Value replacement) 
            => list.replaceFirst(element, replacement);
    
    replaceLast(Value element, Value replacement) 
            => list.replaceLast(element, replacement);
    
    infill(Value replacement) => list.infill(replacement);
    
    set(Integer index, Value val) => list.set(index, val);
    
    hash => list.hash;
    
    shared actual Boolean equals(LangObject that) {
        if(is Array that){
            return that === this || list == that.list;
        }
        return false;
    }
    
    // auto-casting
    
    throws(`class InvalidTypeException`)
    Object checkObject(LangObject val){
        if(is Object val){
            return val;
        }
        throw InvalidTypeException(
            "Expecting Object but got `` val ``");
    }

    "Returns this array as a sequence of [[Object]] elements."
    throws(`class InvalidTypeException`,
        "If one element in this array is not an [[Object]].")
    shared Iterable<Object> objects 
            => { for (elem in list) checkObject(elem) };

    throws(`class InvalidTypeException`)
    String checkString(LangObject val){
        if(is String val){
            return val;
        }
        throw InvalidTypeException(
            "Expecting String but got `` val ``");
    }

    "Returns this array as a sequence of [[String]] elements."
    throws(`class InvalidTypeException`,
        "If one element in this array is not a [[String]].")
    shared Iterable<String> strings 
            => { for (elem in list) checkString(elem) };

    throws(`class InvalidTypeException`)
    Integer checkInteger(LangObject val){
        if(is Integer val){
            return val;
        }
        throw InvalidTypeException(
            "Expecting Integer but got `` val ``");
    }

    "Returns this array as a sequence of [[Integer]] elements."
    throws(`class InvalidTypeException`,
        "If one element in this array is not a [[Integer]].")
    shared Iterable<Integer> integers 
            => { for (elem in list) checkInteger(elem) };

    throws(`class InvalidTypeException`)
    Float checkFloat(LangObject val){
        if(is Float val){
            return val;
        }
        throw InvalidTypeException(
            "Expecting Float but got `` val ``");
    }

    "Returns this array as a sequence of [[Float]] elements."
    throws(`class InvalidTypeException`,
        "If one element in this array is not a [[Float]].")
    shared Iterable<Float> floats 
            => { for (elem in list) checkFloat(elem) };

    throws(`class InvalidTypeException`)
    Boolean checkBoolean(LangObject val){
        if(is Boolean val){
            return val;
        }
        throw InvalidTypeException(
            "Expecting Boolean but got `` val ``");
    }

    "Returns this array as a sequence of [[Boolean]] elements."
    throws(`class InvalidTypeException`,
        "If one element in this array is not a [[Boolean]].")
    shared Iterable<Boolean> booleans 
            => { for (elem in list) checkBoolean(elem) };

    throws(`class InvalidTypeException`)
    Array checkArray(LangObject val){
        if(is Array val){
            return val;
        }
        throw InvalidTypeException(
            "Expecting Array but got `` val ``");
    }

    "Returns this array as a sequence of [[Array]] elements."
    throws(`class InvalidTypeException`,
        "If one element in this array is not an [[Array]].")
    shared Iterable<Array> arrays 
            => { for (elem in list) checkArray(elem) };
    
}