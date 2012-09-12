import ceylon.collection { ... }
import ceylon.language { LangObject = Object }

by "Stéphane Épardaud"
doc "Represents a JSON Object"
shared class Object(Entry<String, String|Boolean|Integer|Float|Object|Array|NullInstance>... values) 
    satisfies MutableMap<String, String|Boolean|Integer|Float|Object|Array|NullInstance> {
    
    value contents = HashMap<String, String|Boolean|Integer|Float|Object|Array|NullInstance>();
    
    for(val in values){
        contents.put(val.key, val.item);
    }
    
    doc "Returns a serialised JSON representation"
    shared actual String string {
        StringPrinter p = StringPrinter();
        p.printObject(this);
        return p.string;
    }

    doc "Returns a pretty-printed serialised JSON representation"
    shared String pretty {
        StringPrinter p = StringPrinter(true);
        p.printObject(this);
        return p.string;
    }
    
    shared actual void clear() {
        contents.clear();
    }
    
    shared actual Object clone {
        return Object(contents...);
    }
    
    shared actual Nothing|String|Boolean|Integer|Float|Object|Array|NullInstance item(LangObject key) {
        return contents[key];
    }
    
    shared actual Iterator<Entry<String,String|Boolean|Integer|Float|Object|Array|NullInstance>> iterator {
        return contents.iterator;
    }
    
    shared actual void put(String key, String|Boolean|Integer|Float|Object|Array|NullInstance item) {
        contents.put(key, item);
    }
    
    shared actual void putAll(Entry<String,String|Boolean|Integer|Float|Object|Array|NullInstance>... entries) {
        contents.putAll(entries...);
    }
    
    shared actual void remove(String key) {
        contents.remove(key);
    }
    
    shared actual Integer size {
        return contents.size;
    }
    
    shared actual Integer hash {
        return contents.hash;
    }
    
    shared actual Boolean equals(LangObject that) {
        if(is Object that){
            return this === that || contents.equalsTemp(that.contents);
        }
        return false;
    }
}