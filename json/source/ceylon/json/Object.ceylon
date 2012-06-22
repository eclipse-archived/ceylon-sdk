import ceylon.collection { ... }

by "Stéphane Épardaud"
doc "Represents a JSON Object"
shared class Object() satisfies Iterable<String> {
    
    MutableMap<String, String|Boolean|Integer|Float|Object|Array|NullInstance> contents = HashMap<String, String|Boolean|Integer|Float|Object|Array|NullInstance>();
    
    doc "Adds a new property mapping"
    shared void put(String key, String|Boolean|Integer|Float|Object|Array|Nothing val){
        if(exists val){
            contents.put(key, val);
        }else{
            contents.put(key, nullInstance);
        }
    }

    doc "Gets a property value by name"
    shared String|Boolean|Integer|Float|Object|Array|Nothing get(String key){
        value val = contents[key];
        if(is NullInstance val){
            return null;
        }
        switch(val)
        case (is String|Boolean|Integer|Float|Object|Array) {
            return val;
        }else{
            // key does not exist
            return null;
        }
    }
    
    doc "Returns the number of properties"
    shared Integer size {
        return contents.size;
    }

    doc "Returns true if the given property is defined, even if it's set to `null`"
    shared Boolean defines(String key){
        return contents.defines(key);
    }

    doc "Returns true if this object has no properties"
    shared actual Boolean empty {
        return contents.empty;
    }
    
    doc "Returns a iterator for the property names"
    shared actual Iterator<String> iterator {
        return contents.keys.iterator;
    }
    
    doc "Returns a serialised JSON representation"
    shared actual String string {
        StringPrinter p = StringPrinter();
        p.printObject(this);
        return p.string;
    }
            
}