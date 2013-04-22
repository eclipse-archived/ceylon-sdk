import ceylon.language { LangObject = Object }
import ceylon.collection { ... }

by "Stéphane Épardaud"
doc "Represents a JSON Array"
shared class Array({String|Boolean|Integer|Float|Object|Array|NullInstance*} values = {}) 
    satisfies MutableList<String|Boolean|Integer|Float|Object|Array|NullInstance> {
    
    value list = LinkedList<String|Boolean|Integer|Float|Object|Array|NullInstance>(values);
    
    shared actual Iterator<String|Boolean|Integer|Float|Object|Array|NullInstance> iterator() => list.iterator();
    
    doc "Adds a new value at the end of this array"
    shared actual void add(String|Boolean|Integer|Float|Object|Array|NullInstance val){
        list.add(val);
    }
    
    doc "Gets the value at the given index, or `null` if it does not exist"
    shared actual String|Boolean|Integer|Float|Object|Array|NullInstance|Null get(Integer index){
        return list[index];
    }
    
    doc "Returns the number of elements in this array"
    shared actual Integer size {
        return list.size;
    }

    doc "Returns a serialised JSON representation"
    shared actual String string {
        StringPrinter p = StringPrinter();
        p.printArray(this);
        return p.string;
    }

    doc "Returns a pretty-printed serialised JSON representation"
    shared String pretty {
        StringPrinter p = StringPrinter(true);
        p.printArray(this);
        return p.string;
    }

    shared actual Array clone {
        return Array(list);
    }

    shared actual Integer? lastIndex {
        return list.lastIndex;
    }
    
    shared actual Array reversed {
        return Array(list.reversed);
    }
    
    shared actual Array rest {
        return Array(list.rest);
    }
    
    shared actual Array segment(Integer from, Integer length) {
        return Array(list.segment(from, length));
    }
    
    shared actual Array span(Integer from, Integer to) {
        return Array(list.span(from, to));
    }
    
    shared actual Array spanFrom(Integer from) {
        return Array(list.spanFrom(from));
    }
    
    shared actual Array spanTo(Integer to) {
        return Array(list.spanTo(to));
    }
    
    shared actual void addAll({<String|Boolean|Integer|Float|Object|Array|NullInstance>*} values) {
        list.addAll(values);
    }
    
    shared actual void clear() {
        list.clear();
    }
    
    shared actual void insert(Integer index, String|Boolean|Integer|Float|Object|Array|NullInstance val) {
        list.insert(index, val);
    }
    
    shared actual void remove(Integer index) {
        list.remove(index);
    }

    shared actual void removeElement(String|Boolean|Integer|Float|Object|Array|NullInstance val) {
        list.removeElement(val);
    }
    
    shared actual void set(Integer index, String|Boolean|Integer|Float|Object|Array|NullInstance val) {
        list.set(index, val);
    }
    
    shared actual Integer hash {
        return list.hash;
    }
    
    shared actual Boolean equals(LangObject that) {
        if(is Array that){
            return that === this || list == that.list;
        }
        return false;
    }
    
    // auto-casting
    
    throws(InvalidTypeException)
    Object checkObject(LangObject val){
        if(is Object val){
            return val;
        }
        throw InvalidTypeException("Expecting Object but got `` val ``");
    }

    doc "Returns this array as a sequence of [[Object]] elements."
    throws(InvalidTypeException,
        "If one element in this array is not an [[Object]].")
    shared Iterable<Object> objects {
        return { for (elem in list) checkObject(elem) };
    }

    throws(InvalidTypeException)
    String checkString(LangObject val){
        if(is String val){
            return val;
        }
        throw InvalidTypeException("Expecting String but got `` val ``");
    }

    doc "Returns this array as a sequence of [[String]] elements."
    throws(InvalidTypeException,
        "If one element in this array is not a [[String]].")
    shared Iterable<String> strings {
        return { for (elem in list) checkString(elem) };
    }

    throws(InvalidTypeException)
    Integer checkInteger(LangObject val){
        if(is Integer val){
            return val;
        }
        throw InvalidTypeException("Expecting Integer but got `` val ``");
    }

    doc "Returns this array as a sequence of [[Integer]] elements."
    throws(InvalidTypeException,
        "If one element in this array is not a [[Integer]].")
    shared Iterable<Integer> integers {
        return { for (elem in list) checkInteger(elem) };
    }

    throws(InvalidTypeException)
    Float checkFloat(LangObject val){
        if(is Float val){
            return val;
        }
        throw InvalidTypeException("Expecting Float but got `` val ``");
    }

    doc "Returns this array as a sequence of [[Float]] elements."
    throws(InvalidTypeException,
        "If one element in this array is not a [[Float]].")
    shared Iterable<Float> floats {
        return { for (elem in list) checkFloat(elem) };
    }

    throws(InvalidTypeException)
    Boolean checkBoolean(LangObject val){
        if(is Boolean val){
            return val;
        }
        throw InvalidTypeException("Expecting Boolean but got `` val ``");
    }

    doc "Returns this array as a sequence of [[Boolean]] elements."
    throws(InvalidTypeException,
        "If one element in this array is not a [[Boolean]].")
    shared Iterable<Boolean> booleans {
        return { for (elem in list) checkBoolean(elem) };
    }

    throws(InvalidTypeException)
    Array checkArray(LangObject val){
        if(is Array val){
            return val;
        }
        throw InvalidTypeException("Expecting Array but got `` val ``");
    }

    doc "Returns this array as a sequence of [[Array]] elements."
    throws(InvalidTypeException,
        "If one element in this array is not an [[Array]].")
    shared Iterable<Array> arrays {
        return { for (elem in list) checkArray(elem) };
    }
}