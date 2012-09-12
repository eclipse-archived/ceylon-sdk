import ceylon.language { LangObject = Object }
import ceylon.collection { ... }

by "Stéphane Épardaud"
doc "Represents a JSON Array"
shared class Array(String|Boolean|Integer|Float|Object|Array|NullInstance... values) 
    satisfies MutableList<String|Boolean|Integer|Float|Object|Array|NullInstance> {
    
    value list = LinkedList<String|Boolean|Integer|Float|Object|Array|NullInstance>();
    
    for(val in values){
        list.add(val);
    }
    
    doc "Adds a new value at the end of this array"
    shared actual void add(String|Boolean|Integer|Float|Object|Array|NullInstance val){
        list.add(val);
    }
    
    doc "Gets the value at the given index, or `null` if it does not exist"
    shared actual String|Boolean|Integer|Float|Object|Array|NullInstance|Nothing item(Integer index){
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
        return Array(list...);
    }

    shared actual Integer? lastIndex {
        return list.lastIndex;
    }
    
    shared actual Array reversed {
        return Array(list.reversed...);
    }
    
    shared actual Array segment(Integer from, Integer length) {
        return Array(list.segment(from, length)...);
    }
    
    shared actual Array span(Integer from, Integer? to) {
        return Array(list.span(from, to)...);
    }
    
    shared actual void addAll(String|Boolean|Integer|Float|Object|Array|NullInstance... values) {
        list.addAll(values...);
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
    
    shared actual void setItem(Integer index, String|Boolean|Integer|Float|Object|Array|NullInstance val) {
        list.setItem(index, val);
    }
    
    shared actual Integer hash {
        return list.hash;
    }
    
    shared actual Boolean equals(LangObject that) {
        if(is Array that){
            return that === this || list.equalsTemp(that.list);
        }
        return false;
    }
}